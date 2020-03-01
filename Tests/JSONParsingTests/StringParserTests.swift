import XCTest
@testable import PureSwiftJSONParsing

class StringParserTests: XCTestCase {
  
  func testSimpleHelloString() throws {
    let result = try JSONParser().parse(bytes: [UInt8](#""Hello""#.utf8))
    XCTAssertEqual(result, .string("Hello"))
  }
  
  func testSimpleUTF8String() throws {
    // generated with http://www.eeemo.net
    let string = "ǫ̮̺͚͙̥̩̫̫̻͆͒ͩ̏̾͂̀ͬͣ̂͋͗̐͛ͩ̿͋̃ ͆̑ͪ͆ͪ̅̃̌̇̔҉̸̢̧̫͉̦̜͔̙́i̵̡̮̰̯̊̔̓͒̅̈́̄̊ͥ͐̍ņ̊ͮ̋͗͂̑̈́͒́͂͋ͦͥ̓̈́̍̈́͜͠͞͏̹͚̥̣̝͍v̶̵͖͈̭̘̗̗͇̝̮̪͚͕̙͕ͨ̏ͫ͋́͒ͨͯo̲̦̬͎̤̳̜̅̆ͩͧͮ̉ͬ͊̉ͭ͂ͮ̌̂̄̀̊ͦ̚̕͞k̡̛̫̖̬̝̫̣̣̮̄ͮ̌̍̋ͧ̄ͅe̴̡̧̝͎̭̳͖̮̣͉̦͎͈̹̿ͬͯ̆͝ ̵̷̧̖͔̲̲͉̪̘̻̋́̈́̾͑̈ͭͧ̈́̔ͥ̄ͨ͒̾ͅtͩ̇̔̀͘͘҉̶̗͍͍̜̯̩̬̙͍͚͓̻ͅh̸̲͍̺̯͇̹̒ͮ͒̈͗͑̅ͯ͒̊ͮ̓͗̾̓̌ͤ̎̚͜ͅę͎͈͔̜̠̯̟̤̝̘͚̙̪͛̏͒ͯͩͫ͒̊͒̃̌ͣͧ̀̚͠ ̵̧̱͓̞̠̮͙̮̖̞̖͔̪̞̰̻̋ͪͭͮ͆͆͘͝h̶͚͔̩̩̦̹̙̟̟̮̠͆̾̈ͬͣͨ̃̓̉ͯ͋̇̇͊̀̕͟͡ͅi̶̵̡͇͉̹̮̙̱̮̘͂͊̋̏̓͂͊̈́ͩ̑̇̋ͤ̈́ͯ̅̑̽̚͟͝ͅv̷̢̛̪̹͍̝̞̲̖̭̲̼̥̬͍ͦ͂̀̈̀̏ͧ͆͛ͫ̚̚͘͠e̴̵̷̐ͬ͐́ͫ͛͏̫̰̙̗͙͙̝̺̹̞̤̱̳̦̫̜͠ͅ-̸̖̯̠̣͇͔̯ͪ̌ͮͩ̾̇ͫ͟͢m̴ͫ̌̇ͮ̎̀͏̜̤̤̺̲̭̘̺̮̥̲̮͡i̡̛̪͙̣̗̩̥̫̲͕̣̩̣̘̟̽ͤ̅̍ͧ̊̒ͥͨͥ̊ͥͪͧ́͌ͅn̴͔͙̱̘̝̩̯̖͉̘̆́ͫ̇̉ͭ̒ͣ̍̌̈̒ͩ̉̇̈̅́̀d̵̛͔̯̝̣̈́̅̃͐͋̆ͣ͊̂̂ͧ͐̐̇͒̚̚͘ ̅̿̑ͬ͢͠͏̴͈͉̫̠̥̺̜̘͓̦̦͈̦͙̤̮ŗ̛̰̬͓̯̜̫͖͈̟̮̾ͪ̎̅ͬͨ̑̈́́͡ͅę̸͍̰͕̠̪̺͇̹̦̭̆̈̂̌ͧͨͣͤͦ͌ͭ̇͊̈́̃ͫͅpͪ̊͌̊͊ͥͫ̄̇̈́̏ͦ̏͡͏̰̳̬̼͈́r̵̷̛͈̻̤̫̮̮̞̺̝͊ͦ̏͛̅͛͗̂͛̐ͯ̀e͛͗͂̑̔̃̈ͬ͂ͫ̚͘͜͏̧̳̩̥̩̻̙̫̩̤̙͔̠̪̗̞̹̩͠ͅs̻̤̤̥̜̞̮̠̞̱͇̝̰̜̤͓͋ͣ̓͌̍̔̓͂̚͘͘ͅe̛̥̬̠̭̫̞̠̺̬̲̩̮̹͎̱͉͚͉̺͌͊̾̈ͦ̊̐̒̕͜n̵̡ͣ̏ͥ̓͋͊̿̽͋ͮͨ̈́͐ͥͨ͋̚҉̢͚̙͍̖̪̗ͅţ̧͕̹̺̤ͧ̉ͤ̆̃̃̾̄͂̓ͮ͐̅̽̂̽͡͝͝i̡̛̥̬̦̗̝̮̘̣̭̻̲̘̘̬̎͌̈́ͧ̏̐ͣ̌̃̌ͮ̑́͞ͅn̡͉̰̠̱̙̰̼̼̯̦̱͓̟̻̰̒̍̾ͣͮͩ́̕͜͟g̸̮̳̤̜͓͙͙̮̙̰͉̞̠̗̼ͬ̒̔̓̆ͥ̂̍͑̈́ͤͨ͛ͬ̚̚̚͟͝͝͞ͅ ̷̢ͨ͒͗ͨ͝҉̠̮̪͖̳̣̝̮̠̪̕c͋̈́̊̐̈́ͣ͂͗̆ͦ͂̽̃҉̴̢̧̹̬͍̪̗͚͉͙͟ͅh̙̟̜̹̪̫͕̟̗̥̼̪͂̑̃̓ͯͫ̅ͭ̒́̕͡ȧ̷̲͓̞̮̦̭ͤ͊ͧ̋̿̅̃͑̈ͫ̃ͤ͟͡ͅoͥͤ͐ͣ̅͏̢̧͖̤̩̰̭͙͓͙͕͓̘̱̻̻̲͓͔͡sͥ͑̎ͦ̃̓̓ͯ̈́̆̉ͮ͂̒ͫ̀̚̚͞҉̨͎̺̘̞̪̘͜ͅ"
    let result = try JSONParser().parse(
      bytes: [UInt8](#""\#(string)""#.utf8))
    XCTAssertEqual(result, .string(string))
  }
  
  func testEscapedQuotesString() throws {
    let result = try JSONParser().parse(bytes: [UInt8](#""\\\"""#.utf8))
    XCTAssertEqual(result, .string(#"\""#))
  }
  
  func testSimpleEscapedUnicode() throws {
    let result = try JSONParser().parse(bytes: [UInt8](#""\u005A""#.utf8))
    XCTAssertEqual(result, .string("Z"))
  }
  
  func test12CharacterSequenceUnicode() throws {
    do {
      // from: https://en.wikipedia.org/wiki/UTF-16#Examples
      let result1 = try JSONParser().parse(bytes: [UInt8](#""\uD801\uDC37""#.utf8))
      XCTAssertEqual(result1, .string("𐐷"))
      
      let result2 = try JSONParser().parse(bytes: [UInt8](#""\uD852\uDF62""#.utf8))
      XCTAssertEqual(result2, .string("\u{24B62}"))
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testHighSurrogateBitPatternFollowedByPlainUnicode() throws {
    let testString = #""abc \uD801\u005A""#
    do {
      _ = try JSONParser().parse(bytes: [UInt8](testString.utf8))
      XCTFail("Did not expect to reach this point")
    }
    catch JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(let failureString, 16) {
      // failure string doesn't have enclosing quotes
      XCTAssertEqual(testString, "\"\(failureString)\"")
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testHighSurrogateBitPatternFollowedByAsciiCharacters() throws {
    let testString = #""\uD801abc""#
    do {
      _ = try JSONParser().parse(bytes: [UInt8](testString.utf8))
      XCTFail("Did not expect to reach this point")
    }
    catch JSONError.expectedLowSurrogateUTF8SequenceAfterHighSurrogate(let failureString, 8) {
      // failure string doesn't have enclosing quotes
      XCTAssertEqual(failureString, #"\uD801ab"#)
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testHighSurrogateBitPatternFollowedByNothing() throws {
    let testString = #""\uD801""#
    do {
      _ = try JSONParser().parse(bytes: [UInt8](testString.utf8))
      XCTFail("Did not expect to reach this point")
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testHighSurrogateBitPatternFollowedByIncompleteLowSurrogate() throws {
    let testString = #""\uD801\uDC""#
    do {
      _ = try JSONParser().parse(bytes: [UInt8](testString.utf8))
      XCTFail("Did not expect to reach this point")
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testIncompleteEscapedUnicode() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"\\u005\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
      _ = try parser.parseString()
      XCTFail("this point should not be reached")
    }
    catch JSONError.invalidHexDigitSequence("005\"", index: 3) {
      // expected case
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testInvalidEscapedCharacter() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8](#""\y""#.utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedEscapedCharacter(ascii: UInt8(ascii: "y"), in: _, index: 2) {
      // expected case
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedReversedSolidus() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8](#"" \ ""#.utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedEscapedCharacter(ascii: UInt8(ascii: " "), in: _, index: 3) {
      // expected case
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedNewline() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("\" \n \"".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unescapedControlCharacterInString(ascii: UInt8(ascii: "\n"), in: _, index: 2) {
      // expected case
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedTab() throws {
    do {
      _ = try JSONParser().parse(bytes: [UInt8]("\" \t \"".utf8))
      XCTFail("this point should not be reached")
    }
    catch JSONError.unescapedControlCharacterInString(ascii: UInt8(ascii: "\t"), in: _, index: 2) {
      // expected case
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedControlCharacters() throws {
    // All Unicode characters may be placed within the
    // quotation marks, except for the characters that MUST be escaped:
    // quotation mark, reverse solidus, and the control characters (U+0000
    // through U+001F).
    // https://tools.ietf.org/html/rfc7159#section-7
    
    for index in 0...31 {
      var scalars = "\"".unicodeScalars
      scalars.append(Unicode.Scalar(index)!)
      scalars.append(contentsOf: "\"".unicodeScalars)

      var parser = JSONParserImpl(bytes: [UInt8](String(scalars).utf8))
      _ = try XCTUnwrap(parser.reader.read())
  
      do {
        _ = try parser.parseString()
        XCTFail("this point should not be reached")
      }
      catch JSONError.unescapedControlCharacterInString(ascii: UInt8(index), in: _, index: 1) {
        // expected case
      }
      catch {
        // missing explicit error catch
        XCTFail("Unexpected error: \(error)")
      }
    }
  }
}
