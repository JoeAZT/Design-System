import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content, with optional leading/trailing toolbar items
/// and flexible alignment.
///
/// ### Parameters
/// - `navigationTitle`: Optional navigation bar title.
/// - `position`: Controls both the container alignment (`frameAlignment`) and the internal
///   `VStack` alignment. Defaults to `.topLeading`.
/// - `background`: Optional custom background **`ShapeStyle`** (Color, Linear/Radial/AngularGradient, Material, etc.).
///   Defaults to a design system gradient.
/// - `padding`: Horizontal padding between content and screen edges (defaults to 16).
/// - `leadingToolbar`: Optional leading toolbar view.
/// - `trailingToolbar`: Optional trailing toolbar view.
/// - `content`: The main screen content.
public struct BaseView<Content: View, Leading: View, Trailing: View>: View {
    private let background: AnyShapeStyle?
    private let position: ContentPosition
    private let padding: CGFloat
    private let content: Content
    private let navigationTitle: String?
    private let leadingToolbar: Leading
    private let trailingToolbar: Trailing

    @Environment(\.designSchemeColors) private var schemeColors

    private var defaultBackground: AnyShapeStyle {
        AnyShapeStyle(
            LinearGradient(
                colors: Array(repeating: schemeColors.background.foreground, count: 6) + [schemeColors.background.background],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        )
    }

    // Designated initialiser (type-erased background)
    public init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        background: AnyShapeStyle? = nil,
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
                VStack(alignment: position.stackAlignment, spacing: padding) {
                    content
                }
                .padding(.horizontal, padding)
                .frame(maxWidth: .infinity, alignment: position.frameAlignment)
            }
            // Accepts any ShapeStyle
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

// MARK: - Convenience initialisers (no toolbars)

public extension BaseView where Leading == EmptyView, Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        background: AnyShapeStyle? = nil,
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

// MARK: - Convenience initialisers (single toolbar)

public extension BaseView where Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder content: () -> Content,
        background: AnyShapeStyle? = nil,
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
        background: AnyShapeStyle? = nil,
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

// MARK: - Argument order variant
public extension BaseView {
    init(
        navigationTitle: String? = nil,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        position: ContentPosition = .topLeading,
        background: AnyShapeStyle? = nil,
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

// MARK: - Ultra-ergonomic overloads to pass any ShapeStyle directly
// These let callers pass Color/Gradient/Material without wrapping in AnyShapeStyle.

public extension BaseView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        background: S?,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            padding: padding
        )
    }
}

public extension BaseView where Leading == EmptyView, Trailing == EmptyView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        background: S?,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: { EmptyView() },
            background: background.map(AnyShapeStyle.init),
            padding: padding
        )
    }
}

public extension BaseView where Trailing == EmptyView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder content: () -> Content,
        background: S?,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: { EmptyView() },
            background: background.map(AnyShapeStyle.init),
            padding: padding
        )
    }
}

public extension BaseView where Leading == EmptyView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        background: S?,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            padding: padding
        )
    }
}

public extension BaseView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        position: ContentPosition = .topLeading,
        background: S?,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            padding: padding
        )
    }
}
