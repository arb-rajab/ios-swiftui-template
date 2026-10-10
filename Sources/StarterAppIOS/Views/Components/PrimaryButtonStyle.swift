import SwiftUI

/// Full-width filled button. Dims while pressed and when disabled.
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    /// Opacity for a given state, kept separate from `makeBody` so it can be unit tested.
    static func opacity(isEnabled: Bool, isPressed: Bool) -> Double {
        if !isEnabled {
            return 0.5
        }
        return isPressed ? 0.8 : 1.0
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 10))
            .opacity(Self.opacity(isEnabled: isEnabled, isPressed: configuration.isPressed))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    /// `Button("Save") { ... }.buttonStyle(.primary)`
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

#Preview {
    VStack {
        Button("Continue") {}
            .buttonStyle(.primary)
        Button("Disabled") {}
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
}
