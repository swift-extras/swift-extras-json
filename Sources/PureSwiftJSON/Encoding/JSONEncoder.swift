
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
        array.append(.value(element))
    }

    @inline(__always) func appendArray() -> JSONArray {
        let array = JSONArray()
        self.array.append(.nestedArray(array))
        return array
    }

    @inline(__always) func appendObject() -> JSONObject {
        let object = JSONObject()
        array.append(.nestedObject(object))
        return object
    }

    var values: [JSONValue] {
        array.map { (future) -> JSONValue in
            switch future {
            case let .value(value):
                return value
            case let .nestedArray(array):
                return .array(array.values)
            case let .nestedObject(object):
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
        dict[key] = .value(value)
    }

    @inline(__always) func setArray(for key: String) -> JSONArray {
        if case let .nestedArray(array) = dict[key] {
            return array
        }

        if case .nestedObject = dict[key] {
            preconditionFailure("For key \"\(key)\" a keyed container has already been created.")
        }

        let array = JSONArray()
        dict[key] = .nestedArray(array)
        return array
    }

    @inline(__always) func setObject(for key: String) -> JSONObject {
        if case let .nestedObject(object) = dict[key] {
            return object
        }

        if case .nestedArray = dict[key] {
            preconditionFailure("For key \"\(key)\" an unkeyed container has already been created.")
        }

        let object = JSONObject()
        dict[key] = .nestedObject(object)
        return object
    }

    var values: [String: JSONValue] {
        dict.mapValues { (future) -> JSONValue in
            switch future {
            case let .value(value):
                return value
            case let .nestedArray(array):
                return .array(array.values)
            case let .nestedObject(object):
                return .object(object.values)
            }
        }
    }
}

public struct JSONEncoder {
    var userInfo: [CodingUserInfoKey: Any] = [:]

    public init() {}

    public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
        let value: JSONValue = try encodeAsJSONValue(value)
        var bytes = [UInt8]()
        value.appendBytes(to: &bytes)
        return bytes
    }

    public func encodeAsJSONValue<T: Encodable>(_ value: T) throws -> JSONValue {
        let encoder = JSONEncoderImpl(userInfo: userInfo, codingPath: [])

        try value.encode(to: encoder)

        // if the top level encoder does not have a value
        // we don't have a value at all and we should return `null`
        return encoder.value ?? .null
    }
}

class JSONEncoderImpl {
    let userInfo: [CodingUserInfoKey: Any]
    let codingPath: [CodingKey]

    var singleValue: JSONValue?
    var array: JSONArray?
    var object: JSONObject?

    var value: JSONValue? {
        if let object = self.object {
            return .object(object.values)
        }
        if let array = self.array {
            return .array(array.values)
        }
        return singleValue
    }

    init(userInfo: [CodingUserInfoKey: Any], codingPath: [CodingKey]) {
        self.userInfo = userInfo
        self.codingPath = codingPath
    }
}

extension JSONEncoderImpl: Encoder {
    func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        if let _ = object {
            let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
            return KeyedEncodingContainer(container)
        }

        guard singleValue == nil, array == nil else {
            preconditionFailure()
        }

        object = JSONObject()
        let container = JSONKeyedEncodingContainer<Key>(impl: self, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        if let _ = array {
            return JSONUnkeyedEncodingContainer(impl: self, codingPath: codingPath)
        }

        guard singleValue == nil, object == nil else {
            preconditionFailure()
        }

        array = JSONArray()
        return JSONUnkeyedEncodingContainer(impl: self, codingPath: codingPath)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        guard object == nil, array == nil else {
            preconditionFailure()
        }

        return JSONSingleValueEncodingContainer(impl: self, codingPath: codingPath)
    }
}
