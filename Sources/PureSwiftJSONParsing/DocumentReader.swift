
public struct DocumentReader {
  
  @usableFromInline let array: [UInt8]
  @usableFromInline let count: Int
  
  @usableFromInline /*private(set)*/ var index: Int = -1
  @usableFromInline /*private(set)*/ var value: UInt8?
  
  @inlinable public init<Bytes: Collection>(bytes: Bytes) where Bytes.Element == UInt8 {
    if let array = bytes as? [UInt8] {
      self.array = array
    }
    else {
      self.array = Array(bytes)
    }
    
    self.count = self.array.count
  }
  
  @inlinable subscript(bounds: Range<Int>) -> ArraySlice<UInt8> {
    return self.array[bounds]
  }
  
  @inlinable public mutating func read() -> (UInt8, Int)? {
    guard index < count - 1 else {
      self.value = nil
      self.index = self.array.endIndex
      return nil
    }
    
    index += 1
    value = array[index]
    
    return (value!, index)
  }
  
  @inlinable func remainingBytes(from index: Int) -> ArraySlice<UInt8> {
    return self.array.suffix(from: index)
  }
  
  @usableFromInline enum EscapedSequenceError: Swift.Error {
    case expectedLowSurrogateUTF8SequenceAfterHighSurrogate(index: Int)
    case unexpectedEscapedCharacter(ascii: UInt8, index: Int)
    case couldNotCreateUnicodeScalarFromUInt32(index: Int, unicodeScalarValue: UInt32)
  }
  
  @inlinable mutating func readUTF8StringTillNextUnescapedQuote() throws -> String {
    precondition(self.value == UInt8(ascii: "\""), "Expected to have read a quote character last")
    var stringStartIndex = self.index + 1
    var output: String?
    
    while let (byte, index) = self.read() {
      switch byte {
      case UInt8(ascii: "\""):
        guard var result = output else {
          // if we don't have an output string we create a new string
          return makeStringFast(array[stringStartIndex..<index])
        }
        // if we have an output string we append
        result += makeStringFast(array[stringStartIndex..<index])
        return result
        
      case 0...31:
        // All Unicode characters may be placed within the
        // quotation marks, except for the characters that must be escaped:
        // quotation mark, reverse solidus, and the control characters (U+0000
        // through U+001F).
        var string = output ?? ""
        string += makeStringFast(array[stringStartIndex...index])
        throw JSONError.unescapedControlCharacterInString(ascii: byte, in: string, index: index)
        
      case UInt8(ascii: "\\"):
        if output != nil {
          output! += makeStringFast(array[stringStartIndex..<index])
        }
        else {
          output = makeStringFast(array[stringStartIndex..<index])
        }
        
        do {
          let (escaped, newIndex) = try self.parseEscapeSequence()
          output! += escaped
          stringStartIndex =  newIndex + 1
        }
        catch EscapedSequenceError.unexpectedEscapedCharacter(let ascii, let failureIndex) {
          output! += makeStringFast(array[index...self.index])
          throw JSONError.unexpectedEscapedCharacter(ascii: ascii, in: output!, index: failureIndex)
        }
        catch EscapedSequenceError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(let failureIndex) {
          output! += makeStringFast(array[index...self.index])
          throw JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(in: output!, index: failureIndex)
        }
        catch EscapedSequenceError.couldNotCreateUnicodeScalarFromUInt32(let failureIndex, let unicodeScalarValue) {
          output! += makeStringFast(array[index...self.index])
          throw JSONError.couldNotCreateUnicodeScalarFromUInt32(
            in: output!, index: failureIndex, unicodeScalarValue: unicodeScalarValue)
        }
        
        
      default:
        continue
      }
    }
    
    throw JSONError.unexpectedEndOfFile
  }
  
  // can be removed as soon https://bugs.swift.org/browse/SR-12126 and
  // https://bugs.swift.org/browse/SR-12125 has landed.
  // Thanks @weissi for making my code fast!
  @inlinable func makeStringFast<Bytes: Collection>(_ bytes: Bytes) -> String where Bytes.Element == UInt8 {
      if let string = bytes.withContiguousStorageIfAvailable({
          return String(decoding: $0, as: Unicode.UTF8.self)
      }) {
          return string
      } else {
          return String(decoding: bytes, as: Unicode.UTF8.self)
      }
  }
  
