//
//  DesignList.swift
//  DesignSystem
//
//  Created by Joe Taylor on 19/09/2025.
//

import SwiftUI

public enum DesignListBackground {
    case schemed   // uses your design system colors
    case clear     // fully transparent; lets parent background show through
}

public struct DesignList<Content: View>: View {
    
    // Optional list-level header
    private let title: String?
    private let subtitle: String?
    private let scheme: DesignScheme?
    
    // Appearance controls
    private let backgroundStyle: DesignListBackground
    
    // Rendered rows/sections
    private let content: Content
    
    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme
    
    // MARK: Primary initializer (arbitrary content / multi-section)
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
        backgroundStyle: DesignListBackground = .schemed,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.scheme = scheme
        self.backgroundStyle = backgroundStyle
        self.content = content()
    }
    
    // MARK: Convenience initializer (single dataset)
    public init<Data, Row>(
        title: String? = nil,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
        backgroundStyle: DesignListBackground = .schemed,
        data: Data,
        onDelete: ((IndexSet) -> Void)? = nil,
        @ViewBuilder row: @escaping (Data.Element) -> Row
    ) where
    Data: RandomAccessCollection,
    Data.Element: Identifiable,
    Row: View,
    Content == _DesignListRows<Data, Row>
    {
        self.title = title
        self.subtitle = subtitle
        self.scheme = scheme
        self.backgroundStyle = backgroundStyle
        self.content = _DesignListRows(data: data, onDelete: onDelete, row: row)
    }
    
    private var resolvedScheme: DesignScheme { scheme ?? defaultChildScheme }
    private var colorPair: DesignSchemeColorPair { schemeColors.colors(for: resolvedScheme) }
    
    public var body: some View {
        List {
            if title != nil || subtitle != nil {
                Section {
                    content
                } header: {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title { Text(title).font(.headline) }
                        if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(.secondary) }
                    }
                    .textCase(nil)
                }
            } else {
                content
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(backgroundStyle == .schemed ? colorPair.background : Color.clear)
        .foregroundStyle(colorPair.foreground)
    }
}

// MARK: - Helper rows for convenience initializer
public struct _DesignListRows<Data, Row: View>: View
where Data: RandomAccessCollection, Data.Element: Identifiable {
    
    let data: Data
    let onDelete: ((IndexSet) -> Void)?
    let row: (Data.Element) -> Row
    
    public var body: some View {
        if let onDelete {
            ForEach(data) { item in row(item) }
                .onDelete(perform: onDelete)
                .listRowBackground(Color.clear) // plays nice with transparent list
        } else {
            ForEach(data) { item in row(item) }
                .listRowBackground(Color.clear)
        }
    }
}

// MARK: - Global separator hiding for arbitrary multi-section content
private struct _GlobalSeparatorHiding: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}
