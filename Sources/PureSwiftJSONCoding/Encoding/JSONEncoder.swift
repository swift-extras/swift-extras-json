import PureSwiftJSONParsing

enum JSONFuture {
  case value(JSONValue)
  case nestedArray(JSONArray)
  case nestedObject(JSONObject)
}

class JSONArray {
  
  private(set) var array: [JSONFuture] = []
  
  init() {
    array.reserveCapacity(10)
  }
  
  @inline(__always) func append(_ element: JSONValue) {
    self.array.append(.value(element))
  }
  
  @inline(__always) func appendArray() -> JSONArray {
    let array = JSONArray()
    self.array.append(.nestedArray(array))
    return array
  }
  
  @inline(__always) func appendObject() -> JSONObject {
    let object = JSONObject()
    self.array.append(.nestedObject(object))
    return object
  }
  
  var values: [JSONValue] {
    self.array.map { (future) -> JSONValue in
      switch future {
      case .value(let value):
        return value
      case .nestedArray(let array):
        return .array(array.values)
      case .nestedObject(let object):
        return .object(object.values)
      }
    }
  }
}

class JSONObject {
  
  private(set) var dict: [String: JSONFuture] = [:]
  
  init() {
    dict.reserveCapacity(20)
  }
  
  @inline(__always) func set(_ value: JSONValue, for key: String) {
    self.dict[key] = .value(value)
  }
  
  @inline(__always) func setArray(for key: String) -> JSONArray {
    if case .nestedArray(let array) = self.dict[key] {
      return array
    }
    
    if case .nestedObject(_) = self.dict[key] {
      preconditionFailure("For key \"\(key)\" a keyed container has already been created.")
    }
    
    let array = JSONArray()
    self.dict[key] = .nestedArray(array)
    return array
  }
  
  @inline(__always) func setObject(for key: String) -> JSONObject {
    if case .nestedObject(let object) = self.dict[key] {
      return object
    }
    
    if case .nestedArray(_) = self.dict[key] {
      preconditionFailure("For key \"\(key)\" an unkeyed container has already been created.")
    }
    
    let object = JSONObject()
    self.dict[key] = .nestedObject(object)
    return object
  }
  
  var values: [String: JSONValue] {
    self.dict.mapValues { (future) -> JSONValue in
      switch future {
      case .value(let value):
        return value
      case .nestedArray(let array):
        return .array(array.values)
      case .nestedObject(let object):
        return .object(object.values)
      }
    }
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
  var array      : JSONArray?
  var object     : JSONObject?
  
  var value: JSONValue? {
    if let object = self.object {
      return .object(object.values)
    }
    if let array = self.array {
      return .array(array.values)
    }
    return self.singleValue
  }
  
  init(userInfo: [CodingUserInfoKey : Any], codingPath : [CodingKey]) {
    self.userInfo   = userInfo
    self.codingPath = codingPath
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
    
    self.object = JSONObject()
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
    
    self.array = JSONArray()
    return JSONUnkeyedEncodingContainer(impl: self, codingPath: codingPath)
  }
  
  func singleValueContainer() -> SingleValueEncodingContainer {
    guard self.object == nil, self.array == nil else {
      preconditionFailure()
    }
    
    return JSONSingleValueEncodingContainer(impl: self, codingPath: codingPath)
  }
}
