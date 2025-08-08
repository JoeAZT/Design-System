import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content.
///
/// `BaseView` is intended as the root container for your app's screens. It supports:
/// - A customizable background (provided gradient or design system fallback)
/// - Configurable layout padding and horizontal alignment
/// - A scrollable main content area
///
/// - Parameters:
///   - navigationTitle: Optional title for the navigation bar.
///   - content: The main body content of the screen.
///   - alignment: Horizontal alignment of the main content. Defaults to `.leading`.
///   - background: Optional background gradient. If not provided, a default from the design scheme is used.
///   - padding: Horizontal padding around the main content. Defaults to `16`.
///
public struct BaseView<Content: View>: View {
    private let background: LinearGradient?
    private let padding: CGFloat
    private let content: Content
    private let alignment: HorizontalAlignment
    private let navigationTitle: String?

    @Environment(\.designSchemeColors) private var schemeColors

    public init(
        navigationTitle: String? = nil,
        @ViewBuilder content: () -> Content,
        alignment: HorizontalAlignment = .leading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.background = background
        self.padding = padding
        self.alignment = alignment
        self.navigationTitle = navigationTitle
        self.content = content()
    }

    private var defaultBackground: LinearGradient {
        LinearGradient(
            colors: Array(repeating: schemeColors.background.foreground, count: 6) + [schemeColors.background.background],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: alignment, spacing: padding) {
                    content
                }
                .padding(.horizontal, padding)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: .infinity) // keep content pinned to top when short
            .background(background ?? defaultBackground)
            .foregroundStyle(schemeColors.primary.foreground)
            .navigationTitle(navigationTitle ?? "")
        }
    }
}

#Preview("Without Bottom Content") {
    BaseView(navigationTitle: "Progress Overview") {
        VStack(spacing: 24) {
            DesignCard {
                Text("Progress")
                DesignProgressBar(value: 0.5)
            }
            DesignTextField(
                placeholder: "Notes",
                text: .constant("Some notes here")
            )
        }
    }
}
