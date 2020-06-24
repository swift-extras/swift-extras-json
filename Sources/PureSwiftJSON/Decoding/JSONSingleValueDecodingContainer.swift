
struct JSONSingleValueDecodingContainter: SingleValueDecodingContainer {
    let impl: JSONDecoderImpl
    let value: JSONValue
    let codingPath: [CodingKey]

    init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
        self.impl = impl
        self.codingPath = codingPath
        value = json
    }

    func decodeNil() -> Bool {
        return value == .null
    }

    func decode(_: Bool.Type) throws -> Bool {
        guard case let .bool(bool) = value else {
            throw createTypeMismatchError(type: Bool.self, value: value)
        }

        return bool
    }

    func decode(_: String.Type) throws -> String {
        guard case let .string(string) = value else {
            throw createTypeMismatchError(type: String.self, value: value)
        }

        return string
    }

    func decode(_: Double.Type) throws -> Double {
        return try decodeLosslessStringConvertible()
    }

    func decode(_: Float.Type) throws -> Float {
        return try decodeLosslessStringConvertible()
    }

    func decode(_: Int.Type) throws -> Int {
        return try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        return try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        return try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        return try decodeFixedWidthInteger()
    }

    func decode<T>(_: T.Type) throws -> T where T: Decodable {
        return try T(from: impl)
    }
}

extension JSONSingleValueDecodingContainter {
    @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
        return DecodingError.typeMismatch(type, .init(
            codingPath: codingPath,
            debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }

    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws
        -> T
    {
        guard case let .number(number) = value else {
            throw createTypeMismatchError(type: T.self, value: value)
        }

        guard let integer = T(number) else {
            throw DecodingError.dataCorruptedError(
                in: self,
                debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."
            )
        }

        return integer
    }

    @inline(__always) private func decodeLosslessStringConvertible<T: LosslessStringConvertible>()
        throws -> T
    {
        guard case let .number(number) = value else {
            throw createTypeMismatchError(type: T.self, value: value)
        }

        guard let floatingPoint = T(number) else {
            throw DecodingError.dataCorruptedError(
                in: self,
                debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."
            )
        }

        return floatingPoint
    }
}
