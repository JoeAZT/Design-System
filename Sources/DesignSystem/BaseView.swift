import SwiftUI

/// A foundational container view that provides consistent background styling, padding,
/// and structured layout for screen content, with optional leading/trailing toolbar items.
///
/// Usage:
/// - No toolbars:
///   BaseView(navigationTitle: "Title") { /* content */ }
///
/// - Only leading toolbar:
///   BaseView(navigationTitle: "Title", leadingToolbar: { Button("Close"){} }) { /* content */ }
///
/// - Only trailing toolbar:
///   BaseView(navigationTitle: "Title", trailingToolbar: { Button("Save"){} }) { /* content */ }
///
/// - Both toolbars:
///   BaseView(navigationTitle: "Title",
///            leadingToolbar: { Button("Back"){} },
///            trailingToolbar: { Button("Done"){} }) { /* content */ }
public struct BaseView<Content: View, Leading: View, Trailing: View>: View {
    // MARK: - Stored properties
    private let background: LinearGradient?
    private let alignment: HorizontalAlignment
    private let padding: CGFloat
    private let content: Content
    private let navigationTitle: String?
    private let leadingToolbar: Leading
    private let trailingToolbar: Trailing
    
    @Environment(\.designSchemeColors) private var schemeColors
    
    // MARK: - Design background
    private var defaultBackground: LinearGradient {
        LinearGradient(
            colors: Array(repeating: schemeColors.background.foreground, count: 6) + [schemeColors.background.background],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
    
    // MARK: - Designated initialiser
    public init(
        navigationTitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.alignment = alignment
        self.background = background
        self.padding = padding
        self.navigationTitle = navigationTitle
        self.content = content()
        self.leadingToolbar = leadingToolbar()
        self.trailingToolbar = trailingToolbar()
    }
    
    // MARK: - Body
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: alignment, spacing: padding) {
                    content
                }
                .padding(.horizontal, padding)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxHeight: .infinity)
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

// MARK: - Convenience initialisers (omit either/both toolbars)

// No toolbars
public extension BaseView where Leading == EmptyView, Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            alignment: alignment,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: { EmptyView() },
            background: background,
            padding: padding
        )
    }
}

// Only leading toolbar (parameter order: leading, then content)
public extension BaseView where Trailing == EmptyView {
    init(
        navigationTitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            alignment: alignment,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: { EmptyView() },
            background: background,
            padding: padding
        )
    }
}

// Only trailing toolbar (parameter order: trailing, then content)
public extension BaseView where Leading == EmptyView {
    init(
        navigationTitle: String? = nil,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            alignment: alignment,
            content: content,
            leadingToolbar: { EmptyView() },
            trailingToolbar: trailingToolbar,
            background: background,
            padding: padding
        )
    }
}

// Both toolbars (order: leading, trailing, content for natural call-sites)
public extension BaseView {
    init(
        navigationTitle: String? = nil,
        @ViewBuilder leadingToolbar: () -> Leading,
        @ViewBuilder trailingToolbar: () -> Trailing,
        @ViewBuilder content: () -> Content,
        alignment: HorizontalAlignment = .leading,
        background: LinearGradient? = nil,
        padding: CGFloat = 16
    ) {
        self.init(
            navigationTitle: navigationTitle,
            alignment: alignment,
            content: content,
            leadingToolbar: leadingToolbar,
            trailingToolbar: trailingToolbar,
            background: background,
            padding: padding
        )
    }
}

// MARK: - Previews

#Preview("No Toolbar") {
    BaseView(navigationTitle: "Overview") {
        VStack(spacing: 16) {
            DesignCard { Text("Card 1") }
            DesignCard { Text("Card 2") }
            DesignProgressBar(value: 0.4)
        }
    }
}

#Preview("Only Leading Toolbar") {
    BaseView(
        navigationTitle: "Detail",
        leadingToolbar: {
            Button("Close") { print("Close tapped") }
        }
    ) {
        VStack(spacing: 16) {
            Text("This screen has a leading toolbar button.")
            DesignProgressBar(value: 0.5)
        }
    }
}

#Preview("Only Trailing Toolbar") {
    BaseView(
        navigationTitle: "Edit",
        trailingToolbar: {
            Button("Save") { print("Save tapped") }
        }
    ) {
        VStack(spacing: 16) {
            Text("This screen has a trailing toolbar button.")
            DesignProgressBar(value: 0.8)
        }
    }
}

#Preview("Both Toolbars") {
    BaseView(
        navigationTitle: "Item",
        leadingToolbar: { Button("Back") { print("Back tapped") } },
        trailingToolbar: { Button("Done") { print("Done tapped") } }
    ) {
        VStack(spacing: 16) {
            Text("This screen has both leading and trailing toolbar buttons.")
            DesignCard { Text("Toolbar demo") }
        }
    }
}

private struct ToolbarControlsPreviewHost: View {
    @State private var isEnabled: Bool = true
    @State private var filter: Filter = .all
    
    enum Filter: String, CaseIterable, Identifiable {
        case all, open, done
        var id: Self { self }
        var title: String {
            switch self {
            case .all: return "All"
            case .open: return "Open"
            case .done: return "Done"
            }
        }
    }
    
    var body: some View {
        BaseView(
            navigationTitle: "Toolbar Controls",
            leadingToolbar: {
                Button("< back") {
                    print("back")
                }
            },
            trailingToolbar: {
                Button("+") {
                    print("back")
                }
            }
        ) {
            Picker("Filter", selection: $filter) {
                ForEach(Filter.allCases) { value in
                    Text(value.title).tag(value)
                }
            }
            .pickerStyle(.segmented)
            Toggle("", isOn: $isEnabled)
            Text("Enabled: \(isEnabled ? "Yes" : "No")")
            Text("Filter: \(filter.title)")
            Divider()
            Text("Content updates live as you change toolbar controls.")
        }
    }
}

#Preview("Toolbar: Toggle + Picker") {
    ToolbarControlsPreviewHost()
}
