import XCTest
@testable import PureSwiftJSONParsing

class NumberParserTests: XCTestCase {
  
  func testNumberWithEverything() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12.12e+12".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "-12.12e+12")
  }
  
  func testTwelve() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("12".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "12")
  }
  
  func testHighExp() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("1000e1000".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "1000e1000")
  }
  
  func testMinusTwelve() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "-12")
  }
  
  func testMinusTwelvePointOne() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12.1".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "-12.1")
  }
  
  func testMinusTwelvePoint() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12.".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    do {
      _ = try parser.parseNumber()
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testMinusTwelveExp1() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12e1".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "-12e1")
  }
  
  func testMinusTwelveExpMinus1() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12e-1".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    let result = try parser.parseNumber()
    XCTAssertEqual(result, "-12e-1")
  }
  
  func testMinusTwelveExpMinus() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-12e-1".utf8))
    _ = try XCTUnwrap(parser.reader.read())
    
    do {
      _ = try parser.parseNumber()
    }
    catch JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  
  func testLeadingZero() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("01".utf8))
    _ = try XCTUnwrap(parser.reader.read())

    do {
      _ = try parser.parseNumber()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "0")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testLeadingZeroNegative() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-01".utf8))
    _ = try XCTUnwrap(parser.reader.read())

    do {
      _ = try parser.parseNumber()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: "0")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  
  func testTwelvePointOneWithExp() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("12.1e-1".utf8))
    _ = try XCTUnwrap(parser.reader.read())
  

    do {
      _ = try parser.parseNumber()
    }
    catch  JSONError.unexpectedEndOfFile {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testMinusPoint() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("-.".utf8))
    _ = try XCTUnwrap(parser.reader.read())

    do {
      _ = try parser.parseNumber()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: ".")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testSpaceInbetween() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("1 000".utf8))
    _ = try XCTUnwrap(parser.reader.read())

    do {
      _ = try parser.parseNumber()
      XCTFail("this point should not be reached")
    }
    catch JSONError.unexpectedCharacter(ascii: UInt8(ascii: " ")) {
      // expected
    }
    catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func testExpWithCapitalLetter() throws {
    var parser = JSONParserImpl(bytes: [UInt8]("5E7".utf8))
    _ = try XCTUnwrap(parser.reader.read())

    let result = try parser.parseNumber()
    XCTAssertEqual(result, "5E7")
  }

  
}
