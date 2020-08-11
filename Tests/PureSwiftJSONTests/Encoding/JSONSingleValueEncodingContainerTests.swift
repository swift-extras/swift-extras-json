@testable import PureSwiftJSON
import XCTest

class JSONSingleValueEncodingContainerTests: XCTestCase {
    func testEncodeEncodable() {
        struct Name: Encodable {
            var firstName: String
            var surname: String
        }

        struct Object: Encodable {
            var name: Name

            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(self.name)
            }
        }

        let object = Object(name: Name(firstName: "Adam", surname: "Fowler"))
        var json: [UInt8]?
        XCTAssertNoThrow(json = try PSJSONEncoder().encode(object))

        var parsed: JSONValue?
        XCTAssertNoThrow(parsed = try JSONParser().parse(bytes: XCTUnwrap(json)))
        XCTAssertEqual(parsed, .object(["firstName": .string("Adam"), "surname": .string("Fowler")]))
    }
}
