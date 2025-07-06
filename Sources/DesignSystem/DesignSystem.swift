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
    let scheme: DesignScheme
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        title: String,
        scheme: DesignScheme = .primary,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.scheme = scheme
        self.action = action
    }

    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: scheme)
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
    // You can set this once at the app level like:
    // @main
    // struct MyApp: App {
    //     var body: some Scene {
    //         WindowGroup {
    //             ContentView()
    //                 .designSystemColorProvider(MyCustomColors())
    //         }
    //     }
    // }
    
    struct MyCustomColors: DesignSystemColorProvider {
        let primaryForeground: Color = .white
        let primaryBackground: Color = .black.opacity(0.8)
        let secondaryForeground: Color = .white
        let secondaryBackground: Color = .gray
        let accentForeground: Color = .white
        let accentBackground: Color = .green
    }
    
    // Simulating app-wide color provider setting
    return BaseView(
        background: MyCustomColors().createBackgroundGradient()
    ) {
        ScrollView {
            VStack(spacing: 16) {
                Text("DesignSystem Components:")
                    .font(.title)
                    .padding(.bottom, 8)
                
                // DesignButton examples
                VStack(spacing: 8) {
                    Text("DesignButton")
                        .font(.headline)
                    
                    DesignButton(
                        title: "Primary Button",
                        action: { print("Primary tapped") }
                    )
                    
                    DesignButton(
                        title: "Secondary Button",
                        scheme: .secondary,
                        action: { print("Secondary tapped") }
                    )
                    
                    DesignButton(
                        title: "Accent Button",
                        scheme: .accent,
                        action: { print("Accent tapped") }
                    )
                }
                
                // DesignRow examples
                VStack(spacing: 8) {
                    Text("DesignRow")
                        .font(.headline)
                    
                    DesignRow(title: "Primary Row", action: { print("Tapped!") }) {
                        Image(systemName: "star")
                    }
                    
                    DesignRow(title: "Secondary Row", scheme: .secondary, action: { print("Tapped!") }) {
                        Image(systemName: "heart")
                    }
                    
                    DesignRow(title: "Accent Row", scheme: .accent, action: { print("Tapped!") }) {
                        Image(systemName: "bolt")
                    }
                }
                
                // DesignTextField examples
                VStack(spacing: 8) {
                    Text("DesignTextField")
                        .font(.headline)
                    
                    DesignTextField(
                        placeholder: "Enter your name",
                        text: .constant("")
                    )
                    
                    DesignTextField(
                        placeholder: "Enter your email",
                        text: .constant(""),
                        scheme: .accent
                    )
                }
                
                // DesignCard examples
                VStack(spacing: 8) {
                    Text("DesignCard")
                        .font(.headline)
                    
                    DesignCard(scheme: .primary) {
                        VStack(alignment: .leading) {
                            Text("Primary Card")
                                .font(.headline)
                            Text("This is a primary card with some content.")
                        }
                    }
                    
                    DesignCard(scheme: .accent) {
                        VStack(alignment: .leading) {
                            Text("Accent Card")
                                .font(.headline)
                            Text("This is an accent card with different styling.")
                        }
                    }
                }
                
                // DesignToggle examples
                VStack(spacing: 8) {
                    Text("DesignToggle")
                        .font(.headline)
                    
                    DesignToggle(
                        title: "Primary Toggle",
                        isOn: .constant(true)
                    )
                    
                    DesignToggle(
                        title: "Secondary Toggle",
                        isOn: .constant(false),
                        scheme: .secondary
                    )
                    
                    DesignToggle(
                        title: "Accent Toggle",
                        isOn: .constant(true),
                        scheme: .accent
                    )
                }
                
                // DesignListItem examples
                VStack(spacing: 8) {
                    Text("DesignListItem")
                        .font(.headline)
                    
                    DesignListItem(
                        title: "Primary List Item",
                        subtitle: "With subtitle",
                        leading: { Image(systemName: "star.fill") },
                        trailing: { Text("Detail") },
                        action: { print("Primary item tapped") }
                    )
                    
                    DesignListItem(
                        title: "Secondary List Item",
                        subtitle: "With subtitle",
                        scheme: .secondary,
                        leading: { Image(systemName: "heart.fill") },
                        trailing: { Text("Detail") },
                        action: { print("Secondary item tapped") }
                    )
                    
                    DesignListItem(
                        title: "Accent List Item",
                        subtitle: "With subtitle",
                        scheme: .accent,
                        leading: { Image(systemName: "bolt.fill") },
                        trailing: { Text("Detail") },
                        action: { print("Accent item tapped") }
                    )
                }
                
                // DesignProgressBar examples
                VStack(spacing: 8) {
                    Text("DesignProgressBar")
                        .font(.headline)
                    
                    DesignProgressBar(
                        value: 0.3,
                        title: "Primary Progress",
                        scheme: .primary
                    )
                    
                    DesignProgressBar(
                        value: 0.6,
                        title: "Secondary Progress",
                        scheme: .secondary
                    )
                    
                    DesignProgressBar(
                        value: 0.9,
                        title: "Accent Progress",
                        scheme: .accent
                    )
                }
            }
            .padding()
        }
        .designSystemColorProvider(MyCustomColors()) // Set once, applies to all child views
    }
}

public struct DesignTextField: View {
    let placeholder: String
    @Binding var text: String
    let scheme: DesignScheme
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        placeholder: String,
        text: Binding<String>,
        scheme: DesignScheme = .primary
    ) {
        self.placeholder = placeholder
        self._text = text
        self.scheme = scheme
    }
    
    public var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundColor(schemeColors.colors(for: .primary).foreground)
        )
        .padding()
        .foregroundColor(schemeColors.colors(for: .secondary).foreground)
        .background(schemeColors.colors(for: .secondary).background)
        .cornerRadius(10)
    }
}

// MARK: - DesignCard
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

// MARK: - DesignToggle
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

// MARK: - DesignListItem
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

// MARK: - DesignProgressBar
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
