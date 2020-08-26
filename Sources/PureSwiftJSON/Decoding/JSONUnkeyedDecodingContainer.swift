
struct JSONUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    let impl: JSONDecoderImpl
    let codingPath: [CodingKey]
    let array: [JSONValue]

    var count: Int? { self.array.count }
    var isAtEnd: Bool { self.currentIndex >= (self.count ?? 0) }
    var currentIndex = 0

    init(impl: JSONDecoderImpl, codingPath: [CodingKey], array: [JSONValue]) {
        self.impl = impl
        self.codingPath = codingPath
        self.array = array
    }

    mutating func decodeNil() throws -> Bool {
        if try self.getNextValue(ofType: Never.self) == .null {
            self.currentIndex += 1
            return true
        }

        // The protocol states:
        //   If the value is not null, does not increment currentIndex.
        return false
    }

    mutating func decode(_ type: Bool.Type) throws -> Bool {
        let value = try self.getNextValue(ofType: Bool.self)
        guard case .bool(let bool) = value else {
            throw createTypeMismatchError(type: type, value: value)
        }

        self.currentIndex += 1
        return bool
    }

    mutating func decode(_ type: String.Type) throws -> String {
        let value = try self.getNextValue(ofType: String.self)
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
        let decoder = try decoderForNextElement(ofType: T.self)
        let result = try T(from: decoder)

        // Because of the requirement that the index not be incremented unless
        // decoding the desired result type succeeds, it can not be a tail call.
        // Hopefully the compiler still optimizes well enough that the result
        // doesn't get copied around.
        self.currentIndex += 1
        return result
    }

    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
    {
        let decoder = try decoderForNextElement(ofType: KeyedDecodingContainer<NestedKey>.self, isNested: true)
        let container = try decoder.container(keyedBy: type)

        self.currentIndex += 1
        return container
    }

    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let decoder = try decoderForNextElement(ofType: UnkeyedDecodingContainer.self, isNested: true)
        let container = try decoder.unkeyedContainer()

        self.currentIndex += 1
        return container
    }

    mutating func superDecoder() throws -> Decoder {
        self.impl
    }
}

extension JSONUnkeyedDecodingContainer {
    private mutating func decoderForNextElement<T>(ofType: T.Type, isNested: Bool = false) throws -> JSONDecoderImpl {
        let value = try self.getNextValue(ofType: T.self, isNested: isNested)
        let newPath = self.codingPath + [ArrayKey(index: self.currentIndex)]

        return JSONDecoderImpl(
            userInfo: self.impl.userInfo,
            from: value,
            codingPath: newPath
        )
    }

    /// - Note: Instead of having the `isNested` parameter, it would have been quite nice to just check whether
    ///   `T` conforms to either `KeyedDecodingContainer` or `UnkeyedDecodingContainer`. Unfortunately, since
    ///   `KeyedDecodingContainer` takes a generic parameter (the `Key` type), we can't just ask if `T` is one, and
    ///   type-erasure workarounds are not appropriate to this use case due to, among other things, the inability to
    ///   conform most of the types that would matter. We also can't use `KeyedDecodingContainerProtocol` for the
    ///   purpose, as it isn't even an existential and conformance to it can't be checked at runtime at all.
    ///
    ///   However, it's worth noting that the value of `isNested` is always a compile-time constant and the compiler
    ///   can quite neatly remove whichever branch of the `if` is not taken during optimization, making doing it this
    ///   way _much_ more performant (for what little it matters given that it's only checked in case of an error).
    @inline(__always)
    private func getNextValue<T>(ofType: T.Type, isNested: Bool = false) throws -> JSONValue {
        guard !self.isAtEnd else {
            if isNested {
                throw DecodingError.valueNotFound(T.self,
                    .init(codingPath: self.codingPath,
                          debugDescription: "Cannot get nested keyed container -- unkeyed container is at end.",
                          underlyingError: nil))
            } else {
                throw DecodingError.valueNotFound(T.self,
                    .init(codingPath: [ArrayKey(index: self.currentIndex)],
                          debugDescription: "Unkeyed container is at end.",
                          underlyingError: nil))
            }
        }
        return self.array[self.currentIndex]
    }

    @inline(__always) private func createTypeMismatchError(type: Any.Type, value: JSONValue) -> DecodingError {
        let codingPath = self.codingPath + [ArrayKey(index: self.currentIndex)]
        return DecodingError.typeMismatch(type, .init(
            codingPath: codingPath, debugDescription: "Expected to decode \(type) but found \(value.debugDataTypeDescription) instead."
        ))
    }

    @inline(__always) private mutating func decodeFixedWidthInteger<T: FixedWidthInteger>() throws -> T {
        let value = try self.getNextValue(ofType: T.self)
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
        let value = try self.getNextValue(ofType: T.self)
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
