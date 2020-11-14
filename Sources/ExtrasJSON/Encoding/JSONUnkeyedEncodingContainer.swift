
struct JSONUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    let impl: JSONEncoderImpl
    let array: JSONArray
    let codingPath: [CodingKey]

    private(set) var count: Int = 0
    private var firstValueWritten: Bool = false

    init(impl: JSONEncoderImpl, codingPath: [CodingKey]) {
        self.impl = impl
        self.array = impl.array!
        self.codingPath = codingPath
    }

    // used for nested containers
    init(impl: JSONEncoderImpl, array: JSONArray, codingPath: [CodingKey]) {
        self.impl = impl
        self.array = array
        self.codingPath = codingPath
    }

    mutating func encodeNil() throws {}

    mutating func encode(_ value: Bool) throws {
        self.array.append(.bool(value))
    }

    mutating func encode(_ value: String) throws {
        self.array.append(.string(value))
    }

    mutating func encode(_ value: Double) throws {
        guard !value.isNaN, !value.isInfinite else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: self.codingPath + [ArrayKey(index: self.count)],
                debugDescription: "Unable to encode Double.\(value) directly in JSON."
            ))
        }

        try encodeFloatingPoint(value)
    }

    mutating func encode(_ value: Float) throws {
        guard !value.isNaN, !value.isInfinite else {
            throw EncodingError.invalidValue(value, .init(
                codingPath: self.codingPath + [ArrayKey(index: self.count)],
                debugDescription: "Unable to encode Float.\(value) directly in JSON."
            ))
        }

        try encodeFloatingPoint(value)
    }

    mutating func encode(_ value: Int) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: Int8) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: Int16) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: Int32) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: Int64) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: UInt) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: UInt8) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: UInt16) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: UInt32) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode(_ value: UInt64) throws {
        try encodeFixedWidthInteger(value)
    }

    mutating func encode<T>(_ value: T) throws where T: Encodable {
        let newPath = self.impl.codingPath + [ArrayKey(index: self.count)]
        let newEncoder = JSONEncoderImpl(userInfo: impl.userInfo, codingPath: newPath)
        try value.encode(to: newEncoder)

        guard let value = newEncoder.value else {
            preconditionFailure()
        }

        self.array.append(value)
    }

    mutating func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) ->
        KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    {
        let newPath = self.impl.codingPath + [ArrayKey(index: self.count)]
        let object = self.array.appendObject()
        let nestedContainer = JSONKeyedEncodingContainer<NestedKey>(impl: impl, object: object, codingPath: newPath)
        return KeyedEncodingContainer(nestedContainer)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let newPath = self.impl.codingPath + [ArrayKey(index: self.count)]
        let array = self.array.appendArray()
        let nestedContainer = JSONUnkeyedEncodingContainer(impl: impl, array: array, codingPath: newPath)
        return nestedContainer
    }

    mutating func superEncoder() -> Encoder {
        preconditionFailure()
    }
}

extension JSONUnkeyedEncodingContainer {
    @inline(__always) private mutating func encodeFixedWidthInteger<N: FixedWidthInteger>(_ value: N) throws {
        self.array.append(.number(value.description))
    }

    @inline(__always) private mutating func encodeFloatingPoint<N: FloatingPoint>(_ value: N)
        throws where N: CustomStringConvertible
    {
        self.array.append(.number(value.description))
    }
}
