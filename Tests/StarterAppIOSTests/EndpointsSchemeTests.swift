import XCTest
@testable import StarterAppIOS

final class EndpointsSchemeTests: XCTestCase {
    func testDefaultLocalhostHostUsesPlaintext() {
        XCTAssertTrue(
            StarterAppEndpoint.usesPlaintext(host: "localhost:4000", isDefaultHost: true, allowInsecureOverride: false)
        )
    }

    func testConfiguredProductionHostUsesEncryptedScheme() {
        XCTAssertFalse(
            StarterAppEndpoint.usesPlaintext(host: "api.example.com", isDefaultHost: false, allowInsecureOverride: false)
        )
    }

    func testConfiguredHostIsEncryptedEvenIfItLooksLikeLocalhost() {
        // A staging/production deployment that happens to be reachable at a
        // "localhost"-shaped address must still be explicit about opting
        // into plaintext - the default-host check alone isn't enough.
        XCTAssertFalse(
            StarterAppEndpoint.usesPlaintext(host: "localhost:4000", isDefaultHost: false, allowInsecureOverride: false)
        )
    }

    func testExplicitOptInAllowsPlaintextForNonDefaultHost() {
        XCTAssertTrue(
            StarterAppEndpoint.usesPlaintext(host: "192.168.1.50:4000", isDefaultHost: false, allowInsecureOverride: true)
        )
    }

    func testDefaultHostRemoteLoopbackVariantsStayPlaintext() {
        XCTAssertTrue(
            StarterAppEndpoint.usesPlaintext(host: "127.0.0.1:4000", isDefaultHost: true, allowInsecureOverride: false)
        )
    }
}
