import Foundation

/// Mirrors the backend's `DeviceToken` GraphQL type. Deliberately does not
/// carry the raw APNs token string: the server never echoes it back, only
/// metadata.
struct DeviceTokenInfo: Codable, Identifiable, Sendable {
    let id: String
    let platform: String
    let createdAt: Date
    let lastSeenAt: Date
}
