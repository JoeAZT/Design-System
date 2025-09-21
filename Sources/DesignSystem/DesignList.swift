//
//  DesignList.swift
//  DesignSystem
//
//  Created by Joe Taylor on 19/09/2025.
//

import SwiftUI

public struct DesignList<Content: View>: View {

    // Optional header text for the *whole list*
    private let title: String?
    private let subtitle: String?
    private let scheme: DesignScheme?

    // Rendered rows/sections built by caller
    private let content: Content

    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme

    // MARK: - Primary initializer (multi-section / arbitrary content)
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.scheme = scheme
        self.content = content()
    }

    // MARK: - Convenience initializer (single dataset like your current API)
    public init<Data, Row>(
        title: String? = nil,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
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
        self.content = _DesignListRows(data: data, onDelete: onDelete, row: row)
    }

    private var resolvedScheme: DesignScheme { scheme ?? defaultChildScheme }
    private var colorPair: DesignSchemeColorPair { schemeColors.colors(for: resolvedScheme) }

    public var body: some View {
        List {
            // Optional list-level header (not the same as Section headers)
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
        .background(colorPair.background)
        .foregroundStyle(colorPair.foreground)
    }
}

// MARK: - Internal helper used by the convenience initializer
public struct _DesignListRows<Data, Row: View>: View
where Data: RandomAccessCollection, Data.Element: Identifiable {

    let data: Data
    let onDelete: ((IndexSet) -> Void)?
    let row: (Data.Element) -> Row

    public var body: some View {
        if let onDelete {
            ForEach(data) { item in row(item) }
                .onDelete(perform: onDelete)
        } else {
            ForEach(data) { item in row(item) }
        }
    }
}

