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
    let scheme: DesignScheme
    let content: Content
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        scheme: DesignScheme = .primary,
        @ViewBuilder content: () -> Content
    ) {
        self.scheme = scheme
        self.content = content()
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .padding()
        .background(colorPair.background)
        .foregroundColor(colorPair.foreground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
} 