  @inlinable mutating func parseEscapeSequence() throws -> (String, Int) {
    guard let (byte, index) = self.read() else {
      throw JSONError.unexpectedEndOfFile
    }
    
    switch byte {
    case 0x22: return ("\""    , index)
    case 0x5C: return ("\\"    , index)
    case 0x2F: return ("/"     , index)
    case 0x62: return ("\u{08}", index) // \b
    case 0x66: return ("\u{0C}", index) // \f
    case 0x6E: return ("\u{0A}", index) // \n
    case 0x72: return ("\u{0D}", index) // \r
    case 0x74: return ("\u{09}", index) // \t
    case 0x75:
      let (character, newIndex) = try parseUnicodeSequence()
      return (String(character), newIndex)
    default:
      throw EscapedSequenceError.unexpectedEscapedCharacter(ascii: byte, index: index)
    }
  }

  @inlinable mutating func parseUnicodeSequence() throws -> (Unicode.Scalar, Int) {
    // the unicode escape sequence has begun two chars before. \ + u
    // important only for creating good error strings.
    let startIndex = self.index - 2
    
    // we build this for utf8 only for now.
    let bitPattern = try self.parseUnicodeHexSequence()
    
    // check if high surrogate
    let isFirstByteHighSurrogate = bitPattern & 0xFC00 // nil everything except first six bits
    if isFirstByteHighSurrogate == 0xD800 {
      // if we have a high surrogate we expect a low surrogate next
      let highSurrogateBitPattern = bitPattern
      guard let (escapeChar, _) = self.read(),
            let (uChar,      _) = self.read() else
      {
        throw JSONError.unexpectedEndOfFile
      }
      
      guard escapeChar == UInt8(ascii: #"\"#), uChar == UInt8(ascii: "u") else {
        throw EscapedSequenceError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(index: self.index)
      }
      
      let lowSurrogateBitBattern = try self.parseUnicodeHexSequence()
      let isSecondByteLowSurrogate = lowSurrogateBitBattern & 0xFC00 // nil everything except first six bits
      guard isSecondByteLowSurrogate == 0xDC00 else {
        // we are in an escaped sequence. for this reason an output string must have
        // been initialized
        throw EscapedSequenceError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(index: self.index)
      }
      
      let highValue = UInt32(highSurrogateBitPattern - 0xD800) * 0x400
      let lowValue  = UInt32(lowSurrogateBitBattern - 0xDC00)
      let unicodeValue = highValue + lowValue + 0x10000
      guard let unicode = Unicode.Scalar.init(unicodeValue) else {
        throw EscapedSequenceError.couldNotCreateUnicodeScalarFromUInt32(
          index: self.index, unicodeScalarValue: unicodeValue)
      }
      return (unicode, self.index)
    }

    guard let unicode = Unicode.Scalar.init(bitPattern) else {
      throw EscapedSequenceError.couldNotCreateUnicodeScalarFromUInt32(
        index: self.index, unicodeScalarValue: UInt32(bitPattern))
    }
    return (unicode, self.index)
  }
  
  @inlinable mutating func parseUnicodeHexSequence() throws -> UInt16 {
    // As stated in RFC-7159 an escaped unicode character is 4 HEXDIGITs long
    // https://tools.ietf.org/html/rfc7159#section-7
    guard let (firstHex , startIndex) = self.read(),
          let (secondHex, _) = self.read(),
          let (thirdHex , _) = self.read(),
          let (forthHex , _) = self.read()
      else
    {
      throw JSONError.unexpectedEndOfFile
    }
    
    guard let first  = DocumentReader.hexAsciiTo4Bits(firstHex),
          let second = DocumentReader.hexAsciiTo4Bits(secondHex),
          let third  = DocumentReader.hexAsciiTo4Bits(thirdHex),
          let forth  = DocumentReader.hexAsciiTo4Bits(forthHex)
      else
    {
      let hexString = String(decoding: [firstHex, secondHex, thirdHex, forthHex], as: Unicode.UTF8.self)
      throw JSONError.invalidHexDigitSequence(hexString, index: startIndex)
    }
    let firstByte  = UInt16(first) << 4 | UInt16(second)
    let secondByte = UInt16(third) << 4 | UInt16(forth)
    
    let bitPattern = UInt16(firstByte) << 8 | UInt16(secondByte)

    return bitPattern
  }
  
  @inlinable static func hexAsciiTo4Bits(_ ascii: UInt8) -> UInt8? {
    switch ascii {
    case 48...57:
      return ascii - 48
    case 65...70:
      return ascii - 55
    default:
      return nil
    }
  }
}

