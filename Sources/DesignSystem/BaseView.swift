import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content.
///
/// `BaseView` is intended as the root container for your app's screens. It supports:
/// - A customizable background (provided gradient or design system fallback)
/// - Configurable layout padding and horizontal alignment
/// - A scrollable main content area
/// - An optional `bottomContent` section that is pinned to the bottom of the screen
///
/// The `bottomContent` area is only rendered if explicitly provided.
/// If omitted, the layout has no reserved space or background at the bottom,
/// ensuring optimal performance and avoiding unnecessary rendering.
///
/// **Behavior:**
/// - When the main content is shorter than the screen, `bottomContent` stays pinned to the bottom.
/// - When the main content overflows, both the main content and `bottomContent` scroll together (future refinements may support fixed positioning during scroll).
///
/// - Parameters:
///   - navigationTitle: An optional title for the navigation bar.
///   - content: The main body content of the screen.
///   - bottomContent: An optional trailing view pinned to the bottom. Omit to remove the bottom bar entirely.
///   - alignment: Horizontal alignment of the main content. Defaults to `.leading`.
///   - background: An optional background gradient. If not provided, a default from the design scheme is used.
///   - padding: Padding around the main content. Defaults to `16`.
///
/// **Example (basic):**
/// ```swift
/// BaseView(navigationTitle: "Profile") {
///     DesignTextField(placeholder: "Name", text: $name)
/// }
/// ```
///
/// **Example (with bottom action button):**
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
    private let background: LinearGradient?
    private let padding: CGFloat
    private let content: Content
    private let alignment: HorizontalAlignment
    private let navigationTitle: String?
    private let bottomContent: BottomContent

    @Environment(\.designSchemeColors) private var schemeColors

    public init(
        navigationTitle: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder bottomContent: () -> BottomContent,
        alignment: HorizontalAlignment = .leading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
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

                bottomArea()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(background ?? defaultBackground)
            .foregroundStyle(schemeColors.primary.foreground)
            .navigationTitle(navigationTitle ?? "")
        }
    }
}

// MARK: - Compile-time specialization for the bottom area

private extension BaseView {
    func bottomArea() -> some View {
        HStack {
            bottomContent
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(padding)
        .background(.ultraThinMaterial.opacity(0.5))
    }
}

private extension BaseView where BottomContent == EmptyView {
    func bottomArea() -> some View {
        EmptyView()
    }
}

// MARK: - Convenience init when omitting bottom content

public extension BaseView where BottomContent == EmptyView {
    init(
        navigationTitle: String? = nil,
        @ViewBuilder content: () -> Content,
        alignment: HorizontalAlignment = .leading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            content: content,
            bottomContent: { EmptyView() },
            alignment: alignment,
            background: background,
            padding: padding
        )
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
