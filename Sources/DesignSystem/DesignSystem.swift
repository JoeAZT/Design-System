import SwiftUI

// MARK: - User-Defined Colors Protocol
public protocol DesignSystemColorProvider: Sendable {
    var primaryForeground: Color { get }
    var primaryBackground: Color { get }
    var secondaryForeground: Color { get }
    var secondaryBackground: Color { get }
    var accentForeground: Color { get }
    var accentBackground: Color { get }
}

// MARK: - Default Color Provider
public struct DefaultDesignSystemColors: DesignSystemColorProvider {
    public let primaryForeground: Color = .white
    public let primaryBackground: Color = .gray
    public let secondaryForeground: Color = .white
    public let secondaryBackground: Color = .gray
    public let accentForeground: Color = .white
    public let accentBackground: Color = .green
    
    public init() {}
}

public enum DesignScheme {
    case primary, secondary, accent
}

public struct DesignSchemeColorPair: Sendable {
    public let foreground: Color
    public let background: Color
    public init(foreground: Color, background: Color) {
        self.foreground = foreground
        self.background = background
    }
}

public struct DesignSchemeColors: Sendable {
    public let primary: DesignSchemeColorPair
    public let secondary: DesignSchemeColorPair
    public let accent: DesignSchemeColorPair
    
    public init(
        primary: DesignSchemeColorPair = .init(foreground: .white, background: .gray),
        secondary: DesignSchemeColorPair = .init(foreground: .white, background: .gray),
        accent: DesignSchemeColorPair = .init(foreground: .white, background: .green)
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
    }
    
    public init(from provider: DesignSystemColorProvider) {
        self.primary = DesignSchemeColorPair(
            foreground: provider.primaryForeground,
            background: provider.primaryBackground
        )
        self.secondary = DesignSchemeColorPair(
            foreground: provider.secondaryForeground,
            background: provider.secondaryBackground
        )
        self.accent = DesignSchemeColorPair(
            foreground: provider.accentForeground,
            background: provider.accentBackground
        )
    }
    
    public func colors(for scheme: DesignScheme) -> DesignSchemeColorPair {
        switch scheme {
        case .primary: return primary
        case .secondary: return secondary
        case .accent: return accent
        }
    }
}

// MARK: - Environment Keys
private struct DesignSchemeKey: EnvironmentKey {
    static let defaultValue = DesignSchemeColors()
}

private struct ColorProviderKey: EnvironmentKey {
    static let defaultValue: DesignSystemColorProvider = DefaultDesignSystemColors()
}

public extension EnvironmentValues {
    var designSchemeColors: DesignSchemeColors {
        get { self[DesignSchemeKey.self] }
        set { self[DesignSchemeKey.self] = newValue }
    }
    
    var designSystemColorProvider: DesignSystemColorProvider {
        get { self[ColorProviderKey.self] }
        set { 
            self[ColorProviderKey.self] = newValue
            // Automatically update the design scheme colors when provider changes
            self[DesignSchemeKey.self] = DesignSchemeColors(from: newValue)
        }
    }
}

// MARK: - View Extensions
public extension View {
    func designSchemeColors(_ colors: DesignSchemeColors) -> some View {
        environment(\.designSchemeColors, colors)
    }
    
    func designSystemColorProvider(_ provider: DesignSystemColorProvider) -> some View {
        environment(\.designSystemColorProvider, provider)
    }
}

public extension DesignSystemColorProvider {
    func createBackgroundGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                primaryBackground,
                accentBackground.opacity(0.9)
            ],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

public struct DesignButton: View {
    let title: String
    let action: (() -> Void)?
    let scheme: DesignScheme?
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        title: String,
        scheme: DesignScheme? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
    }

    private var colorPair: DesignSchemeColorPair {
        if let scheme = scheme {
            return schemeColors.colors(for: scheme)
        } else {
            return schemeColors.colors(for: .primary)
        }
    }

    public var body: some View {
        let button = Text(title)
            .font(.headline)
            .foregroundColor(colorPair.foreground)
            .frame(maxWidth: .infinity)
            .padding()
            .background(colorPair.background)
            .cornerRadius(10)
        if let action = action {
            Button(action: action) { button }
                .buttonStyle(PlainButtonStyle())
        } else {
            button
        }
    }
}

public extension DesignButton {
    func designScheme(_ scheme: DesignScheme) -> DesignButton {
        DesignButton(title: self.title, scheme: scheme, action: self.action)
    }
}

public extension DesignRow {
    func designScheme(_ scheme: DesignScheme) -> DesignRow<Content> {
        DesignRow(title: self.title, scheme: scheme, action: self.action) {
            self.content
        }
    }
}

public struct DesignRow<Content: View>: View {
    let title: String?
    let scheme: DesignScheme?
    let action: (() -> Void)?
    let content: Content
    @Environment(\.designSchemeColors) private var schemeColors

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
        if let scheme = scheme {
            return schemeColors.colors(for: scheme)
        } else {
            return schemeColors.colors(for: .primary)
        }
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

public struct BaseView<Content: View>: View {
    let background: LinearGradient?
    let padding: CGFloat
    let content: Content
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        background: LinearGradient? = nil,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.padding = padding
        self.content = content()
    }
    
    private var defaultBackground: LinearGradient {
        LinearGradient(
            colors: [.white],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(background ?? defaultBackground)
            .ignoresSafeArea()
    }
}

#Preview {
    // Example of how users can define their own colors
    struct MyCustomColors: DesignSystemColorProvider {
        let primaryForeground: Color = .white
        let primaryBackground: Color = .black.opacity(0.8)
        let secondaryForeground: Color = .white
        let secondaryBackground: Color = .gray
        let accentForeground: Color = .white
        let accentBackground: Color = .green
    }
    
    return BaseView(
        background: MyCustomColors().createBackgroundGradient()
    ) {
        VStack(spacing: 16) {
            // Using custom colors - set once at the top level
            Text("Custom Colors (set once):")
                .font(.headline)
                .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                DesignRow(title: "Custom Primary Row", action: { print("Tapped!") }) {
                    Image(systemName: "star")
                }
                
                DesignRow(title: "Custom Secondary Row", action: { print("Tapped!") }) {
                    Image(systemName: "heart")
                }
                .designScheme(.secondary)
                
                DesignRow(title: "Custom Accent Row", action: { print("Tapped!") }) {
                    Image(systemName: "bolt")
                }
                .designScheme(.accent)
                
                DesignButton(
                    title: "Custom Primary Button",
                    action: { print("Primary tapped") }
                )
                
                DesignButton(
                    title: "Custom Secondary Button",
                    action: { print("Secondary tapped") }
                )
                .designScheme(.secondary)
                
                DesignButton(
                    title: "Custom Accent Button",
                    action: { print("Accent tapped") }
                )
                .designScheme(.accent)
            }
            .designSystemColorProvider(MyCustomColors())
        }
    }
}
