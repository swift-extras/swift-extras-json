@testable import PureSwiftJSON
import XCTest

class StringParserTests: XCTestCase {
    func testSimpleHelloString() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#""Hello""# .utf8)))
        XCTAssertEqual(result, .string("Hello"))
    }

    func testSimpleUTF8String() {
        // generated with http://www.eeemo.net
        var result: JSONValue?
        let string = "ǫ̮̺͚͙̥̩̫̫̻͆͒ͩ̏̾͂̀ͬͣ̂͋͗̐͛ͩ̿͋̃ ͆̑ͪ͆ͪ̅̃̌̇̔҉̸̢̧̫͉̦̜͔̙́i̵̡̮̰̯̊̔̓͒̅̈́̄̊ͥ͐̍ņ̊ͮ̋͗͂̑̈́͒́͂͋ͦͥ̓̈́̍̈́͜͠͞͏̹͚̥̣̝͍v̶̵͖͈̭̘̗̗͇̝̮̪͚͕̙͕ͨ̏ͫ͋́͒ͨͯo̲̦̬͎̤̳̜̅̆ͩͧͮ̉ͬ͊̉ͭ͂ͮ̌̂̄̀̊ͦ̚̕͞k̡̛̫̖̬̝̫̣̣̮̄ͮ̌̍̋ͧ̄ͅe̴̡̧̝͎̭̳͖̮̣͉̦͎͈̹̿ͬͯ̆͝ ̵̷̧̖͔̲̲͉̪̘̻̋́̈́̾͑̈ͭͧ̈́̔ͥ̄ͨ͒̾ͅtͩ̇̔̀͘͘҉̶̗͍͍̜̯̩̬̙͍͚͓̻ͅh̸̲͍̺̯͇̹̒ͮ͒̈͗͑̅ͯ͒̊ͮ̓͗̾̓̌ͤ̎̚͜ͅę͎͈͔̜̠̯̟̤̝̘͚̙̪͛̏͒ͯͩͫ͒̊͒̃̌ͣͧ̀̚͠ ̵̧̱͓̞̠̮͙̮̖̞̖͔̪̞̰̻̋ͪͭͮ͆͆͘͝h̶͚͔̩̩̦̹̙̟̟̮̠͆̾̈ͬͣͨ̃̓̉ͯ͋̇̇͊̀̕͟͡ͅi̶̵̡͇͉̹̮̙̱̮̘͂͊̋̏̓͂͊̈́ͩ̑̇̋ͤ̈́ͯ̅̑̽̚͟͝ͅv̷̢̛̪̹͍̝̞̲̖̭̲̼̥̬͍ͦ͂̀̈̀̏ͧ͆͛ͫ̚̚͘͠e̴̵̷̐ͬ͐́ͫ͛͏̫̰̙̗͙͙̝̺̹̞̤̱̳̦̫̜͠ͅ-̸̖̯̠̣͇͔̯ͪ̌ͮͩ̾̇ͫ͟͢m̴ͫ̌̇ͮ̎̀͏̜̤̤̺̲̭̘̺̮̥̲̮͡i̡̛̪͙̣̗̩̥̫̲͕̣̩̣̘̟̽ͤ̅̍ͧ̊̒ͥͨͥ̊ͥͪͧ́͌ͅn̴͔͙̱̘̝̩̯̖͉̘̆́ͫ̇̉ͭ̒ͣ̍̌̈̒ͩ̉̇̈̅́̀d̵̛͔̯̝̣̈́̅̃͐͋̆ͣ͊̂̂ͧ͐̐̇͒̚̚͘ ̅̿̑ͬ͢͠͏̴͈͉̫̠̥̺̜̘͓̦̦͈̦͙̤̮ŗ̛̰̬͓̯̜̫͖͈̟̮̾ͪ̎̅ͬͨ̑̈́́͡ͅę̸͍̰͕̠̪̺͇̹̦̭̆̈̂̌ͧͨͣͤͦ͌ͭ̇͊̈́̃ͫͅpͪ̊͌̊͊ͥͫ̄̇̈́̏ͦ̏͡͏̰̳̬̼͈́r̵̷̛͈̻̤̫̮̮̞̺̝͊ͦ̏͛̅͛͗̂͛̐ͯ̀e͛͗͂̑̔̃̈ͬ͂ͫ̚͘͜͏̧̳̩̥̩̻̙̫̩̤̙͔̠̪̗̞̹̩͠ͅs̻̤̤̥̜̞̮̠̞̱͇̝̰̜̤͓͋ͣ̓͌̍̔̓͂̚͘͘ͅe̛̥̬̠̭̫̞̠̺̬̲̩̮̹͎̱͉͚͉̺͌͊̾̈ͦ̊̐̒̕͜n̵̡ͣ̏ͥ̓͋͊̿̽͋ͮͨ̈́͐ͥͨ͋̚҉̢͚̙͍̖̪̗ͅţ̧͕̹̺̤ͧ̉ͤ̆̃̃̾̄͂̓ͮ͐̅̽̂̽͡͝͝i̡̛̥̬̦̗̝̮̘̣̭̻̲̘̘̬̎͌̈́ͧ̏̐ͣ̌̃̌ͮ̑́͞ͅn̡͉̰̠̱̙̰̼̼̯̦̱͓̟̻̰̒̍̾ͣͮͩ́̕͜͟g̸̮̳̤̜͓͙͙̮̙̰͉̞̠̗̼ͬ̒̔̓̆ͥ̂̍͑̈́ͤͨ͛ͬ̚̚̚͟͝͝͞ͅ ̷̢ͨ͒͗ͨ͝҉̠̮̪͖̳̣̝̮̠̪̕c͋̈́̊̐̈́ͣ͂͗̆ͦ͂̽̃҉̴̢̧̹̬͍̪̗͚͉͙͟ͅh̙̟̜̹̪̫͕̟̗̥̼̪͂̑̃̓ͯͫ̅ͭ̒́̕͡ȧ̷̲͓̞̮̦̭ͤ͊ͧ̋̿̅̃͑̈ͫ̃ͤ͟͡ͅoͥͤ͐ͣ̅͏̢̧͖̤̩̰̭͙͓͙͕͓̘̱̻̻̲͓͔͡sͥ͑̎ͦ̃̓̓ͯ̈́̆̉ͮ͂̒ͫ̀̚̚͞҉̨͎̺̘̞̪̘͜ͅ"
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#""\#(string)""# .utf8)))
        XCTAssertEqual(result, .string(string))
    }

    func testEscapedQuotesString() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#""\\\"""# .utf8)))
        XCTAssertEqual(result, .string(#"\""#))
    }

    func testSimpleEscapedUnicode() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#""\u005A""# .utf8)))
        XCTAssertEqual(result, .string("Z"))
    }

    func testSimpleLowercaseEscapedUnicode() {
        var result: JSONValue?
        XCTAssertNoThrow(result = try JSONParser().parse(bytes: [UInt8](#""\u003c""# .utf8)))
        XCTAssertEqual(result, .string("<"))
    }

    func test12CharacterSequenceUnicode() {
        // from: https://en.wikipedia.org/wiki/UTF-16#Examples
        var result1: JSONValue?
        XCTAssertNoThrow(result1 = try JSONParser().parse(bytes: [UInt8](#""\uD801\uDC37""# .utf8)))
        XCTAssertEqual(result1, .string("𐐷"))

        var result2: JSONValue?
        XCTAssertNoThrow(result2 = try JSONParser().parse(bytes: [UInt8](#""\uD852\uDF62""# .utf8)))
        XCTAssertEqual(result2, .string("\u{24B62}"))
    }

    func testHighSurrogateBitPatternFollowedByPlainUnicode() throws {
        let failureString = #"abc \uD801\u005A"#
        let jsonString = #""\#(failureString)""#
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](jsonString.utf8))) { error in
            XCTAssertEqual(error as? JSONError, .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(in: failureString, index: 16))
        }
    }

    func testHighSurrogateBitPatternFollowedByAsciiCharacters() throws {
        let jsonString = #""\uD801abc""#
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](jsonString.utf8))) { error in
            XCTAssertEqual(error as? JSONError, .expectedLowSurrogateUTF8SequenceAfterHighSurrogate(in: #"\uD801ab"#, index: 8))
        }
    }

    func testHighSurrogateBitPatternFollowedByNothing() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](#""\uD801""# .utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testHighSurrogateBitPatternFollowedByIncompleteLowSurrogate() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](#""\uD801\uDC""# .utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEndOfFile)
        }
    }

    func testIncompleteEscapedUnicode() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("\"\\u005\"".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .invalidHexDigitSequence("005\"", index: 3))
        }
    }

    func testInvalidEscapedCharacter() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](#""\y""# .utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEscapedCharacter(ascii: UInt8(ascii: "y"), in: "\\y", index: 2))
        }
    }

    func testUnescapedReversedSolidus() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](#"" \ ""# .utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unexpectedEscapedCharacter(ascii: UInt8(ascii: " "), in: " \\ ", index: 3))
        }
    }

    func testUnescapedNewline() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("\" \n \"".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unescapedControlCharacterInString(ascii: UInt8(ascii: "\n"), in: " \n", index: 2))
        }
    }

    func testUnescapedTab() throws {
        XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8]("\" \t \"".utf8))) { error in
            XCTAssertEqual(error as? JSONError, .unescapedControlCharacterInString(ascii: UInt8(ascii: "\t"), in: " \t", index: 2))
        }
    }

    func testUnescapedControlCharacters() throws {
        // All Unicode characters may be placed within the
        // quotation marks, except for the characters that MUST be escaped:
        // quotation mark, reverse solidus, and the control characters (U+0000
        // through U+001F).
        // https://tools.ietf.org/html/rfc7159#section-7

        for index in 0 ... 31 {
            var scalars = "\"".unicodeScalars
            let invalidScalar = Unicode.Scalar(index)!
            scalars.append(invalidScalar)
            scalars.append(contentsOf: "\"".unicodeScalars)
            let json = String(scalars)

            XCTAssertThrowsError(_ = try JSONParser().parse(bytes: [UInt8](json.utf8))) { error in
                XCTAssertEqual(error as? JSONError, .unescapedControlCharacterInString(ascii: UInt8(index), in: String(invalidScalar), index: 1))
            }
        }
    }
}
