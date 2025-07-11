/**
 # DesignSystem
 
 A SwiftUI-first design system library for iOS, providing a set of customizable, theme-aware UI components.
 
 ## Features
 - Consistent color schemes and theming via a color provider protocol
 - App-wide color configuration with environment propagation
 - Ready-to-use, accessible components: Button, Row, Card, Toggle, ListItem, ProgressBar, TextField, and more
 - Easy integration: just `import DesignSystem` in your app
 - Modern SwiftUI patterns and best practices
 
 ## Usage
 1. Define your color palette by conforming to `DesignSystemColorProvider`.
 2. Set your color provider at the app or root view level using `.designSystemColorProvider(...)`.
 3. Use any DesignSystem component in your views. All components will automatically use your color scheme.
 
 ## Example
 ```swift
 import DesignSystem
 
 struct MyColors: DesignSystemColorProvider { ... }
 
 @main
 struct MyApp: App {
 var body: some Scene {
 WindowGroup {
 ContentView()
 .designSystemColorProvider(MyColors())
 }
 }
 }
 ```
 
 ## Components
 - `DesignButton`
 - `DesignRow`
 - `DesignTextField`
 - `DesignCard`
 - `DesignToggle`
 - `DesignListItem`
 - `DesignProgressBar`
 - `BaseView`
 
 All components are public and available with a single `import DesignSystem`.
 */
import SwiftUI

/// A protocol for providing color values to the design system.
///
/// Conform to this protocol to define your app's color palette. All DesignSystem components will use these colors.
public protocol DesignSystemColorProvider: Sendable {
    /// The main background color for your app.
    var backgroundColor: Color { get }
    /// A variant background color for subtle backgrounds.
    var backgroundVariantColor: Color { get }
    /// The foreground color for primary elements.
    var primaryForeground: Color { get }
    /// The background color for primary elements.
    var primaryBackground: Color { get }
    /// The foreground color for secondary elements.
    var secondaryForeground: Color { get }
    /// The background color for secondary elements.
    var secondaryBackground: Color { get }
    /// The foreground color for accent elements.
    var accentForeground: Color { get }
    /// The background color for accent elements.
    var accentBackground: Color { get }
}

/// The default color provider used if no custom provider is set.
public struct DefaultDesignSystemColors: DesignSystemColorProvider {
    public var backgroundColor: Color = .black
    public var backgroundVariantColor: Color = .black.opacity(0.90)
    public let primaryForeground: Color = .white
    public let primaryBackground: Color = .gray
    public let secondaryForeground: Color = .white
    public let secondaryBackground: Color = .blue
    public let accentForeground: Color = .white
    public let accentBackground: Color = .teal
    
    public init() {}
}

/// The available color schemes for the design system.
public enum DesignScheme: Sendable {
    /// The primary color scheme (default for most components).
    case primary
    /// The secondary color scheme (for alternative emphasis).
    case secondary
    /// The accent color scheme (for highlights and important actions).
    case accent
    
    /// Returns the next scheme in the sequence: primary -> secondary -> primary, accent -> primary
    public var next: DesignScheme {
        switch self {
        case .primary: return .secondary
        case .secondary: return .primary
        case .accent: return .primary
        }
    }
}

/// A pair of foreground and background colors for a scheme.
public struct DesignSchemeColorPair: Sendable {
    /// The foreground color.
    public let foreground: Color
    /// The background color.
    public let background: Color
    public init(foreground: Color, background: Color) {
        self.foreground = foreground
        self.background = background
    }
}

/// A collection of color pairs for all supported schemes.
public struct DesignSchemeColors: Sendable {
    /// The background color pair.
    public let background: DesignSchemeColorPair
    /// The primary color pair.
    public let primary: DesignSchemeColorPair
    /// The secondary color pair.
    public let secondary: DesignSchemeColorPair
    /// The accent color pair.
    public let accent: DesignSchemeColorPair
    
    public init(
        background: DesignSchemeColorPair = .init(foreground: .white, background: .black),
        primary: DesignSchemeColorPair = .init(foreground: .white, background: .black),
        secondary: DesignSchemeColorPair = .init(foreground: .white, background: .red),
        accent: DesignSchemeColorPair = .init(foreground: .white, background: .green)
    ) {
        self.background = background
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
    }
    
