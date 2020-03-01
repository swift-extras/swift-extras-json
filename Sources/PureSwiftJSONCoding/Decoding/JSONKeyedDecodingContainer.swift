import PureSwiftJSONParsing

struct JSONKeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
  typealias Key = K
  
  let impl      : JSONDecoderImpl
  let codingPath: [CodingKey]
  let dictionary: [String: JSONValue]
  
  init(impl: JSONDecoderImpl, codingPath: [CodingKey], dictionary: [String: JSONValue]) {
    self.impl       = impl
    self.codingPath = codingPath
    self.dictionary = dictionary
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
    let value = try getValue(forKey: key)
    return value == .null
  }
  
  func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
    let value = try getValue(forKey: key)
    
    guard case .bool(let bool) = value else {
      throw createTypeMismatchError(type: type, forKey: key, value: value)
    }
    
    return bool
  }
  
  func decode(_ type: String.Type, forKey key: K) throws -> String {
    let value = try getValue(forKey: key)
    
    guard case .string(let string) = value else {
      throw createTypeMismatchError(type: type, forKey: key, value: value)
    }
    
    return string
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
  
  @inline(__always) private func getValue(forKey key: K) throws -> JSONValue {
    guard let value = self.dictionary[key.stringValue] else {
      throw DecodingError.keyNotFound(key, .init(
        codingPath: self.codingPath,
        debugDescription: "No value associated with key \(key) (\"\(key.stringValue)\")."))
    }
    
    return value
  }
  
  @inline(__always) private func createTypeMismatchError(type: Any.Type, forKey key: K, value: JSONValue) -> DecodingError {
    let codingPath = self.codingPath + [key]
    return DecodingError.typeMismatch(type, .init(
      codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."))
  }
  
  @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>(key: Self.Key)
    throws -> T
  {
    let value = try getValue(forKey: key)
    
    guard case .number(let number) = value else {
      throw createTypeMismatchError(type: T.self, forKey: key, value: value)
    }
    
    guard let integer = T(number) else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
    }
    
    return integer
  }
  
  @inline(__always) private func decodeLosslessStringConvertible<T: LosslessStringConvertible>(
    key: Self.Key) throws -> T
  {
    let value = try getValue(forKey: key)
    
    guard case .number(let number) = value else {
      throw createTypeMismatchError(type: T.self, forKey: key, value: value)
    }
    
    guard let floatingPoint = T(number) else {
      throw DecodingError.dataCorruptedError(
        forKey: key,
        in: self,
        debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
    }
    
    return floatingPoint
  }
}
