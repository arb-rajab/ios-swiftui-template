import Foundation

/// Mirrors the backend's `User` GraphQL type.
struct User: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let email: String
    let displayName: String
    let role: String
    let createdAt: Date
}

/// Mirrors the backend's `AuthPayload` (returned by `register`/`login`).
struct AuthPayload: Codable, Sendable {
    let token: String
    let user: User
}
