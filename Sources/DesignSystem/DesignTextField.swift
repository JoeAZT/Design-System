import SwiftUI

/// A theme-aware text field for user input, styled according to your design system.
/// Supports optional leading/trailing adornments (e.g. "£", "%").
///
/// - Parameters:
///   - placeholder: The placeholder text to display when the field is empty.
///   - text: A binding to the text value.
///   - scheme: Optional color scheme override; otherwise inherits from the environment.
///   - leadingSymbol: Optional text shown before the input (e.g. "£").
///   - trailingSymbol: Optional text shown after the input (e.g. "%").
///   - keyboard: Optional keyboard type (defaults to `.decimalPad` when a symbol is provided, else `.default`).
public struct DesignTextField: View {
    let placeholder: String
    @Binding var text: String
    let scheme: DesignScheme?
    let leadingSymbol: String?
    let trailingSymbol: String?
    let keyboard: UIKeyboardType?

    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme

    public init(
        placeholder: String,
        text: Binding<String>,
        scheme: DesignScheme? = nil,
        leadingSymbol: String? = nil,
        trailingSymbol: String? = nil,
        keyboard: UIKeyboardType? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.scheme = scheme
        self.leadingSymbol = leadingSymbol
        self.trailingSymbol = trailingSymbol
        self.keyboard = keyboard
    }

    private var colorPair: DesignSchemeColorPair { schemeColors.colors(for: resolvedScheme) }
    private var resolvedScheme: DesignScheme { scheme ?? defaultChildScheme }
    private var resolvedKeyboard: UIKeyboardType {
        if let keyboard { return keyboard }
        return (leadingSymbol != nil || trailingSymbol != nil) ? .decimalPad : .default
    }

    public var body: some View {
        HStack(spacing: 8) {
            if let leading = leadingSymbol {
                Text(leading)
                    .foregroundColor(colorPair.foreground)
                    .accessibilityHidden(true)
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
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
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
            placeholder: "100.00",
            text: .constant(""),
            scheme: .secondary,
            leadingSymbol: "£",
            keyboard: .decimalPad
        )
        DesignTextField(
            placeholder: "1.47",
            text: .constant(""),
            scheme: .secondary,
            leadingSymbol: "   ",
            trailingSymbol: "%",
            keyboard: .decimalPad
        )
    }
}
