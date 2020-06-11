import PureSwiftJSONParsing

struct JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  
  let impl      : JSONDecoderImpl
  let codingPath: [CodingKey]
  let array     : [JSONValue]
  
  let count        : Int? // protocol requirement to be optional
  var isAtEnd      = false
  var currentIndex = 0
  
  init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
    self.impl       = impl
    self.codingPath = codingPath
    self.array      = array
    self.count      = array.count
  }
  
  mutating func decodeNil() throws -> Bool {
    if array[currentIndex] == .null {
      defer {
        currentIndex += 1
        if currentIndex == count {
          isAtEnd = true
        }
      }
      return true
    }
    
    // The protocol states:
    //   If the value is not null, does not increment currentIndex.
    return false
  }
  
  mutating func decode(_ type: Bool.Type) throws -> Bool {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    guard case .bool(let bool) = array[currentIndex] else {
      throw createTypeMismatchError(type: type, value: array[currentIndex])
    }
    
    return bool
  }
  
  mutating func decode(_ type: String.Type) throws -> String {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    guard case .string(let string) = array[currentIndex] else {
      throw createTypeMismatchError(type: type, value: array[currentIndex])
    }
    
    return string
  }
  
  mutating func decode(_ type: Double.Type) throws -> Double {
    return try self.decodeLosslessStringConvertible()
  }
  
  mutating func decode(_ type: Float.Type) throws -> Float {
    return try self.decodeLosslessStringConvertible()
  }
  
  mutating func decode(_ type: Int.Type) throws -> Int {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: Int8.Type) throws -> Int8 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: Int16.Type) throws -> Int16 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: Int32.Type) throws -> Int32 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: Int64.Type) throws -> Int64 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: UInt.Type) throws -> UInt {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try self.decodeFixedWidthInteger()
  }
  
  mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    let decoder = try self.decoderForNextElement()
    return try T.init(from: decoder)
  }
  
  mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
    -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
  {
    let decoder = try self.decoderForNextElement()
    return try decoder.container(keyedBy: type)
  }
  
  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    let decoder = try self.decoderForNextElement()
    return try decoder.unkeyedContainer()
  }
  
  mutating func superDecoder() throws -> Decoder {
    return impl
  }
}

extension JSONUnkeyedDecodingContainer {
  
  private mutating func decoderForNextElement() throws -> JSONDecoderImpl {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    let value = array[currentIndex]
    var newPath = self.codingPath
    newPath.append(ArrayKey(index: currentIndex))
    
    return JSONDecoderImpl(
      userInfo  : impl.userInfo,
      from      : value,
      codingPath: newPath)
  }

  @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
    let codingPath = self.codingPath + [ArrayKey(index: currentIndex)]
    return DecodingError.typeMismatch(type, .init(
      codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."))
  }

  
  @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws
    -> T
  {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    guard case .number(let number) = array[currentIndex] else {
      throw createTypeMismatchError(type: T.self, value: array[currentIndex])
    }
    
    guard let integer = T(number) else {
      throw DecodingError.dataCorruptedError(in: self,
        debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
    }
    
    return integer
  }
  
  @inline(__always) private mutating func decodeLosslessStringConvertible<T: LosslessStringConvertible>()
    throws -> T
  {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    guard case .number(let number) = array[currentIndex] else {
      throw createTypeMismatchError(type: T.self, value: array[currentIndex])
    }
    
    guard let float = T(number) else {
      throw DecodingError.dataCorruptedError(in: self,
        debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
    }
    
    return float
  }
}
