import PureSwiftJSONParsing

class ArrayClass {
  
  private(set) var array: [JSONValue] = []
  
  init() {
    array.reserveCapacity(10)
  }
  
  @inline(__always) func append(_ element: JSONValue) {
    self.array.append(element)
  }
}

class ObjectClass {
  
  private(set) var dict: [String: JSONValue] = [:]
  
  init() {
    dict.reserveCapacity(20)
  }
  
  @inline(__always) func set(_ value: JSONValue, for key: String) {
    self.dict[key] = value
  }
}

public class JSONEncoder {
  
  var userInfo: [CodingUserInfoKey : Any] = [:]
  
  public init() {
    
  }
  
  public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
    
    let encoder = JSONEncoderImpl(userInfo: userInfo, codingPath: [])
    
    try value.encode(to: encoder)
    
    // if the top level encoder does not have a value
    // we don't have a value at all and we should return `null`
    let value = encoder.value ?? .null
    
    var bytes = [UInt8]()
    value.appendBytes(to: &bytes)
    return bytes
  }
}

/// TBD: This could be done with a struct on the stack, by using inout references.
class JSONEncoderImpl {
  
  let userInfo   : [CodingUserInfoKey : Any]
  let codingPath : [CodingKey]
  
  var singleValue: JSONValue?
  var array      : ArrayClass?
  var object     : ObjectClass?
  
  var value: JSONValue? {
    if let object = self.object {
      return .object(object.dict)
    }
    if let array = self.array {
      return .array(array.array)
    }
    return self.singleValue
  }
  
  init(userInfo: [CodingUserInfoKey : Any], codingPath : [CodingKey]) {
    self.userInfo   = userInfo
    self.codingPath = []
  }

}

extension JSONEncoderImpl: Encoder {
  
  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    if let _ = self.object {
      let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
      return KeyedEncodingContainer(container)
    }
    
    guard self.singleValue == nil, self.array == nil else {
      preconditionFailure()
    }
    
    self.object = ObjectClass()
    let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
    return KeyedEncodingContainer(container)
  }
  
  func unkeyedContainer() -> UnkeyedEncodingContainer {
    if let _ = array {
      return JSONUnkeyedEncodingContainer(impl: self, codingPath: codingPath)
    }
    
    guard self.singleValue == nil, self.object == nil else {
      preconditionFailure()
    }
    
    self.array = ArrayClass()
    return JSONUnkeyedEncodingContainer(impl: self, codingPath: codingPath)
  }
  
  func singleValueContainer() -> SingleValueEncodingContainer {
    guard self.object == nil, self.array == nil else {
      preconditionFailure()
    }
    
    return JSONSingleValueEncodingContainer(impl: self, codingPath: codingPath)
  }
}

extension JSONEncoderImpl {
  
  func nestedContainer<NestedKey, Key>(keyedBy keyType: NestedKey.Type, forKey key: Key)
    -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey, Key : CodingKey
  {
    preconditionFailure("unimplemented")
  }

  func nestedUnkeyedContainer<Key>(forKey key: Key)
    -> UnkeyedEncodingContainer where Key : CodingKey
  {
    preconditionFailure("unimplemented")
  }
}
