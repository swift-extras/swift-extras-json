import PureSwiftJSONParsing

public struct JSONDecoder {
  
  public enum Error: Swift.Error {
    case invalidType
    
  }
  
  private(set) var customEncoder: [String : CustomEncoder] = [:]
  
  @usableFromInline var userInfo: [CodingUserInfoKey : Any] = [:]
  
  public init() {
    
  }
  
  @inlinable public func decode<T: Decodable, Bytes: Collection>(_ type: T.Type, from bytes: Bytes)
    throws -> T where Bytes.Element == UInt8
  {
    let json = try JSONParser().parse(bytes: bytes)
    let decoder = JSONDecoderImpl(userInfo: userInfo, from: json, codingPath: [])
    
    return try decoder.decode(T.self)
  }
  
  public typealias CustomEncoder = (Encoder, [CodingKey]) throws -> ()
  public mutating func registerCustomEncoder(for type: Encodable.Type, encoder: @escaping CustomEncoder) {
    self.customEncoder[String(describing: type)] = encoder
  }
  
  public mutating func removeCustomEncoder(for type: Encodable.Type) {
    self.customEncoder[String(describing: type)] = nil
  }
}

@usableFromInline struct JSONDecoderImpl {

  @usableFromInline let codingPath: [CodingKey]
  @usableFromInline let userInfo  : [CodingUserInfoKey : Any]
  
  @usableFromInline let json      : JSONValue
  
  @inlinable init(userInfo: [CodingUserInfoKey : Any], from json: JSONValue, codingPath: [CodingKey]) {
    self.userInfo   = userInfo
    self.codingPath = codingPath
    self.json       = json
  }
  
  @inlinable public func decode<T: Decodable>(_ type: T.Type) throws -> T {
    return try T.init(from: self)
  }
  
  internal func decoderForKey<Key: CodingKey>(_ key: Key) throws -> JSONDecoderImpl {
    
    switch self.json {
    case .array(let array):
      guard let key = key as? ArrayKey else {
        #warning("we need good error handling here")
        preconditionFailure()
      }
      let json = array[key.intValue!]
      var newPath = self.codingPath
      newPath.append(key)
      
      return JSONDecoderImpl(
        userInfo  : userInfo,
        from      : json,
        codingPath: newPath)
      
    case .object(let dictionary):
      let json = dictionary[key.stringValue]!
      var newPath = self.codingPath
      newPath.append(key)
      return JSONDecoderImpl(
        userInfo  : userInfo,
        from      : json,
        codingPath: newPath)
      
    default:
      
      #warning("we need good error handling here")
      preconditionFailure()
    }
  }
}

extension JSONDecoderImpl: Decoder {
  
  @usableFromInline func container<Key>(keyedBy type: Key.Type) throws ->
    KeyedDecodingContainer<Key> where Key : CodingKey
  {
    let container = JSONKeyedDecodingContainer<Key>(
      impl      : self,
      codingPath: self.codingPath,
      json      : json)
    return KeyedDecodingContainer(container)
  }
  
  @usableFromInline func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    return JSONUnkeyedDecodingContainer(
      impl      : self,
      codingPath: codingPath,
      json      : json)
  }
  
  @usableFromInline func singleValueContainer() throws -> SingleValueDecodingContainer {
    return JSONSingleValueDecodingContainter(
      impl      : self,
      codingPath: self.codingPath,
      json      : json)
  }
}
