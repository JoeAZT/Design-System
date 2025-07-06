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

#Preview {
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
                    scheme: .accent
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
            .padding()
        }
        .designSystemColorProvider(MyCustomColors()) // Set once, applies to all child views
    }
}
