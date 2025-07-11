import SwiftUI

/// A theme-aware toggle (switch) for boolean values.
///
/// Use `DesignToggle` for settings, preferences, or feature toggles. The toggle adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: The label to display next to the toggle.
///   - isOn: A binding to the boolean value.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). If not provided, the toggle will use the propagated scheme from the environment (see below).
///
/// ### Color Scheme Propagation
/// If you nest a `DesignToggle` inside a container (such as `DesignCard`), the toggle will automatically use the next color scheme in the sequence unless you explicitly set the `scheme` parameter. This enables consistent, visually distinct UIs with minimal configuration.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .primary) {
///     DesignToggle(title: "Enable", isOn: $enabled) // uses .secondary by default
///     DesignToggle(title: "Enable", isOn: $enabled, scheme: .primary) // uses .primary explicitly
/// }
/// ```
public struct DesignToggle: View {
    let title: String
    @Binding var isOn: Bool
    let scheme: DesignScheme?
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        title: String,
        isOn: Binding<Bool>,
        scheme: DesignScheme? = nil
    ) {
        self.title = title
        self._isOn = isOn
        self.scheme = scheme
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
    }
    
    public var body: some View {
        Toggle(isOn: $isOn) {
            Text(title)
                .foregroundColor(colorPair.foreground)
        }
        .toggleStyle(SwitchToggleStyle(tint: colorPair.background))
        .padding()
        .background(colorPair.background.opacity(0.15))
        .cornerRadius(10)
    }
} 