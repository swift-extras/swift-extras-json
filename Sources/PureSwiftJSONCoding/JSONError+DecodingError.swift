import PureSwiftJSONParsing

extension JSONError {
    @inlinable var decodingError: DecodingError {
        switch self {
        case let .unexpectedCharacter(ascii, index):
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

        case let .tooManyNestedArraysOrDictionaries(index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "More than 512 nested arrays and dictionaries at index \(index)",
                underlyingError: self
            ))

        case let .invalidHexDigitSequence(string, index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Invalid hex sequence `\(string)` at \(index)",
                underlyingError: self
            ))

        case let .unexpectedEscapedCharacter(ascii, string, index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unexpected escaped character `\(Unicode.Scalar(ascii))` in `\(string)` at \(index)",
                underlyingError: self
            ))

        case let .unescapedControlCharacterInString(ascii, string, index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Unescaped control character `Ascii Code \(Unicode.Scalar(ascii))` in `\(string)` at \(index)",
                underlyingError: self
            ))

        case let .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(string, index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Expected low surrogate utf8 sequence after high surrogate in string `\(string)` at character index: \(index)",
                underlyingError: self
            ))

        case let .couldNotCreateUnicodeScalarFromUInt32(string, index, unicodeScalarValue):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Could not create unicode scalar from uint32 `\(unicodeScalarValue)` in string \"\(string)\" at \(index)",
                underlyingError: self
            ))

        case let .numberWithLeadingZero(index):
            return DecodingError.dataCorrupted(.init(
                codingPath: [],
                debugDescription: "Number with leading zeros at \(index)",
                underlyingError: self
            ))
        }
    }
}
