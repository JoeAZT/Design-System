import SwiftUI

/// A theme-aware button that uses your app's design color scheme.
///
/// Use `DesignButton` for primary, secondary, or accent actions. The button automatically adapts its colors based on the current `DesignSystemColorProvider`.
///
/// - Parameters:
///   - title: The text to display inside the button.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .primary.
///   - action: The action to perform when the button is tapped.
///
/// Example:
/// ```swift
/// DesignButton(title: "Save", scheme: .accent) { ... }
/// ```
public struct DesignButton: View {
    let title: String
    let action: (() -> Void)?
    let scheme: DesignScheme
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        title: String,
        scheme: DesignScheme = .primary,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
    }

    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }

    public var body: some View {
        let button = Text(title)
            .font(.headline)
            .foregroundColor(colorPair.foreground)
            .frame(maxWidth: .infinity)
            .padding()
            .background(colorPair.background)
            .cornerRadius(10)
        if let action = action {
            Button(action: action) { button }
                .buttonStyle(PlainButtonStyle())
        } else {
            button
        }
    }
} 