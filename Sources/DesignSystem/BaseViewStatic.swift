import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content, with optional leading/trailing toolbar items
/// and flexible alignment, presented without a `ScrollView`.
///
/// This static version of `BaseView` is suitable for content that does not require vertical
/// scrolling, such as fixed-size views or screens where content size is predictable
/// and fits within the display area.
///
/// ### Parameters
/// - `navigationTitle`: Optional navigation bar title.
/// - `position`: Controls both the container alignment (`frameAlignment`) and the internal
///   `VStack` alignment. Defaults to `.topLeading`.
/// - `background`: Optional custom background gradient (defaults to design system background).
/// - `padding`: Horizontal padding between content and screen edges (defaults to 16).
/// - `leadingToolbar`: Optional leading toolbar view.
/// - `trailingToolbar`: Optional trailing toolbar view.
/// - `content`: The main screen content.
///
/// ### ContentPosition
/// Use the `ContentPosition` enum to set where content is placed inside the view:
/// - `.topLeading` (default) → frame aligned topLeading, stack alignment leading
/// - `.topCenter` → frame top, stack center
/// - `.topTrailing` → frame topTrailing, stack trailing
/// - `.centerLeading` → frame leading, stack leading
/// - `.center` → frame center, stack center
/// - `.centerTrailing` → frame trailing, stack trailing
/// - `.bottomLeading` → frame bottomLeading, stack leading
/// - `.bottomCenter` → frame bottom, stack center
/// - `.bottomTrailing` → frame bottomTrailing, stack trailing
///
/// ### Usage Examples
/// - Basic static view:
/// ```swift
/// BaseViewStatic(navigationTitle: "Welcome") {
///     Text("This content does not scroll.")
/// }
/// ```
///
/// - Static view with toolbars:
/// ```swift
/// BaseViewStatic(
///     navigationTitle: "Settings",
///     leadingToolbar: { Button("Cancel"){} },
///     trailingToolbar: { Button("Save"){} }
/// ) {
///     Text("User settings form.")
/// }
/// ```
///
/// - Custom alignment in a static view:
/// ```swift
/// BaseViewStatic(
///     navigationTitle: "Centered Content",
///     position: .center
/// ) {
///     Text("This block is centered and static.")
/// }
/// ```
// MARK: - BaseViewStatic

public struct BaseViewStatic<Content: View, Leading: View, Trailing: View>: View {
    private let background: LinearGradient?
    private let position: ContentPosition
    private let padding: CGFloat
    private let content: Content
    private let navigationTitle: String?
    private let leadingToolbar: Leading
    private let trailingToolbar: Trailing

    @Environment(\.designSchemeColors) private var schemeColors

    private var defaultBackground: LinearGradient {
        LinearGradient(
            colors: Array(repeating: schemeColors.background.foreground, count: 6) + [schemeColors.background.background],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }

    public init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.position = position
        self.background = background
        self.padding = padding
        self.navigationTitle = navigationTitle
        self.content = content()
        self.leadingToolbar = leadingToolbar()
        self.trailingToolbar = trailingToolbar()
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: position.stackAlignment, spacing: padding) { // uses enum
                content
            }
            .padding(.horizontal, padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: position.frameAlignment) // uses enum
            .background(background ?? defaultBackground)
            .foregroundStyle(schemeColors.primary.foreground)
            .navigationTitle(navigationTitle ?? "")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { leadingToolbar }
                ToolbarItem(placement: .topBarTrailing) { trailingToolbar }
            }
        }
    }
}

// MARK: - Convenience initialisers

public extension BaseViewStatic where Leading == EmptyView, Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: { EmptyView() },
            background: background,
            padding: padding
        )
    }
}

public extension BaseViewStatic where Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: { EmptyView() },
            background: background,
            padding: padding
        )
    }
}

public extension BaseViewStatic where Leading == EmptyView {
    init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: trailingToolbar,
            background: background,
            padding: padding
        )
    }
}

public extension BaseViewStatic {
    init(
        navigationTitle: String? = nil,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        position: ContentPosition = .topLeading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background,
            padding: padding
        )
    }
}
