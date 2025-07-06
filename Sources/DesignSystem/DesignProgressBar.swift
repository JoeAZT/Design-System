import SwiftUI

/// A theme-aware progress bar for indicating progress of a task.
///
/// Use `DesignProgressBar` to show progress in a visually consistent way. The bar adapts its colors based on the current `DesignSystemColorProvider` and the selected scheme.
///
/// - Parameters:
///   - value: The progress value (0.0 to 1.0).
///   - title: An optional label to display above the bar.
///   - scheme: The color scheme to use (.primary, .secondary, .accent). Defaults to .accent.
///
/// Example:
/// ```swift
/// DesignProgressBar(value: 0.5, title: "Uploading...", scheme: .primary)
/// ```
public struct DesignProgressBar: View {
    let value: Double // 0.0 ... 1.0
    let title: String?
    let scheme: DesignScheme
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        value: Double,
        title: String? = nil,
        scheme: DesignScheme = .accent
    ) {
        self.value = value
        self.title = title
        self.scheme = scheme
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.caption)
                    .foregroundColor(colorPair.foreground)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 8)
                        .foregroundColor(colorPair.background.opacity(0.2))
                    Capsule()
                        .frame(width: max(0, min(CGFloat(value), 1.0)) * geometry.size.width, height: 8)
                        .foregroundColor(colorPair.background)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
} 