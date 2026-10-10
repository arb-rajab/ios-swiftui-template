import XCTest
@testable import StarterAppIOS

/// Feeds push payloads through the same `DeepLinkCoordinator` that
/// `AppDelegate` uses for a real tap in any of the three app states
/// (foreground/background/killed) - they all funnel through `handle`. A real
/// push can't be delivered to a CI simulator, so this is the layer that can
/// be exercised without live APNs credentials.
@MainActor
final class DeepLinkCoordinatorTests: XCTestCase {
    func testHandlesAPushPayload() {
        let coordinator = DeepLinkCoordinator()
        coordinator.handle(userInfo: [
            "aps": ["alert": ["title": "Hello", "body": "World"], "sound": "default"],
            "itemId": "item-123",
        ])

        XCTAssertEqual(coordinator.pendingRoute, .item(id: "item-123"))
    }

    func testIgnoresAPayloadMissingTheItemIdContract() {
        let coordinator = DeepLinkCoordinator()
        coordinator.handle(userInfo: [
            "aps": ["alert": ["title": "Malformed", "body": "No itemId key"]],
        ])

        XCTAssertNil(coordinator.pendingRoute)
    }

    func testConsumingThePendingRouteClearsIt() {
        let coordinator = DeepLinkCoordinator()
        coordinator.handle(userInfo: ["itemId": "i1"])

        let consumed = coordinator.consumePendingRoute()

        XCTAssertEqual(consumed, .item(id: "i1"))
        XCTAssertNil(coordinator.pendingRoute)
        XCTAssertNil(coordinator.consumePendingRoute())
    }

    func testASecondPushOverwritesAnUnconsumedRoute() {
        let coordinator = DeepLinkCoordinator()
        coordinator.handle(userInfo: ["itemId": "first"])
        coordinator.handle(userInfo: ["itemId": "second"])

        XCTAssertEqual(coordinator.pendingRoute, .item(id: "second"))
    }
}
