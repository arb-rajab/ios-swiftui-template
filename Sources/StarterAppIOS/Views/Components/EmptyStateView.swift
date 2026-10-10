import SwiftUI

/// "Nothing here yet" placeholder. The button shows only when both
/// `actionTitle` and `action` are set.
struct EmptyStateView: View {
    let title: String
    let message: String?
    let systemImage: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        message: String? = nil,
        systemImage: String = "tray",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }

    /// Whether the call-to-action button is part of the layout.
    var showsAction: Bool {
        actionTitle != nil && action != nil
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.primary)
                    .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView(title: "Nothing yet", message: "Add your first item.", actionTitle: "Add", action: {})
}
