import SwiftUI

/// A theme-aware row container for displaying a title and custom content.
///
/// Use `DesignRow` to group content in a visually distinct row, optionally with a title and tap action. The row adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - title: An optional title to display above the row content.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). If not provided, the row will use the propagated scheme from the environment (see below).
///   - action: An optional tap action for the row.
///   - content: The custom content to display in the row.
///
/// ### Color Scheme Propagation
/// If you nest a `DesignRow` inside a container (such as `DesignCard`), the row will automatically use the next color scheme in the sequence unless you explicitly set the `scheme` parameter. This enables consistent, visually distinct UIs with minimal configuration.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .primary) {
///     DesignRow(title: "Info") { ... } // uses .secondary by default
///     DesignRow(title: "Primary", scheme: .primary) { ... } // uses .primary explicitly
/// }
/// ```
public struct DesignRow<Content: View>: View {
    let title: String?
    let scheme: DesignScheme?
    let action: (() -> Void)?
    let content: Content
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme

    public init(
        title: String? = nil,
        scheme: DesignScheme? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
        self.content = content()
    }

    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
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

#Preview {
    BaseView {
        Text("DesignRow")
            .font(.headline)
        DesignRow(
            title: "Primary Row",
            action: { print("Tapped!") }
        ) {
            Image(systemName: "star")
        }
        DesignRow(
            title: "Secondary Row",
            scheme: .secondary,
            action: { print("Tapped!") }
        ) {
            Image(systemName: "heart")
        }
        DesignRow(
            title: "Accent Row",
            scheme: .accent,
            action: { print("Tapped!") }
        ) {
            Image(systemName: "bolt")
        }
    }
}
