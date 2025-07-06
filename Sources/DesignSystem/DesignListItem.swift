import SwiftUI

/// A theme-aware list row with leading/trailing content, title, subtitle, and tap action.
///
/// Use `DesignListItem` for lists, menus, or navigation. The row adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: The main text to display.
///   - subtitle: An optional subtitle below the title.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .primary.
///   - leading: An optional leading view (e.g., icon).
///   - trailing: An optional trailing view (e.g., detail text).
///   - action: An optional tap action for the row.
///
/// Example:
/// ```swift
/// DesignListItem(
///     title: "Settings",
///     subtitle: "App preferences",
///     leading: { Image(systemName: "gear") },
///     trailing: { Text("Detail") },
///     action: { print("Tapped") }
/// )
/// ```
public struct DesignListItem<Leading: View, Trailing: View>: View {
    let title: String
    let subtitle: String?
    let scheme: DesignScheme
    let leading: Leading?
    let trailing: Trailing?
    let action: (() -> Void)?
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        title: String,
        subtitle: String? = nil,
        scheme: DesignScheme = .primary,
        @ViewBuilder leading: () -> Leading? = { nil },
        @ViewBuilder trailing: () -> Trailing? = { nil },
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.scheme = scheme
        self.leading = leading()
        self.trailing = trailing()
        self.action = action
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }
    
    public var body: some View {
        let row = HStack(spacing: 12) {
            if let leading = leading {
                leading
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(colorPair.foreground.opacity(0.7))
                }
            }
            Spacer()
            if let trailing = trailing {
                trailing
            }
        }
        .padding()
        .background(colorPair.background)
        .foregroundColor(colorPair.foreground)
        .cornerRadius(10)
        .contentShape(Rectangle())
        if let action = action {
            Button(action: action) { row }
                .buttonStyle(PlainButtonStyle())
        } else {
            row
        }
    }
} 