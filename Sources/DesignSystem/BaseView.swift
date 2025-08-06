import SwiftUI

/// A foundation view that provides background color/gradient and padding for your app's content.
///
/// Use `BaseView` as the root container for your screens. It supports custom backgrounds and safe area handling, and works seamlessly with your design system's color provider.
///
/// - Parameters:
///   - background: An optional background gradient. If not provided, a default is used.
///   - padding: The padding to apply to the content. Defaults to 16.
///   - content: The content to display inside the view.
///   - bottomContent: Optional value for the content you may want pinned to the bottom of the view. This content will sit under the scrollable content within the view, or if there is not sufficient content to fill the view it will be pinned to the bottom.
///
/// Example:
/// ```swift
/// BaseView(background: MyColors().createBackgroundGradient()) {
///     // Your content here
/// }
/// ```
public struct BaseView<Content: View, BottomContent: View>: View {
    let background: LinearGradient?
    let padding: CGFloat
    let content: Content
    let alignment: HorizontalAlignment
    let navigationTitle: String?
    let bottomContent: BottomContent

    @Environment(\.designSchemeColors) private var schemeColors

    public init(
        background: LinearGradient? = nil,
        padding: CGFloat = 16,
        alignment: HorizontalAlignment = .leading,
        navigationTitle: String? = nil,
        @ViewBuilder bottomContent: () -> BottomContent = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.padding = padding
        self.alignment = alignment
        self.navigationTitle = navigationTitle
        self.bottomContent = bottomContent()
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
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: alignment, spacing: padding) {
                        content
                    }
                    .padding(.horizontal, padding)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(maxHeight: .infinity)

                bottomContent
                    .padding(padding)
                    .background(.ultraThinMaterial.opacity(0.5))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(background ?? defaultBackground)
            .foregroundStyle(schemeColors.primary.foreground)
            .navigationTitle(navigationTitle ?? "")
        }
    }
}

#Preview("With Bottom Content") {
    BaseView(
        navigationTitle: "Add Quest",
        bottomContent: {
            DesignButton(title: "Save") {
                print("Save tapped")
            }
        }
    ) {
        VStack(spacing: 24) {
            DesignCard {
                Text("Add your new quest")
            }

            DesignTextField(
                placeholder: "Enter quest name",
                text: .constant("Read 5 pages")
            )
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignCard {
                Text("Add your new quest")
            }
            DesignProgressBar(value: 0.6)
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
