import Foundation

/// A minimal GraphQL-over-HTTP client for a single `/graphql` endpoint.
/// Deliberately hand-rolled on `URLSession` rather than a GraphQL client
/// library (e.g. Apollo iOS): a small, stable API surface doesn't need a
/// generated/heavy client. Swap one in if yours outgrows this.
final class GraphQLClient {
    private let endpoint: URL
    private let session: URLSession

    /// Set by `AuthService` after login/register, cleared on sign-out.
    /// Sent as `Authorization: Bearer <token>`.
    var authToken: String?

    init(endpoint: URL, session: URLSession = .shared) {
        self.endpoint = endpoint
        self.session = session
    }

    @discardableResult
    func perform<T: Decodable>(
        query: String,
        variables: [String: Any] = [:],
        as type: T.Type
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        var body: [String: Any] = ["query": query]
        if !variables.isEmpty {
            body["variables"] = variables
        }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            throw GraphQLClientError.decoding(error.localizedDescription)
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw GraphQLClientError.transport(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw GraphQLClientError.httpStatus(status)
        }

        let envelope: GraphQLEnvelope<T>
        do {
            envelope = try JSONDecoder.api.decode(GraphQLEnvelope<T>.self, from: data)
        } catch {
            throw GraphQLClientError.decoding(error.localizedDescription)
        }

        if let firstError = envelope.errors?.first {
            throw GraphQLClientError.graphQL(message: firstError.message, code: firstError.extensions?.code)
        }
        guard let payload = envelope.data else {
            throw GraphQLClientError.noData
        }
        return payload
    }
}

private struct GraphQLEnvelope<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLErrorPayload]?
}

private struct GraphQLErrorPayload: Decodable {
    let message: String
    let extensions: Extensions?

    struct Extensions: Decodable {
        let code: String?
    }
}
