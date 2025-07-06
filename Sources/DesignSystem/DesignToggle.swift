import SwiftUI

/// A theme-aware toggle (switch) for boolean values.
///
/// Use `DesignToggle` for settings, preferences, or feature toggles. The toggle adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: The label to display next to the toggle.
///   - isOn: A binding to the boolean value.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .primary.
///
/// Example:
/// ```swift
/// DesignToggle(title: "Enable notifications", isOn: $enabled)
/// ```
public struct DesignToggle: View {
    let title: String
    @Binding var isOn: Bool
    let scheme: DesignScheme
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        title: String,
        isOn: Binding<Bool>,
        scheme: DesignScheme = .primary
    ) {
        self.title = title
        self._isOn = isOn
        self.scheme = scheme
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
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