
struct JSONKeyedEncodingContainer<K: CodingKey>: KeyedEncodingContainerProtocol {
  typealias Key = K
  
  let impl      : JSONEncoderImpl
  let object    : JSONObject
  let codingPath: [CodingKey]
  
  private var firstValueWritten: Bool = false
  
  init(impl: JSONEncoderImpl, codingPath: [CodingKey]) {
    self.impl       = impl
    self.object     = impl.object!
    self.codingPath = codingPath
  }
  
  // used for nested containers
  init(impl: JSONEncoderImpl, object: JSONObject, codingPath: [CodingKey]) {
    self.impl       = impl
    self.object     = object
    self.codingPath = codingPath
  }

  mutating func encodeNil(forKey key: Self.Key) throws {
    
  }

  mutating func encode(_ value: Bool, forKey key: Self.Key) throws {
    self.object.set(.bool(value), for: key.stringValue)
  }

  mutating func encode(_ value: String, forKey key: Self.Key) throws {
    self.object.set(.string(value), for: key.stringValue)
  }

  mutating func encode(_ value: Double, forKey key: Self.Key) throws {
    try encodeFloatingPoint(value, key: key)
  }

  mutating func encode(_ value: Float, forKey key: Self.Key) throws {
    try encodeFloatingPoint(value, key: key)
  }

  mutating func encode(_ value: Int, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: Int8, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: Int16, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: Int32, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: Int64, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: UInt, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: UInt8, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: UInt16, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: UInt32, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode(_ value: UInt64, forKey key: Self.Key) throws {
    try encodeFixedWidthInteger(value, key: key)
  }

  mutating func encode<T>(_ value: T, forKey key: Self.Key) throws where T : Encodable {
    let newPath    = impl.codingPath + [key]
    let newEncoder = JSONEncoderImpl(userInfo: impl.userInfo, codingPath: newPath)
    try value.encode(to: newEncoder)
    
    guard let value = newEncoder.value else {
      preconditionFailure()
    }
    
    self.object.set(value, for: key.stringValue)
  }
  
  mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Self.Key) ->
    KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey
  {
    let newPath = impl.codingPath + [key]
    let object = self.object.setObject(for: key.stringValue)
    let nestedContainer = JSONKeyedEncodingContainer<NestedKey>(impl: self.impl, object: object, codingPath: newPath)
    return KeyedEncodingContainer(nestedContainer)
  }

  mutating func nestedUnkeyedContainer(forKey key: Self.Key) -> UnkeyedEncodingContainer {
    let newPath = impl.codingPath + [key]
    let array = self.object.setArray(for: key.stringValue)
    let nestedContainer = JSONUnkeyedEncodingContainer(impl: self.impl, array: array, codingPath: newPath)
    return nestedContainer
  }

  mutating func superEncoder() -> Encoder {
    return self.impl
  }

  mutating func superEncoder(forKey key: Self.Key) -> Encoder {
    return self.impl
  }
}

extension JSONKeyedEncodingContainer {
  
  @inline(__always) private mutating func encodeFixedWidthInteger<N: FixedWidthInteger>(_ value: N, key: Self.Key) throws {
    self.object.set(.number(value.description), for: key.stringValue)
  }
  
  @inline(__always) private mutating func encodeFloatingPoint<N: FloatingPoint>(_ value: N, key: Self.Key)
    throws where N: CustomStringConvertible
  {
    self.object.set(.number(value.description), for: key.stringValue)
  }

}