    /// Creates a new set of scheme colors from a color provider.
    public init(from provider: DesignSystemColorProvider) {
        self.background = DesignSchemeColorPair(
            foreground: provider.backgroundColor,
            background: provider.backgroundVariantColor
        )
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
    
    /// Returns the color pair for a given scheme.
    public func colors(for scheme: DesignScheme) -> DesignSchemeColorPair {
        switch scheme {
        case .primary: return primary
        case .secondary: return secondary
        case .accent: return accent
        }
    }
}

// MARK: - Environment Keys
private struct ColorProviderKey: EnvironmentKey {
    static let defaultValue: DesignSystemColorProvider = DefaultDesignSystemColors()
}

private struct DefaultChildSchemeKey: EnvironmentKey {
    static let defaultValue: DesignScheme = .primary
}

public extension EnvironmentValues {
    var designSystemColorProvider: DesignSystemColorProvider {
        get { self[ColorProviderKey.self] }
        set { self[ColorProviderKey.self] = newValue }
    }
    
    var designSchemeColors: DesignSchemeColors {
        DesignSchemeColors(from: designSystemColorProvider)
    }
    
    /// The default color scheme for child components, used for automatic scheme propagation.
    var designSystemDefaultChildScheme: DesignScheme {
        get { self[DefaultChildSchemeKey.self] }
        set { self[DefaultChildSchemeKey.self] = newValue }
    }
}

// MARK: - View Extensions
public extension View {
    func designSystemColorProvider(_ provider: DesignSystemColorProvider) -> some View {
        environment(\.designSystemColorProvider, provider)
    }
}

#Preview {
    /**
     Demonstrates how to use custom colors in previews.
     
     Usage:
     - Define a struct conforming to DesignSystemColorProvider.
     - Apply .designSystemColorProvider(MyCustomColors()) to your preview root view.
     - All DesignSystem components in the preview will use your custom colors.
     
     Example:
     ```swift
     struct MyCustomColors: DesignSystemColorProvider {
     var backgroundColor: Color = .black
     var backgroundVariantColor: Color = .green
     let primaryForeground: Color = .white
     let primaryBackground: Color = .white.opacity(0.25)
     let secondaryForeground: Color = .white
     let secondaryBackground: Color = .white.opacity(0.5)
     let accentForeground: Color = .white
     let accentBackground: Color = .green
     }
     
     #Preview {
     BaseView {
     // ...
     }
     .designSystemColorProvider(MyCustomColors())
     }
     ```
     */
    struct MyCustomColors: DesignSystemColorProvider {
        var backgroundColor: Color = .black
        var backgroundVariantColor: Color = .green
        let primaryForeground: Color = .white
        let primaryBackground: Color = .red
        let secondaryForeground: Color = .white
        let secondaryBackground: Color = .blue
        let accentForeground: Color = .white
        let accentBackground: Color = .green
    }
    
    return BaseView {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("DesignSystem Components:")
                    .font(.title)
                    .padding(.bottom, 8)
                
                // DesignButton examples
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
                
                // DesignRow examples
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
                
                // DesignTextField examples
                Text("DesignTextField")
                    .font(.headline)
                
                DesignTextField(
                    placeholder: "Enter your name",
                    text: .constant("")
                )
                
                DesignTextField(
                    placeholder: "Enter your email",
                    text: .constant(""),
                    scheme: .secondary
                )
                
                // DesignCard examples
                Text("DesignCard")
                    .font(.headline)
                
                DesignCard(scheme: .primary) {
                    VStack(alignment: .leading) {
                        Text("Primary Card")
                            .font(.headline)
                        Text("This is a primary card with some content.")
                    }
                }
                
                DesignCard(scheme: .secondary) {
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
                
                // DesignToggle examples
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
                
                // DesignListItem examples
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
                
                // DesignProgressBar examples
                Text("DesignProgressBar")
                    .font(.headline)
                
                DesignCard(title: "Progress bars") {
                    DesignProgressBar(
                        value: 0.3,
                        title: "Primary Progress"
                    )
                    
                    DesignProgressBar(
                        value: 0.6,
                        title: "Secondary Progress",
                        fontSize: .large
                    )
                    DesignButton(title: "what colour am I?") {
                        print("button tapped")
                    }
                    DesignCard(scheme: .secondary) {
                        DesignProgressBar(
                            value: 0.9,
                            title: "Accent Progress",
                            fontSize: .small
                        )
                        DesignToggle(title: "toggle title", isOn: .constant(true))
                        DesignCard(scheme: .accent) {
                            DesignProgressBar(
                                value: 0.9,
                                title: "Accent Progress",
                                fontSize: .small
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .designSystemColorProvider(MyCustomColors())
    }
}
