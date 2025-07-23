import SwiftUI

/// A foundation view that provides background color/gradient and padding for your app's content.
///
/// Use `BaseView` as the root container for your screens. It supports custom backgrounds and safe area handling, and works seamlessly with your design system's color provider.
///
/// - Parameters:
///   - background: An optional background gradient. If not provided, a default is used.
///   - padding: The padding to apply to the content. Defaults to 16.
///   - content: The content to display inside the view.
///
/// Example:
/// ```swift
/// BaseView(background: MyColors().createBackgroundGradient()) {
///     // Your content here
/// }
/// ```
public struct BaseView<Content: View>: View {
    let background: LinearGradient?
    let padding: CGFloat
    let content: Content
    let alignment: HorizontalAlignment
    let navigationTitle: String?
    @Environment(\.designSchemeColors) private var schemeColors
    
    public init(
        background: LinearGradient? = nil,
        padding: CGFloat = 16,
        alignment: HorizontalAlignment = .leading,
        navigationTitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.padding = padding
        self.alignment = alignment
        self.navigationTitle = navigationTitle
        self.content = content()
    }
    
    private var defaultBackground: LinearGradient {
        LinearGradient(
            colors: [
                schemeColors.background.background,
                schemeColors.background.background,
                schemeColors.background.background,
                schemeColors.background.background,
                schemeColors.background.foreground
            ],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: alignment) {
                    content
                }
            }
            .foregroundStyle(schemeColors.primary.foreground)
            .background(background ?? defaultBackground)
        }
    }
}

#Preview {
    BaseView(navigationTitle: "Base view title") {
        Text("some preview value here")
        Text("some preview value here")
        Text("some preview value here")
        Text("some preview value here")
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
        DesignCard {
            Text("Progress")
            DesignProgressBar(value: 0.5)
        }
    }
}
