import SwiftUI
import XCTest
@testable import StarterAppIOS

/// The shared views are thin SwiftUI layouts, so these tests cover the
/// decisions they make (when the retry/action buttons exist, how dimmed a
/// button is) and that each `body` can be built without trapping. Pixel
/// output isn't asserted.
@MainActor
final class SharedViewsTests: XCTestCase {
    func testLoadingViewKeepsItsMessage() {
        XCTAssertNil(LoadingView().message)
        XCTAssertEqual(LoadingView(message: "Loading").message, "Loading")
        _ = LoadingView(message: "Loading").body
    }

    func testErrorStateViewShowsRetryOnlyWithACallback() {
        XCTAssertFalse(ErrorStateView(message: "Boom").showsRetry)
        XCTAssertTrue(ErrorStateView(message: "Boom", onRetry: {}).showsRetry)
    }

    func testErrorStateViewRetryInvokesTheCallback() {
        var retries = 0
        let view = ErrorStateView(message: "Boom", onRetry: { retries += 1 })

        view.onRetry?()

        XCTAssertEqual(retries, 1)
        XCTAssertEqual(view.retryTitle, "Try Again")
        _ = view.body
    }

    func testEmptyStateViewShowsActionOnlyWithTitleAndCallback() {
        XCTAssertFalse(EmptyStateView(title: "Nothing").showsAction)
        XCTAssertFalse(EmptyStateView(title: "Nothing", actionTitle: "Add").showsAction)
        XCTAssertFalse(EmptyStateView(title: "Nothing", action: {}).showsAction)
        XCTAssertTrue(EmptyStateView(title: "Nothing", actionTitle: "Add", action: {}).showsAction)
    }

    func testEmptyStateViewDefaults() {
        let view = EmptyStateView(title: "Nothing")

        XCTAssertEqual(view.systemImage, "tray")
        XCTAssertNil(view.message)
        _ = view.body
    }

    func testPrimaryButtonStyleDimsWhenDisabledOrPressed() {
        XCTAssertEqual(PrimaryButtonStyle.opacity(isEnabled: true, isPressed: false), 1.0)
        XCTAssertEqual(PrimaryButtonStyle.opacity(isEnabled: true, isPressed: true), 0.8)
        XCTAssertEqual(PrimaryButtonStyle.opacity(isEnabled: false, isPressed: false), 0.5)
        XCTAssertEqual(PrimaryButtonStyle.opacity(isEnabled: false, isPressed: true), 0.5)
    }
}
