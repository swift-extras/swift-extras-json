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
  
}
