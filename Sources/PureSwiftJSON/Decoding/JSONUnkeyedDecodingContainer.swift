
struct JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    let impl: JSONDecoderImpl
    let codingPath: [CodingKey]
    let array: [JSONValue]

    var count: Int? { self.array.count }
    var isAtEnd: Bool { self.currentIndex >= (self.count ?? 0) }
    var currentIndex = 0

    private func getNextValue() throws -> JSONValue {
        guard !self.isAtEnd else {
            throw DecodingError.dataCorruptedError(in: self,
                                                   debugDescription: "Index \(self.currentIndex) out of bounds (\(self.array.count)) trying to decode value.")
        }
        return self.array[self.currentIndex]
    }

    init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
        self.impl = impl
        self.codingPath = codingPath
        self.array = array
    }

    mutating func decodeNil() throws -> Bool {
        if try self.getNextValue() == .null {
            self.currentIndex += 1
            return true
        }

        // The protocol states:
        //   If the value is not null, does not increment currentIndex.
        return false
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        let value = try self.getNextValue()
        guard case .bool(let bool) = value else {
            throw createTypeMismatchError(type: type, value: value)
        }

        self.currentIndex += 1
        return bool
    }

    mutating func decode(_ type: String.Type) throws -> String {
        let value = try self.getNextValue()
        guard case .string(let string) = value else {
            throw createTypeMismatchError(type: type, value: value)
        }

        self.currentIndex += 1
        return string
    }

    mutating func decode(_: Double.Type) throws -> Double {
        try decodeBinaryFloatingPoint()
    }

    mutating func decode(_: Float.Type) throws -> Float {
        try decodeBinaryFloatingPoint()
    }

    mutating func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    mutating func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    mutating func decode<T>(_: T.Type) throws -> T where T: Decodable {
        let decoder = try decoderForNextElement()
        return try T(from: decoder)
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
    {
        let decoder = try decoderForNextElement()
        return try decoder.container(keyedBy: type)
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let decoder = try decoderForNextElement()
        return try decoder.unkeyedContainer()
    }

    mutating func superDecoder() throws -> Decoder {
        self.impl
    }
}

extension JSONUnkeyedDecodingContainer {
    private mutating func decoderForNextElement() throws -> JSONDecoderImpl {
        let value = try self.getNextValue()
        let newPath = self.codingPath + [ArrayKey(index: self.currentIndex)]
        self.currentIndex += 1

        return JSONDecoderImpl(
            userInfo: self.impl.userInfo,
            from: value,
            codingPath: newPath
        )
    }

    @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
        let codingPath = self.codingPath + [ArrayKey(index: self.currentIndex)]
        return DecodingError.typeMismatch(type, .init(
            codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }

    @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        let value = try self.getNextValue()
        guard case .number(let number) = value else {
            throw self.createTypeMismatchError(type: T.self, value: value)
        }

        guard let integer = T(number) else {
            throw DecodingError.dataCorruptedError(in: self,
                                                   debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
        }

        self.currentIndex += 1
        return integer
    }

    @inline(__always) private mutating func decodeBinaryFloatingPoint<T: LosslessStringConvertible>() throws -> T {
        let value = try self.getNextValue()
        guard case .number(let number) = value else {
            throw self.createTypeMismatchError(type: T.self, value: value)
        }

        guard let float = T(number) else {
            throw DecodingError.dataCorruptedError(in: self,
                                                   debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self).")
        }

        self.currentIndex += 1
        return float
    }
}
