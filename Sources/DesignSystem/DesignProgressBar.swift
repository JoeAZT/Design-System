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
    public enum FontSize {
        case small, medium, large
        
        var font: Font {
            switch self {
            case .small: return .caption
            case .medium: return .body
            case .large: return .title3
            }
        }
    }
    
    let value: Double // 0.0 ... 1.0
    let lowerBound: String?
    let upperBound: String?
    let title: String?
    let scheme: DesignScheme?
    let fontSize: FontSize
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        value: Double,
        lowerBound: String? = nil,
        upperBound: String? = nil,
        title: String? = nil,
        scheme: DesignScheme? = nil,
        fontSize: FontSize = .medium
    ) {
        self.value = value
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.title = title
        self.scheme = scheme
        self.fontSize = fontSize
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                Text(title)
                    .font(fontSize.font)
                    .foregroundColor(colorPair.foreground)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 12)
                        .foregroundColor(colorPair.background.opacity(0.2))
                    Capsule()
                        .frame(width: max(0, min(CGFloat(value), 1.0)) * geometry.size.width, height: 12)
                        .foregroundColor(colorPair.background)
                }
            }
            .frame(height: 12)
            if lowerBound != nil || upperBound != nil {
                HStack {
                    if let lower = lowerBound {
                        Text(lower)
                    }
                    Spacer()
                    if let upper = upperBound {
                        Text(upper)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
} 

#Preview {
    BaseView {
        DesignProgressBar(
            value: 0.3,
            title: "Primary - small title Progress",
            fontSize: .small
        )
        DesignProgressBar(
            value: 0.3,
            title: "Secondary - medium title Progress",
            scheme: .secondary
        )
        DesignProgressBar(
            value: 0.6,
            title: "Accent - large title Progress",
            scheme: .accent,
            fontSize: .large
        )
    }
}
