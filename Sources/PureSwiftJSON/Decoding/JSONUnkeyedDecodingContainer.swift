
struct JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    let impl: JSONDecoderImpl
    let codingPath: [CodingKey]
    let array: [JSONValue]

    let count: Int? // protocol requirement to be optional
    var isAtEnd: Bool
    var currentIndex = 0

    init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
        self.impl = impl
        self.codingPath = codingPath
        self.array = array

        isAtEnd = array.count == 0
        count = array.count
    }

    mutating func decodeNil() throws -> Bool {
        if array[currentIndex] == .null {
            self.increment()
            return true
        }

        // The protocol states:
        //   If the value is not null, does not increment currentIndex.
        return false
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        guard case let .bool(bool) = array[currentIndex] else {
            throw createTypeMismatchError(type: type, value: array[currentIndex])
        }

        self.increment()
        return bool
    }

    mutating func decode(_ type: String.Type) throws -> String {
        guard case let .string(string) = array[currentIndex] else {
            throw createTypeMismatchError(type: type, value: array[currentIndex])
        }

        self.increment()
        return string
    }

    mutating func decode(_: Double.Type) throws -> Double {
        return try decodeLosslessStringConvertible()
    }

    mutating func decode(_: Float.Type) throws -> Float {
        return try decodeLosslessStringConvertible()
    }

    mutating func decode(_: Int.Type) throws -> Int {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int8.Type) throws -> Int8 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int16.Type) throws -> Int16 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int32.Type) throws -> Int32 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int64.Type) throws -> Int64 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt.Type) throws -> UInt {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt8.Type) throws -> UInt8 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt16.Type) throws -> UInt16 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt32.Type) throws -> UInt32 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt64.Type) throws -> UInt64 {
        return try decodeFixedWidthInteger()
    }

    mutating func decode<T>(_: T.Type) throws -> T where T: Decodable {
        let decoder = try decoderForNextElement()
        return try T(from: decoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        let decoder = try decoderForNextElement()
        return try decoder.container(keyedBy: type)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let decoder = try decoderForNextElement()
        return try decoder.unkeyedContainer()
    }

    mutating func superDecoder() throws -> Decoder {
        return impl
    }
}

extension JSONUnkeyedDecodingContainer {
    private mutating func increment() {
        currentIndex += 1
        if currentIndex == count {
            isAtEnd = true
        }
    }

    private mutating func decoderForNextElement() throws -> JSONDecoderImpl {
        let value = array[currentIndex]
        var newPath = codingPath
        newPath.append(ArrayKey(index: currentIndex))

        self.increment()
        return JSONDecoderImpl(
            userInfo: impl.userInfo,
            from: value,
            codingPath: newPath
        )
    }

    @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
        let codingPath = self.codingPath + [ArrayKey(index: currentIndex)]
        return DecodingError.typeMismatch(type, .init(
            codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }

    @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws
        -> T
    {
        guard case let .number(number) = array[currentIndex] else {
            throw createTypeMismatchError(type: T.self, value: array[currentIndex])
        }

        guard let integer = T(number) else {
            throw DecodingError.dataCorruptedError(in: self,
                                                   debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
        }

        self.increment()
        return integer
    }

    @inline(__always) private mutating func decodeLosslessStringConvertible<T: LosslessStringConvertible>()
        throws -> T
    {
        guard case let .number(number) = array[currentIndex] else {
            throw createTypeMismatchError(type: T.self, value: array[currentIndex])
        }

        guard let float = T(number) else {
            throw DecodingError.dataCorruptedError(in: self,
                                                   debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
        }

        self.increment()
        return float
    }
}
