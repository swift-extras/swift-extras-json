
extension JSONError {
    @inlinable var decodingError: DecodingError {
        switch self {
        case .unexpectedCharacter(let ascii, let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unexpected character `\(UnicodeScalar(ascii))` at character index: \(index)",
                underlyingError: self
            ))

        case .unexpectedEndOfFile:
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unexpected end of json", underlyingError: self
            ))

        case .tooManyNestedArraysOrDictionaries(let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "More than 512 nested arrays and dictionaries at index \(index)",
                underlyingError: self
            ))

        case .invalidHexDigitSequence(let string, let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Invalid hex sequence `\(string)` at \(index)",
                underlyingError: self
            ))

        case .unexpectedEscapedCharacter(let ascii, let string, let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unexpected escaped character `\(Unicode.Scalar(ascii))` in `\(string)` at \(index)",
                underlyingError: self
            ))

        case .unescapedControlCharacterInString(let ascii, let string, let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unescaped control character `Ascii Code \(Unicode.Scalar(ascii))` in `\(string)` at \(index)",
                underlyingError: self
            ))

        case .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(let string, let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Expected low surrogate utf8 sequence after high surrogate in string `\(string)` at character index: \(index)",
                underlyingError: self
            ))

        case .couldNotCreateUnicodeScalarFromUInt32(let string, let index, let unicodeScalarValue):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Could not create unicode scalar from uint32 `\(unicodeScalarValue)` in string \"\(string)\" at \(index)",
                underlyingError: self
            ))

        case .numberWithLeadingZero(let index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Number with leading zeros at \(index)",
                underlyingError: self
            ))
        }
    }
}
