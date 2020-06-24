@testable import PureSwiftJSON
import XCTest

class ArrayKeyTests: XCTestCase {
    func testInitWithIntValue() {
        let key = ArrayKey(intValue: 2)!
        XCTAssertEqual(key.stringValue, "Index 2")
    }

    func testInitWithIndex() {
        let key = ArrayKey(index: 12)
        XCTAssertEqual(key.stringValue, "Index 12")
    }
}
