import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for your screen content.
///
/// `BaseView` is intended as the root view for your app's screens. It includes:
/// - A customizable background (gradient or fallback)
/// - Layout padding and alignment
/// - A scrollable main content area
/// - Optional `bottomContent` that is pinned to the bottom of the screen
///
/// `bottomContent` will remain fixed to the bottom of the screen when the content does not fill the available space,
/// and will scroll off-screen if the main content exceeds the screen height (WIP).
///
/// - Parameters:
///   - background: An optional background gradient. If not provided, a default is used from the design scheme.
///   - padding: The padding applied around the main content. Defaults to 16.
///   - alignment: The horizontal alignment of the content. Defaults to `.leading`.
///   - navigationTitle: An optional navigation title to show in the navigation bar.
///   - bottomContent: An optional trailing view that is pinned to the bottom of the screen. It remains visible below the scroll view unless content overflows.
///   - content: The main body content of the screen.
///
/// Example (basic):
/// ```swift
/// BaseView {
///     DesignTextField(placeholder: "Name", text: $name)
/// }
/// ```
///
/// Example (with pinned button):
/// ```swift
/// BaseView(
///     navigationTitle: "Create Quest",
///     bottomContent: {
///         DesignButton(title: "Save") { viewModel.save() }
///     }
/// ) {
///     DesignCard {
///         Text("Add a new quest")
///         DesignTextField(placeholder: "Title", text: $title)
///     }
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
        navigationTitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomContent: () -> BottomContent = { EmptyView() },
        alignment: HorizontalAlignment = .leading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16,
    ) {
        self.background = background
        self.padding = padding
        self.alignment = alignment
        self.navigationTitle = navigationTitle
        self.content = content()
        self.bottomContent = bottomContent()
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
                
                HStack {
                    bottomContent
                        .frame(maxWidth: .infinity, alignment: .center)
                }
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
        navigationTitle: "With bottom content",
        content: {
            Text("Main Content")
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
        },
        bottomContent: {
            DesignButton(
                title: "Bottom content"
            )
        }
    )
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
