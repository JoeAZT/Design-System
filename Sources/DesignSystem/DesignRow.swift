import SwiftUI

/// A theme-aware row container for displaying a title and custom content.
///
/// Use `DesignRow` to group content in a visually distinct row, optionally with a title and tap action. The row adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: An optional title to display above the row content.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .primary.
///   - action: An optional tap action for the row.
///   - content: The custom content to display in the row.
///
/// Example:
/// ```swift
/// DesignRow(title: "Info", scheme: .secondary) {
///     Image(systemName: "info.circle")
///     Text("Details")
/// }
/// ```
public struct DesignRow<Content: View>: View {
    let title: String?
    let scheme: DesignScheme
    let action: (() -> Void)?
    let content: Content
    @Environment(\.designSchemeColors) private var schemeColors

    public init(
        title: String? = nil,
        scheme: DesignScheme = .primary,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
        self.content = content()
    }

    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }

    public var body: some View {
        let row = VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.headline)
            }
            HStack {
                content
                Spacer()
            }
        }
        .foregroundColor(colorPair.foreground)
        .padding()
        .background(colorPair.background)
        .cornerRadius(10)
        .contentShape(Rectangle())

        if let action = action {
            Button(action: action) {
                row
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            row
        }
    }
} 