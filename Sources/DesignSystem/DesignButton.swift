import SwiftUI

/// A theme-aware button that uses your app's design color scheme.
///
/// Use `DesignButton` for primary, secondary, or accent actions. The button automatically adapts its colors based on the current `DesignSystemColorProvider`.
///
/// - Parameters:
///   - title: The text to display inside the button.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). If not provided, the button will use the propagated scheme from the environment (see below).
///   - action: The action to perform when the button is tapped.
///
/// ### Color Scheme Propagation
/// If you nest a `DesignButton` inside a container (such as `DesignCard`), the button will automatically use the next color scheme in the sequence unless you explicitly set the `scheme` parameter. This enables consistent, visually distinct UIs with minimal configuration.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .primary) {
///     DesignButton(title: "Action") // uses .secondary by default
///     DesignButton(title: "Primary", scheme: .primary) // uses .primary explicitly
/// }
/// ```
public struct DesignButton: View {
    let title: String
    let action: (() -> Void)?
    let scheme: DesignScheme?
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        title: String,
        scheme: DesignScheme? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
    }

    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
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