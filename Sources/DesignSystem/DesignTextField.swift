import SwiftUI

/// A theme-aware text field for user input, styled according to your design system.
///
/// Use `DesignTextField` for text input fields that automatically match your app's color scheme. The placeholder uses the primary foreground color, while the text and background use the selected scheme.
///
/// - Parameters:
///   - placeholder: The placeholder text to display when the field is empty.
///   - text: A binding to the text value.
///   - scheme: The color scheme to use for the text field. If not provided, the field will use the propagated scheme from the environment (see below).
///
/// ### Color Scheme Propagation
/// If you nest a `DesignTextField` inside a container (such as `DesignCard`), the text field will automatically use the next color scheme in the sequence unless you explicitly set the `scheme` parameter. This enables consistent, visually distinct UIs with minimal configuration.
///
/// Example:
/// ```swift
/// DesignCard(scheme: .primary) {
///     DesignTextField(placeholder: "Email", text: $email) // uses .secondary by default
///     DesignTextField(placeholder: "Email", text: $email, scheme: .primary) // uses .primary explicitly
/// }
/// ```
public struct DesignTextField: View {
    let placeholder: String
    @Binding var text: String
    let scheme: DesignScheme?
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    public init(
        placeholder: String,
        text: Binding<String>,
        scheme: DesignScheme? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.scheme = scheme
    }
    
    private var colorPair: DesignSchemeColorPair {
        schemeColors.colors(for: resolvedScheme)
    }
    
    private var resolvedScheme: DesignScheme {
        scheme ?? defaultChildScheme
    }
    
    public var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
            .foregroundColor(colorPair.foreground)
        )
        .padding()
        .foregroundColor(colorPair.foreground)
        .background(colorPair.background)
        .cornerRadius(10)
    }
} 

#Preview {
    VStack {
        DesignTextField(
            placeholder: "Enter your name",
            text: .constant(""),
            scheme: .primary
        )
        DesignTextField(
            placeholder: "Enter your name",
            text: .constant(""),
            scheme: .secondary
        )
        DesignTextField(
            placeholder: "Enter your name",
            text: .constant(""),
            scheme: .accent
        )
    }
}
