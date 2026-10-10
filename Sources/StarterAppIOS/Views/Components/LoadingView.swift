import SwiftUI

/// Centered spinner with an optional message underneath.
struct LoadingView: View {
    var message: String?

    init(message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            if let message = message {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    LoadingView(message: "Loading")
}
