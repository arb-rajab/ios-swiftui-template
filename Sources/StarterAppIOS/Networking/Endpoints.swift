import Foundation

/// Where the GraphQL API lives. The path is fixed (`/graphql`, for HTTP and
/// WebSocket alike); the only thing that varies by deployment is the host.
enum StarterAppEndpoint {
    /// Defaults to a conventional local dev address. Override at build time
    /// via the `StarterAppHost` Info.plist key for a staging or production
    /// deployment - never hardcode a real host here.
    static var host: String {
        Bundle.main.object(forInfoDictionaryKey: "StarterAppHost") as? String ?? "localhost:4000"
    }

    /// Plaintext (`http://`/`ws://`) is only ever used for the conventional
    /// local dev address, and only when the app wasn't given an explicit
    /// `StarterAppHost` at all. Any configured host - staging, production, or
    /// anything else an operator points this at - always gets an encrypted
    /// scheme. A genuine plaintext local backend on a non-default host must
    /// opt in explicitly via the `StarterAppAllowInsecureHTTP` Info.plist key;
    /// this is never a silent default.
    static var usesPlaintext: Bool {
        usesPlaintext(
            host: host,
            isDefaultHost: Bundle.main.object(forInfoDictionaryKey: "StarterAppHost") as? String == nil,
            allowInsecureOverride: Bundle.main.object(forInfoDictionaryKey: "StarterAppAllowInsecureHTTP") as? Bool == true
        )
    }

    static var httpURL: URL {
        URL(string: "\(usesPlaintext ? "http" : "https")://\(host)/graphql")!
    }

    static var webSocketURL: URL {
        URL(string: "\(usesPlaintext ? "ws" : "wss")://\(host)/graphql")!
    }

    /// Pure decision logic, factored out so it can be unit-tested without a
    /// real `Bundle.main` Info.plist (see `EndpointsSchemeTests`).
    static func usesPlaintext(host: String, isDefaultHost: Bool, allowInsecureOverride: Bool) -> Bool {
        if allowInsecureOverride {
            return true
        }
        return isDefaultHost && isLocalDevHost(host)
    }

    private static func isLocalDevHost(_ host: String) -> Bool {
        let hostname = host.split(separator: ":").first.map(String.init) ?? host
        return hostname == "localhost" || hostname == "127.0.0.1" || hostname == "::1"
    }
}
