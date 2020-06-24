@testable import PureSwiftJSONCoding
import XCTest

class DateCodingTests: XCTestCase {
    @propertyWrapper
    struct DateStringCoding: Codable {
        var wrappedValue: Date

        init(wrappedValue: Date) {
            self.wrappedValue = wrappedValue
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = Self.dateFormatter.date(from: dateString) else {
                let dateFormat = String(describing: Self.dateFormatter.dateFormat)
                throw DecodingError.dataCorruptedError(in: container, debugDescription:
                    "Expected date to be in format `\(dateFormat)`, but `\(dateString) does not forfill format`")
            }
            wrappedValue = date
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let dateString = Self.dateFormatter.string(from: wrappedValue)
            try container.encode(dateString)
        }

        private static let dateFormatter: DateFormatter = Self.createDateFormatter()
        private static func createDateFormatter() -> DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
    }

    struct MyEvent: Codable {
        @DateStringCoding
        var eventTime: Date
    }

    func testDecodeDatePropertyWrapper() {
        do {
            let dateString = "2020-03-18T13:11:10.000Z"
            let json = #"{"eventTime": "\#(dateString)"}"#
            let result = try PureSwiftJSONCoding.JSONDecoder().decode(MyEvent.self, from: [UInt8](json.utf8))

            let components = DateComponents(
                calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(secondsFromGMT: 0),
                year: 2020, month: 03, day: 18, hour: 13, minute: 11, second: 10, nanosecond: 0
            )
            XCTAssertEqual(result.eventTime, components.date)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testEncodeDatePropertyWrapper() {
        do {
            let dateString = "2020-03-18T13:11:10.000Z"
            let json = #"{"eventTime":"\#(dateString)"}"#

            let components = DateComponents(
                calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(secondsFromGMT: 0),
                year: 2020, month: 03, day: 18, hour: 13, minute: 11, second: 10, nanosecond: 0
            )

            let event = MyEvent(eventTime: components.date!)
            let bytes = try PureSwiftJSONCoding.JSONEncoder().encode(event)
            XCTAssertEqual(String(decoding: bytes, as: Unicode.UTF8.self), json)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
