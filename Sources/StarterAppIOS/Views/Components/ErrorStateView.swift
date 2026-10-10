import SwiftUI

/// Centered error message. The retry button shows only when `onRetry` is set.
struct ErrorStateView: View {
    let message: String
    let retryTitle: String
    let onRetry: (() -> Void)?

    init(message: String, retryTitle: String = "Try Again", onRetry: (() -> Void)? = nil) {
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
    }

    /// Whether the retry button is part of the layout.
    var showsRetry: Bool {
        onRetry != nil
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text(message)
                .multilineTextAlignment(.center)
            if let onRetry = onRetry {
                Button(retryTitle, action: onRetry)
                    .buttonStyle(.bordered)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(message: "Something went wrong.", onRetry: {})
}
