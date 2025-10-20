import SwiftUI

/// A theme-aware text field for user input, styled according to your design system.
/// Supports an optional heading and optional leading/trailing adornments (e.g. "£", "%").
///
/// - Parameters:
///   - placeholder: Placeholder text shown when the field is empty.
///   - text: Binding to the field’s text.
///   - heading: Optional text rendered **above** the input (e.g. “Amount”).
///   - scheme: Optional color scheme override; otherwise inherits from the environment.
///   - leadingSymbol: Optional text shown **before** the input (e.g. "£").
///   - trailingSymbol: Optional text shown **after** the input (e.g. "%").
///   - keyboard: Optional keyboard type. If not provided and an adornment exists,
///               the keyboard defaults to `.decimalPad`, otherwise `.default`.
public struct DesignTextField: View {
    let placeholder: String
    @Binding var text: String
    let heading: String?
    let scheme: DesignScheme?
    let leadingSymbol: String?
    let trailingSymbol: String?
    let keyboard: UIKeyboardType?
    let noBackground: Bool?
        
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme

    public init(
        placeholder: String,
        text: Binding<String>,
        heading: String? = nil,
        scheme: DesignScheme? = nil,
        leadingSymbol: String? = nil,
        trailingSymbol: String? = nil,
        keyboard: UIKeyboardType? = nil,
        noBackground: Bool? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.heading = heading
        self.scheme = scheme
        self.leadingSymbol = leadingSymbol
        self.trailingSymbol = trailingSymbol
        self.keyboard = keyboard
        self.noBackground = noBackground
    }

    private var colorPair: DesignSchemeColorPair { schemeColors.colors(for: resolvedScheme) }
    private var resolvedScheme: DesignScheme { scheme ?? defaultChildScheme }
    private var hasAdornment: Bool { leadingSymbol != nil || trailingSymbol != nil }
    private var resolvedKeyboard: UIKeyboardType {
        keyboard ?? (hasAdornment ? .decimalPad : .default)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let heading {
                Text(heading)
                    .font(.subheadline)
                    .foregroundColor(colorPair.foreground)
                    .accessibilityAddTraits(.isStaticText)
            }

            HStack(spacing: 8) {
                if let leading = leadingSymbol {
                    Text(leading)
                        .foregroundColor(colorPair.foreground)
                        .accessibilityHidden(true)
                        .frame(minWidth: 12, alignment: .leading)
                }

                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder).foregroundColor(colorPair.foreground)
                )
                .keyboardType(resolvedKeyboard)
                .foregroundColor(colorPair.foreground)

                if let trailing = trailingSymbol {
                    Text(trailing)
                        .foregroundColor(colorPair.foreground)
                        .accessibilityHidden(true)
                        .frame(minWidth: 12, alignment: .trailing)
                }
            }
        }
        .designFieldBackground(colorPair, enabled: !(noBackground ?? false))
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
            placeholder: "100.00",
            text: .constant(""),
            scheme: .secondary,
            leadingSymbol: "£"
        )
        DesignTextField(
            placeholder: "1.47",
            text: .constant(""),
            heading: "Interest rate",
            scheme: .accent,
            trailingSymbol: "%"
        )
        DesignTextField(
            placeholder: "1.47",
            text: .constant(""),
            heading: "Interest rate",
            scheme: .accent,
            trailingSymbol: "%",
            noBackground: false
        )
        DesignTextField(
            placeholder: "1.47",
            text: .constant(""),
            heading: "Interest rate",
            scheme: .accent,
            trailingSymbol: "%",
            noBackground: true
        )
    }
    .padding()
    .background(.red)
    .padding()
}
