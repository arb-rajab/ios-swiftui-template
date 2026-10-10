import XCTest
@testable import StarterAppIOS

final class KeychainStoreTests: XCTestCase {
    /// A fresh service name per test avoids cross-test pollution - the
    /// Simulator's Keychain persists across test runs within a session.
    private func makeStore() -> KeychainStore {
        KeychainStore(service: "com.example.starterapp.tests.\(UUID().uuidString)")
    }

    func testSavesAndLoadsAToken() throws {
        let store = makeStore()
        defer { store.clear() }

        try store.save(token: "jwt-abc")

        XCTAssertEqual(store.loadToken(), "jwt-abc")
    }

    func testSavingATokenOverwritesThePreviousOne() throws {
        let store = makeStore()
        defer { store.clear() }

        try store.save(token: "first")
        try store.save(token: "second")

        XCTAssertEqual(store.loadToken(), "second")
    }

    func testClearRemovesTheStoredToken() throws {
        let store = makeStore()
        try store.save(token: "jwt-abc")

        store.clear()

        XCTAssertNil(store.loadToken())
    }

    func testLoadReturnsNilWhenNothingWasEverSaved() {
        let store = makeStore()
        XCTAssertNil(store.loadToken())
    }
}
