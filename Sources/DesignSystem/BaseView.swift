import SwiftUI

import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content, with optional leading/trailing toolbar items
/// and flexible alignment.
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
/// - No toolbars:
/// ```swift
/// BaseView(navigationTitle: "Overview") {
///     Text("Hello")
/// }
/// ```
///
/// - Only leading toolbar:
/// ```swift
/// BaseView(
///     navigationTitle: "Detail",
///     leadingToolbar: { Button("Close"){} }
/// ) {
///     Text("Screen content")
/// }
/// ```
///
/// - Only trailing toolbar:
/// ```swift
/// BaseView(
///     navigationTitle: "Edit",
///     trailingToolbar: { Button("Save"){} }
/// ) {
///     Text("Screen content")
/// }
/// ```
///
/// - Both toolbars:
/// ```swift
/// BaseView(
///     navigationTitle: "Item",
///     leadingToolbar: { Button("Back"){} },
///     trailingToolbar: { Button("Done"){} }
/// ) {
///     Text("Screen content")
/// }
/// ```
///
/// - Custom alignment:
/// ```swift
/// BaseView(
///     navigationTitle: "Centered",
///     position: .center
/// ) {
///     Text("Centered block")
/// }
/// ```
// MARK: - BaseView

public struct BaseView<Content: View, Leading: View, Trailing: View>: View {
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
            ScrollView {
                VStack(alignment: position.stackAlignment, spacing: padding) { // uses enum
                    content
                }
                .padding(.horizontal, padding)
                .frame(maxWidth: .infinity, alignment: position.frameAlignment) // uses enum
            }
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

public extension BaseView where Leading == EmptyView, Trailing == EmptyView {
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

public extension BaseView where Trailing == EmptyView {
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

public extension BaseView where Leading == EmptyView {
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

public extension BaseView {
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
