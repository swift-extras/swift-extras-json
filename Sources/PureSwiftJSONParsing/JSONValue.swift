
public enum JSONError: Swift.Error, Equatable {
  case unexpectedCharacter(ascii: UInt8, characterIndex: Int)
  case unexpectedEndOfFile
  case tooManyNestedArraysOrDictionaries(characterIndex: Int)
  case invalidHexDigitSequence(String, index: Int)
  case unexpectedEscapedCharacter(ascii: UInt8, in: String, index: Int)
  case unescapedControlCharacterInString(ascii: UInt8, in: String, index: Int)
  case expectedLowSurrogateUTF8SequenceAfterHighSurrogate(in: String, index: Int)
  case couldNotCreateUnicodeScalarFromUInt32(in: String, index: Int, unicodeScalarValue: UInt32)
  case numberWithLeadingZero(index: Int)
}

public enum JSONValue {
  
  case string(String)
  case number(String)
  case bool(Bool)
  case null
  
  case array([JSONValue])
  case object([String: JSONValue])
  
}

extension JSONValue {
  
  public func appendBytes(to bytes: inout [UInt8]) {
    
    switch self {
    case .null:
      bytes.append(contentsOf: [
        UInt8(ascii: "n"), UInt8(ascii: "u"), UInt8(ascii: "l"), UInt8(ascii: "l")
      ])
    case .bool(true):
      bytes.append(contentsOf: [
        UInt8(ascii: "t"), UInt8(ascii: "r"), UInt8(ascii: "u"), UInt8(ascii: "e")
      ])
    case .bool(false):
      bytes.append(contentsOf: [
        UInt8(ascii: "f"), UInt8(ascii: "a"), UInt8(ascii: "l"), UInt8(ascii: "s"), UInt8(ascii: "e")
      ])
    case .string(let string):
      encodeString(string, to: &bytes)
    case .number(let string):
      bytes.append(contentsOf: string.utf8)
    case .array(let array):
      var iterator = array.makeIterator()
      bytes.append(UInt8(ascii: "["))
      // we don't kine branching, this is why we have this extra
      if let first = iterator.next() {
        first.appendBytes(to: &bytes)
      }
      while let item = iterator.next() {
        bytes.append(UInt8(ascii: ","))
        item.appendBytes(to: &bytes)
      }
      bytes.append(UInt8(ascii: "]"))
    case .object(let dict):
      var iterator = dict.makeIterator()
      bytes.append(UInt8(ascii: "{"))
      if let (key, value) = iterator.next() {
        encodeString(key, to: &bytes)
        bytes.append(UInt8(ascii: ":"))
        value.appendBytes(to: &bytes)
      }
      while let (key, value) = iterator.next() {
        bytes.append(UInt8(ascii: ","))
        encodeString(key, to: &bytes)
        bytes.append(UInt8(ascii: ":"))
        value.appendBytes(to: &bytes)
      }
      bytes.append(UInt8(ascii: "}"))
    }
  }
  
  private func encodeString(_ string: String, to bytes: inout [UInt8]) {
    bytes.append(UInt8(ascii: "\""))
    let stringBytes    = string.utf8
    var startCopyIndex = stringBytes.startIndex
    var nextIndex      = startCopyIndex
    
    while nextIndex != stringBytes.endIndex {
      switch stringBytes[nextIndex] {
      case 0..<32, UInt8(ascii: "\""), UInt8(ascii: "\\"):
        // All Unicode characters may be placed within the
        // quotation marks, except for the characters that MUST be escaped:
        // quotation mark, reverse solidus, and the control characters (U+0000
        // through U+001F).
        // https://tools.ietf.org/html/rfc7159#section-7
        
        // copy the current range over
        bytes.append(contentsOf: stringBytes[startCopyIndex..<nextIndex])
        bytes.append(UInt8(ascii: "\\"))
        bytes.append(stringBytes[nextIndex])
        
        nextIndex      = stringBytes.index(after: nextIndex)
        startCopyIndex = nextIndex
      default:
        nextIndex      = stringBytes.index(after: nextIndex)
      }
    }
    
    // copy everything, that hasn't been copied yet
    bytes.append(contentsOf: stringBytes[startCopyIndex..<nextIndex])
    bytes.append(UInt8(ascii: "\""))
  }
  
  public var debugDataTypeDescription: String {
    switch self {
    case .array(_):
      return "an array"
    case .bool(_):
      return "bool"
    case .number(_):
      return "a number"
    case .string(_):
      return "a string"
    case .object(_):
      return "a dictionary"
    case .null:
      return "null"
    }
  }
}

// MARK: - Protocol conformances -

// MARK: Equatable

extension JSONValue: Equatable { }

public func == (lhs: JSONValue, rhs: JSONValue) -> Bool {
  
  switch (lhs, rhs) {
  case (.null, .null):
    return true
  case (.bool(let lhs), .bool(let rhs)):
    return lhs == rhs
  case (.number(let lhs), .number(let rhs)):
    return lhs == rhs
  case (.string(let lhs), .string(let rhs)):
    return lhs == rhs
  case (.array(let lhs), .array(let rhs)):
    guard lhs.count == rhs.count else {
      return false
    }
    
    var lhsiterator = lhs.makeIterator()
    var rhsiterator = rhs.makeIterator()
    
    while let lhs = lhsiterator.next(), let rhs = rhsiterator.next() {
      if lhs == rhs {
        continue
      }
      return false
    }
    
    return true
  case (.object(let lhs), .object(let rhs)):
    guard lhs.count == rhs.count else {
      return false
    }
    
    var lhsiterator = lhs.makeIterator()
    
    while let (lhskey, lhsvalue) = lhsiterator.next() {
      guard let rhsvalue = rhs[lhskey] else {
        return false
      }
      
      if lhsvalue == rhsvalue {
        continue
      }
      return false
    }
    
    return true
  default:
    return false
  }
}
