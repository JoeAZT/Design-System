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
                    VStack(alignment: .leading, spacing: 0) {
                        if let title { Text(title).font(.headline) }
                        if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(.secondary) }
                    }
                    .textCase(nil)
                    .frame(maxWidth: .infinity, alignment: .leading) // align flush left
                    .padding(.leading, 0)
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

// MARK: - Previews

private struct PreviewItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let value: Double
}

private extension Double {
    func asGBPString() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyCode = "GBP"
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf.string(from: NSNumber(value: self)) ?? "£0.00"
    }
}

#Preview("Clear background • Multi-section") {
    ZStack {
        LinearGradient(
            colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        DesignList(
            backgroundStyle: .clear
        ) {
            Section("Your assets") {
                ForEach([
                    PreviewItem(name: "Cash Account", value: 1250.00),
                    PreviewItem(name: "AAPL", value: 2599.74),
                    PreviewItem(name: "BTC", value: 310.42)
                ]) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(item.value.asGBPString()).bold()
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }
            }

            Section("Asset classes") {
                HStack { Text("Cash Holdings");  Spacer(); Text(1250.00.asGBPString()).bold() }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)

                HStack { Text("Crypto Holdings"); Spacer(); Text(310.42.asGBPString()).bold() }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)

                HStack { Text("Stock Holdings");  Spacer(); Text(2599.74.asGBPString()).bold() }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

#Preview("Convenience init • Delete • Clear background") {
    struct Wrapper: View {
        @State private var items: [PreviewItem] = [
            .init(name: "Cash Account", value: 1250.00),
            .init(name: "AAPL", value: 2599.74),
            .init(name: "BTC", value: 310.42)
        ]

        var body: some View {
            ZStack {
                LinearGradient(colors: [.orange.opacity(0.4), .pink.opacity(0.4)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                NavigationStack {
                    DesignList(
                        title: "My Assets",
                        backgroundStyle: .clear,
                        data: items,
                        onDelete: { offsets in
                            items.remove(atOffsets: offsets)
                        }
                    ) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.value.asGBPString()).bold()
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                    }
                    .toolbar { EditButton() }
                    .navigationTitle("Preview")
                }
            }
        }
    }
    return Wrapper()
}

#Preview("Schemed background • Plain style") {
    DesignList(
        title: "Schemed Example",
        subtitle: "Uses design system colors"
    ) {
        Section("Section A") {
            ForEach(0..<3, id: \.self) { i in
                HStack {
                    Text("Row \(i + 1)")
                    Spacer()
                    Text((Double(i + 1) * 100).asGBPString()).bold()
                }
                .padding(.vertical, 8)
            }
        }
        Section("Section B") {
            Text("Another row").padding(.vertical, 8)
        }
    }
    .listStyle(.plain)
}
