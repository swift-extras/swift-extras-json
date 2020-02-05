
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
  
  @inlinable mutating func readUTF8StringTillNextUnescapedQuote() throws -> String {
    precondition(self.value == UInt8(ascii: "\""), "Expected to have read a quote character last")
    let stringStartIndex = self.index + 1
    
    while let (byte, index) = self.read() {
      switch byte {
      case UInt8(ascii: "\""):
        return makeStringFast(array[stringStartIndex..<index])
      case UInt8(ascii: "\\"):
        // escape character... next character is appended without looking at it
        guard let _ = self.read() else {
          throw JSONError.unexpectedEndOfFile
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
  @inlinable func makeStringFast<Bytes: Collection>(_ bytes: Bytes) -> String  where Bytes.Element == UInt8 {
      if let string = bytes.withContiguousStorageIfAvailable({
          return String(decoding: $0, as: Unicode.UTF8.self)
      }) {
          return string
      } else {
          return String(decoding: bytes, as: Unicode.UTF8.self)
      }
  }
}

