//
//  DesignList.swift
//  DesignSystem
//
//  Created by Joe Taylor on 19/09/2025.
//

import SwiftUI

public struct DesignList<Data, Row: View>: View
where Data: RandomAccessCollection, Data.Element: Identifiable {

    private let title: String?
    private let subtitle: String?
    private let scheme: DesignScheme?
    private let data: Data
    private let row: (Data.Element) -> Row
    private let onDelete: ((IndexSet) -> Void)?

    @Environment(\.designSchemeColors) private var schemeColors
    @Environment(\.designSystemDefaultChildScheme) private var defaultChildScheme

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        scheme: DesignScheme? = nil,
        data: Data,
        onDelete: ((IndexSet) -> Void)? = nil,
        @ViewBuilder row: @escaping (Data.Element) -> Row
    ) {
        self.title = title
        self.subtitle = subtitle
        self.scheme = scheme
        self.data = data
        self.onDelete = onDelete
        self.row = row
    }

    private var resolvedScheme: DesignScheme { scheme ?? defaultChildScheme }
    private var colorPair: DesignSchemeColorPair { schemeColors.colors(for: resolvedScheme) }

    public var body: some View {
        List {
            if title != nil || subtitle != nil {
                Section {
                    rows // <- builds ForEach with/without .onDelete
                } header: {
                    VStack(alignment: .leading, spacing: 2) {
                        if let title { Text(title).font(.headline) }
                        if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(.secondary) }
                    }
                    .textCase(nil)
                    .padding(.bottom, 4)
                }
            } else {
                rows
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(colorPair.background)
        .foregroundStyle(colorPair.foreground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }

    @ViewBuilder
    private var rows: some View {
        if let onDelete {
            ForEach(data) { item in row(item) }
                .onDelete(perform: onDelete)   // ✅ attach here
        } else {
            ForEach(data) { item in row(item) } // no onDelete
        }
    }
}

struct previewItem: Identifiable {
    let id = UUID()
    let assetName: String
    let assetValue: Double
}

#Preview {
//    BaseView {
        DesignList(
            title: "My Assets",
            subtitle: "Subtitle",
            scheme: .primary,
            data: [
                previewItem(assetName: "Asset 1", assetValue: 1000),
                previewItem(assetName: "Asset 1", assetValue: 2000),
                previewItem(assetName: "Asset 1", assetValue: 3000),
            ],
            onDelete: { indexSet in
                print("Deleted items at: \(indexSet)")
            }
        ) { asset in
            HStack {
                Text("asset.assetName")
                    .foregroundStyle(.black)
                Spacer()
                Text("asset.assetValue.asGBPString()")
                    .bold()
                    .foregroundStyle(.black)
            }
            .foregroundStyle(.white)
            .padding(.vertical, 8)
        }
//    }
}
