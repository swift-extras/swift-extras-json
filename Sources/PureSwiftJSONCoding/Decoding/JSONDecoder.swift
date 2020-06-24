import PureSwiftJSONParsing

public struct JSONDecoder {
    @usableFromInline var userInfo: [CodingUserInfoKey: Any] = [:]

    public init() {}

    @inlinable public func decode<T: Decodable, Bytes: Collection>(_: T.Type, from bytes: Bytes)
        throws -> T where Bytes.Element == UInt8 {
        do {
            let json = try JSONParser().parse(bytes: bytes)
            let decoder = JSONDecoderImpl(userInfo: userInfo, from: json, codingPath: [])
            return try decoder.decode(T.self)
        } catch let error as JSONError {
            throw error.decodingError
        }
    }
}

@usableFromInline struct JSONDecoderImpl {
    @usableFromInline let codingPath: [CodingKey]
    @usableFromInline let userInfo: [CodingUserInfoKey: Any]

    @usableFromInline let json: JSONValue

    @inlinable init(userInfo: [CodingUserInfoKey: Any], from json: JSONValue, codingPath: [CodingKey]) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.json = json
    }

    @inlinable public func decode<T: Decodable>(_: T.Type) throws -> T {
        return try T(from: self)
    }
}

extension JSONDecoderImpl: Decoder {
    @usableFromInline func container<Key>(keyedBy _: Key.Type) throws ->
        KeyedDecodingContainer<Key> where Key: CodingKey {
        guard case let .object(dictionary) = json else {
            throw DecodingError.typeMismatch([String: JSONValue].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \([String: JSONValue].self) but found \(json.debugDataTypeDescription) instead."
            ))
        }

        let container = JSONKeyedDecodingContainer<Key>(
            impl: self,
            codingPath: codingPath,
            dictionary: dictionary
        )
        return KeyedDecodingContainer(container)
    }

    @usableFromInline func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard case let .array(array) = json else {
            throw DecodingError.typeMismatch([JSONValue].self, DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \([JSONValue].self) but found \(json.debugDataTypeDescription) instead."
            ))
        }

        return JSONUnkeyedDecodingContainer(
            impl: self,
            codingPath: codingPath,
            array: array
        )
    }

    @usableFromInline func singleValueContainer() throws -> SingleValueDecodingContainer {
        return JSONSingleValueDecodingContainter(
            impl: self,
            codingPath: codingPath,
            json: json
        )
    }
}
