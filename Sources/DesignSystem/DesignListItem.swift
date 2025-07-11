import SwiftUI

/// A theme-aware list row with leading/trailing content, title, subtitle, and tap action.
///
/// Use `DesignListItem` for lists, menus, or navigation. The row adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: The main text to display.
///   - subtitle: An optional subtitle below the title.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). If not provided, the list item will use the propagated scheme from the environment (see below).
///   - leading: An optional leading view (e.g., icon).
///   - trailing: An optional trailing view (e.g., detail text).
///   - action: An optional tap action for the row.
///
/// ### Color Scheme Propagation
/// If you nest a `DesignListItem` inside a container (such as `DesignCard`), the list item will automatically use the next color scheme in the sequence unless you explicitly set the `scheme` parameter. This enables consistent, visually distinct UIs with minimal configuration.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .primary) {
///     DesignListItem(title: "Settings") // uses .secondary by default
///     DesignListItem(title: "Settings", scheme: .primary) // uses .primary explicitly
/// }
/// ```
public struct DesignListItem<Leading: View, Trailing: View>: View {
    let title: String
    let subtitle: String?
    let scheme: DesignScheme?
    let leading: Leading
    let trailing: Trailing
    let action: (() -> Void)?
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        title: String,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
        @ViewBuilder leading: () -> Leading = { EmptyView() },
        @ViewBuilder trailing: () -> Trailing = { EmptyView() },
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
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
    }
    
    public var body: some View {
        let row = HStack(spacing: 12) {
            leading
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
            trailing
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
