import SwiftUI

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
        primary: DesignSchemeColorPair = .init(foreground: .white, background: .blue),
        secondary: DesignSchemeColorPair = .init(foreground: .black, background: .gray),
        accent: DesignSchemeColorPair = .init(foreground: .white, background: .orange)
    ) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
    }
    public func colors(for scheme: DesignScheme) -> DesignSchemeColorPair {
        switch scheme {
        case .primary: return primary
        case .secondary: return secondary
        case .accent: return accent
        }
    }
}

private struct DesignSchemeKey: EnvironmentKey {
    static let defaultValue = DesignSchemeColors()
}

public extension EnvironmentValues {
    var designSchemeColors: DesignSchemeColors {
        get { self[DesignSchemeKey.self] }
        set { self[DesignSchemeKey.self] = newValue }
    }
}

public extension View {
    func designSchemeColors(_ colors: DesignSchemeColors) -> some View {
        environment(\.designSchemeColors, colors)
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

public struct DesignRow<Content: View>: View {
    let title: String?
    let foregroundColor: Color
    let backgroundColor: Color
    let action: (() -> Void)?
    let content: Content

    public init(
        title: String? = nil,
        foregroundColor: Color = .white,
        backgroundColor: Color = .red,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.action = action
        self.content = content()
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
        .foregroundColor(foregroundColor)
        .padding()
        .background(backgroundColor)
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
    let background: Color
    let padding: CGFloat
    let content: Content
    public init(
        background: Color = .black,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.padding = padding
        self.content = content()
    }
    public var body: some View {
        content
            .padding(padding)
            .background(background)
            .ignoresSafeArea()
    }
}

#Preview {
    BaseView {
        VStack(spacing: 8) {
            DesignRow(title: "Row Title", action: { print("Tapped!") }) {
                Image(systemName: "star")
            }
            DesignRow(
                title: "Row Title",
                action: { print("Tapped!") }
            ) {
                Image(systemName: "star")
            }
            DesignButton(
                title: "Primary Button",
                action: { print("Primary tapped") }
            )
            DesignButton(
                title: "Secondary Button",
                action: { print("Secondary tapped") }
            )
            DesignButton(
                title: "Accent Button",
                action: { print("Accent tapped") }
            )
            DesignButton(
                title: "Scheme Primary",
                action: { print("Scheme Primary tapped") }
            )
            .designScheme(.primary)
            DesignButton(
                title: "Scheme Accent",
                action: { print("Scheme Accent tapped") }
            )
            .designScheme(.accent)
        }
    }
}
