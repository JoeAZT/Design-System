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