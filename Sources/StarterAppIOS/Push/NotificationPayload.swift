import Foundation

/// The custom keys your push provider puts on every payload alongside the
/// standard `aps` dictionary. Keep both sides of this contract in sync: no
/// shared schema or codegen enforces it across the app and the backend.
struct NotificationPayload: Equatable {
    let itemId: String

    init?(userInfo: [AnyHashable: Any]) {
        guard let itemId = userInfo["itemId"] as? String, !itemId.isEmpty else { return nil }
        self.itemId = itemId
    }
}
