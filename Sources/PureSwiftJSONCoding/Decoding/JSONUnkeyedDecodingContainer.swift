import PureSwiftJSONParsing

struct JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  
  let impl      : JSONDecoderImpl
  let codingPath: [CodingKey]
  let value     : JSONValue
  let array     : [JSONValue]
  
  let count        : Int?
  var isAtEnd      = false
  var currentIndex = 0
  
  init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
    self.impl       = impl
    self.codingPath = codingPath
    self.value      = json
    
    switch json {
    case .array(let array):
      self.array = array
      self.count = array.count
    default:
      preconditionFailure()
    }
  }
  
  mutating func decodeNil() throws -> Bool {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    switch array[currentIndex] {
    case .null:
      return true
    default:
      preconditionFailure()
    }
  }
  
  mutating func decode(_ type: Bool.Type) throws -> Bool {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    switch array[currentIndex] {
    case .bool(let bool):
      return bool
    default:
      preconditionFailure()
    }
  }
  
  mutating func decode(_ type: String.Type) throws -> String {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    switch array[currentIndex] {
    case .string(let string):
      return string
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
  
  mutating func decode(_ type: Double.Type) throws -> Double {
    return try self.decodeLosslessStringConvertible()
  }
  
  mutating func decode(_ type: Float.Type) throws -> Float {
    return try self.decodeLosslessStringConvertible()
  }
  
  mutating func decode(_ type: Int.Type) throws -> Int {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: Int8.Type) throws -> Int8 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: Int16.Type) throws -> Int16 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: Int32.Type) throws -> Int32 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: Int64.Type) throws -> Int64 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: UInt.Type) throws -> UInt {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    return try self.decodeFixedWithInteger()
  }
  
  mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    let newKey  = ArrayKey(index: currentIndex)
    let decoder = try impl.decoderForKey(newKey)
    
    return try T.init(from: decoder)
  }
  
  mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
    -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
  {
    return try impl.container(keyedBy: type)
  }
  
  mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    return try impl.unkeyedContainer()
  }
  
  mutating func superDecoder() throws -> Decoder {
    return impl
  }
}

extension JSONUnkeyedDecodingContainer {
  
  @inline(__always) private mutating func decodeFixedWithInteger<T: FixedWidthInteger>() throws
    -> T
  {
    defer {
      currentIndex += 1
      if currentIndex == count {
        isAtEnd = true
      }
    }
    
    switch array[currentIndex] {
    case .number(let string):
      guard let number = T(string) else {
        throw JSONDecoder.Error.invalidType
      }
      return number
    default:
      throw JSONDecoder.Error.invalidType
    }
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
    
    switch array[currentIndex] {
    case .number(let string):
      guard let number = T(string) else {
        throw JSONDecoder.Error.invalidType
      }
      return number
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
}
