//
//  DesignFieldBackground.swift
//  DesignSystem
//
//  Created by Joe Taylor on 26/09/2025.
//

import SwiftUI

struct DesignFieldBackground: ViewModifier {
    let colorPair: DesignSchemeColorPair
    let enabled: Bool
    
    func body(content: Content) -> some View {
        if enabled {
            content
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(colorPair.background)
                .cornerRadius(10)
        } else {
            content
        }
    }
}

extension View {
    func designFieldBackground(
        _ colorPair: DesignSchemeColorPair,
        enabled: Bool
    ) -> some View {
        self.modifier(DesignFieldBackground(colorPair: colorPair, enabled: enabled))
    }
}
