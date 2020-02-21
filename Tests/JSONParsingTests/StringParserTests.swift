import XCTest
@testable import PureSwiftJSONParsing

class StringParserTests: XCTestCase {
  
  func testSimpleHelloString() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"Hello\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()
    XCTAssertEqual(result, "Hello")
  }
  
  func testSimpleEscapedUnicode() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"\\u005A\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()
    XCTAssertEqual(result, "Z")
    
 
  }
  
  func testIncompleteEscapedUnicode() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"\\u005\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
       _ = try parser.parseString()
       XCTFail("this point should not be reached")
     }
     catch {
       // missing explicit error catch
       XCTFail("Unexpected error: \(error)")
     }
  }
  
  func testEscapedQuotesString() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"\\\"\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseString()
    XCTAssertEqual(result, "\\\"")
  }
  
  func testInvalidEscapedCharacter() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\"\\y\"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
      _ = try parser.parseString()
      XCTFail("this point should not be reached")
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedReversedSolidus() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\" \\ \"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
      _ = try parser.parseString()
      XCTFail("this point should not be reached")
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedNewline() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("\" \n \"".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    
    do {
      _ = try parser.parseString()
      XCTFail("this point should not be reached")
    }
    catch {
      // missing explicit error catch
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testUnescapedTab() throws {
     var parser = JSONParserImpl(bytes: [UInt8]("\" \t \"".utf8))
     _ = try XCTUnwrap(parser.reader.read())
     
     
     do {
       _ = try parser.parseString()
       XCTFail("this point should not be reached")
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
      catch {
        // missing explicit error catch
        XCTFail("Unexpected error: \(error)")
      }
    }

  }
  
  
}
