
struct JSONSingleValueDecodingContainter: SingleValueDecodingContainer {
    let impl: JSONDecoderImpl
    let value: JSONValue
    let codingPath: [CodingKey]

    init(impl: JSONDecoderImpl, codingPath: [CodingKey], json: JSONValue) {
        self.impl = impl
        self.codingPath = codingPath
        self.value = json
    }

    func decodeNil() -> Bool {
        self.value == .null
    }

    func decode(_: Bool.Type) throws -> Bool {
        guard case .bool(let bool) = self.value else {
            throw createTypeMismatchError(type: Bool.self, value: self.value)
        }

        return bool
    }

    func decode(_: String.Type) throws -> String {
        guard case .string(let string) = self.value else {
            throw createTypeMismatchError(type: String.self, value: self.value)
        }

        return string
    }

    func decode(_: Double.Type) throws -> Double {
        try decodeLosslessStringConvertible()
    }

    func decode(_: Float.Type) throws -> Float {
        try decodeLosslessStringConvertible()
    }

    func decode(_: Int.Type) throws -> Int {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int8.Type) throws -> Int8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int16.Type) throws -> Int16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int32.Type) throws -> Int32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: Int64.Type) throws -> Int64 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt.Type) throws -> UInt {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt8.Type) throws -> UInt8 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt16.Type) throws -> UInt16 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt32.Type) throws -> UInt32 {
        try decodeFixedWidthInteger()
    }

    func decode(_: UInt64.Type) throws -> UInt64 {
        try decodeFixedWidthInteger()
    }

    func decode<T>(_: T.Type) throws -> T where T: Decodable {
        try T(from: self.impl)
    }
}

extension JSONSingleValueDecodingContainter {
    @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
        DecodingError.typeMismatch(type, .init(
            codingPath: self.codingPath,
            debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }

    @inline(__always) private func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        guard case .number(let number) = self.value else {
            throw self.createTypeMismatchError(type: T.self, value: self.value)
        }

        guard let integer = T(number) else {
            throw DecodingError.dataCorruptedError(
                in: self,
                debugDescription: "Parsed JSON number <\(number)> does not fit in \(T.self)."
            )
        }

        return integer
    }

    @inline(__always) private func decodeLosslessStringConvertible<T: LosslessStringConvertible>() throws -> T {
        guard case .number(let number) = self.value else {
            throw self.createTypeMismatchError(type: T.self, value: self.value)
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
