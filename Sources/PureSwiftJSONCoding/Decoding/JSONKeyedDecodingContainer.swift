import PureSwiftJSONParsing

struct JSONKeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
  typealias Key = K
  
  let impl      : JSONDecoderImpl
  let codingPath: [CodingKey]
  let value     : JSONValue
  let dictionary: [String: JSONValue]
  
  init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
    self.impl       = impl
    self.codingPath = codingPath
    self.value      = json
    
    switch json {
    case .object(let dictionary):
      self.dictionary = dictionary
    default:
      preconditionFailure()
    }
  }
  
  var allKeys: [K] {
    return self.dictionary.keys.compactMap { K(stringValue: $0) }
  }
  
  func contains(_ key: K) -> Bool {
    if let _ = self.dictionary[key.stringValue] {
      return true
    }
    return false
  }
  
  func decodeNil(forKey key: K) throws -> Bool {
    switch self.dictionary[key.stringValue] {
    case .null:
      return true
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
  
  func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
    switch self.dictionary[key.stringValue] {
    case .bool(let bool):
      return bool
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
  
  func decode(_ type: String.Type, forKey key: K) throws -> String {
    switch self.dictionary[key.stringValue] {
    case .string(let string):
      return string
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
  
  func decode(_ type: Double.Type, forKey key: K) throws -> Double {
    return try self.decodeLosslessStringConvertible(key: key)
  }
  
  func decode(_ type: Float.Type, forKey key: K) throws -> Float {
    return try self.decodeLosslessStringConvertible(key: key)
  }
  
  func decode(_ type: Int.Type, forKey key: K) throws -> Int {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
    return try self.decodeFixedWidthInteger(key: key)
  }
  
  func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
    let decoder = try impl.decoderForKey(key)
    return try T.init(from: decoder)
  }
  
  func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws
    -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey
  {
    return try impl.decoderForKey(key).container(keyedBy: type)
  }
  
  func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
    return try impl.decoderForKey(key).unkeyedContainer()
  }
  
  func superDecoder() throws -> Decoder {
    return impl
  }
  
  func superDecoder(forKey key: K) throws -> Decoder {
    return impl
  }
}

extension JSONKeyedDecodingContainer {
  
  @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key)
    throws -> T
  {
    switch self.dictionary[key.stringValue] {
    case .number(let string):
      guard let number = T(string) else {
        throw JSONDecoder.Error.invalidType
      }
      return number
    default:
      throw JSONDecoder.Error.invalidType
    }
  }
  
  @inline(__always) private func decodeLosslessStringConvertible<T: LosslessStringConvertible>(
    key: Self.Key) throws -> T
  {
    switch self.dictionary[key.stringValue] {
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
