@testable import PureSwiftJSONCoding
@testable import PureSwiftJSONParsing
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
                try container.encode(name)
            }
        }

        do {
            let object = Object(name: Name(firstName: "Adam", surname: "Fowler"))
            let json = try PureSwiftJSONCoding.JSONEncoder().encode(object)

            let parsed = try JSONParser().parse(bytes: json)
            XCTAssertEqual(parsed, .object(["firstName": .string("Adam"), "surname": .string("Fowler")]))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
