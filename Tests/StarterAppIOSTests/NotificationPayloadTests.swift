import XCTest
@testable import StarterAppIOS

final class NotificationPayloadTests: XCTestCase {
    func testParsesTheItemId() {
        let payload = NotificationPayload(userInfo: ["itemId": "i1"])
        XCTAssertEqual(payload?.itemId, "i1")
    }

    func testFailsWithoutItemId() {
        XCTAssertNil(NotificationPayload(userInfo: [:]))
        XCTAssertNil(NotificationPayload(userInfo: ["other": "x"]))
    }

    func testIgnoresNonStringOrEmptyItemId() {
        XCTAssertNil(NotificationPayload(userInfo: ["itemId": 42]))
        XCTAssertNil(NotificationPayload(userInfo: ["itemId": ""]))
    }
}
