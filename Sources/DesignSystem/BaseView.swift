import SwiftUI

// MARK: - BaseView

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content, with optional leading/trailing toolbar items
/// and flexible alignment.
///
/// ### Parameters
/// - `navigationTitle`: Optional navigation bar title.
/// - `position`: Controls both the container alignment (`frameAlignment`) and the internal
///   `VStack` alignment. Defaults to `.topLeading`.
/// - `background`: Optional custom background **`ShapeStyle`** (Color, Linear/Radial/AngularGradient, Material, etc.).
/// - `backgroundPreset`: Optional design-system preset (e.g. `.extremeTopTrailing`) that resolves to a radial gradient.
/// - `padding`: Horizontal padding between content and screen edges (defaults to 16).
/// - `leadingToolbar`: Optional leading toolbar view.
/// - `trailingToolbar`: Optional trailing toolbar view.
/// - `content`: The main screen content.
///
/// ### Background Resolution
/// 1. If `background` is provided, it is used.
/// 2. Else if `backgroundPreset` is provided, it is built from the design scheme.
/// 3. Else the default DS linear gradient is used.

import SwiftUI

public struct BaseView<Content: View, Leading: View, Trailing: View>: View {
    // Background
    private let background: AnyShapeStyle?
    private let backgroundPreset: DesignBackgroundPreset?

    // Layout
    private let position: ContentPosition
    private let padding: CGFloat

    // Content / chrome
    private let content: Content
    private let navigationTitle: String?
    private let leadingToolbar: Leading
    private let trailingToolbar: Trailing

    @Environment(\.designSchemeColors) private var schemeColors

    private var defaultBackground: AnyShapeStyle {
        // ✅ Unified with designDefaultBackground()
        DesignBackgroundPreset.defaultStyle(using: schemeColors)
    }

    // MARK: Designated Initialiser (type-erased background)

    public init(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        background: AnyShapeStyle? = nil,
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.position = position
        self.background = background
        self.backgroundPreset = backgroundPreset
        self.padding = padding
        self.navigationTitle = navigationTitle
        self.content = content()
        self.leadingToolbar = leadingToolbar()
        self.trailingToolbar = trailingToolbar()
    }

    public var body: some View {
        let resolvedBackground: AnyShapeStyle =
            background
            ?? backgroundPreset?.makeStyle(using: schemeColors)
            ?? defaultBackground

        NavigationStack {
            ScrollView {
                VStack(alignment: position.stackAlignment, spacing: padding) {
                    content
                }
                .padding(.horizontal, padding)
                .frame(maxWidth: .infinity, alignment: position.frameAlignment)
            }
            .background(resolvedBackground)
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
        background: AnyShapeStyle? = nil,
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: { EmptyView() },
            background: background,
            backgroundPreset: backgroundPreset,
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
        background: AnyShapeStyle? = nil,
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: { EmptyView() },
            background: background,
            backgroundPreset: backgroundPreset,
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
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: trailingToolbar,
            background: background,
            backgroundPreset: backgroundPreset,
            padding: padding
        )
    }
}

// MARK: - Ultra-ergonomic overloads to pass any ShapeStyle directly

public extension BaseView {
    init<S: ShapeStyle>(
        navigationTitle: String? = nil,
        position: ContentPosition = .topLeading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        background: S?,
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            backgroundPreset: backgroundPreset,
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
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: { EmptyView() },
            background: background.map(AnyShapeStyle.init),
            backgroundPreset: backgroundPreset,
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
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: { EmptyView() },
            background: background.map(AnyShapeStyle.init),
            backgroundPreset: backgroundPreset,
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
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            backgroundPreset: backgroundPreset,
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
        backgroundPreset: DesignBackgroundPreset? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            position: position,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background.map(AnyShapeStyle.init),
            backgroundPreset: backgroundPreset,
            padding: padding
        )
    }
}
