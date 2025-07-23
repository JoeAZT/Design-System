import SwiftUI

/// A theme-aware card container for grouping related content.
///
/// Use `DesignCard` to visually group content with padding, background, and optional shadow. The card adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .primary.
///   - content: The content to display inside the card.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .accent) {
///     Text("Important Info")
/// }
/// ```
public struct DesignCard<Content: View>: View {
    public enum Spacing {
        case small, medium, large, extraLarge
        
        var value: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 16
            case .large: return 24
            case .extraLarge: return 32
            }
        }
    }
    
    let title: String?
    let scheme: DesignScheme
    let spacing: Spacing
    let content: Content
    let alignment: Alignment
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        title: String? = nil,
        scheme: DesignScheme = .primary,
        spacing: Spacing = .medium,
        alignment: Alignment = .leading,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.scheme = scheme
        self.spacing = spacing
        self.alignment = alignment
        self.content = content()
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing.value) {
            if let title = title {
                Text(title)
                    .font(.headline)
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: alignment)
        .padding(spacing.value)
        .background(colorPair.background)
        .foregroundColor(colorPair.foreground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .environment(\.designSystemDefaultChildScheme, scheme.next)
    }
} 

#Preview {
    BaseView {
        Text("Design cards")
        DesignCard {
            Text("DesignCard primary")
        }
        DesignCard(
            title: "DesignCard title",
            scheme: .secondary
        ) {
            Text("what?")
        }
        DesignCard(
            title: "DesignCard title",
            scheme: .accent
        ) {
            Text("Design Card content")
        }
        DesignCard {
            Text("DesignCard primary")
            DesignProgressBar(value: 0.5, scheme: .accent)
        }
        DesignCard(scheme: .secondary) {
            Text("DesignCard primary")
            DesignProgressBar(value: 0.5, scheme: .accent)
        }
    }
}
