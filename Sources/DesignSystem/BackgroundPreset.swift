//
//  BackgroundPreset.swift
//  DesignSystem
//
//  Created by Joe Taylor on 20/10/2025.
//

import SwiftUI

public enum DesignBackgroundPreset: Sendable {
    case extremeTopLeading
    case extremeTopTrailing
    case extremeBottomTrailing
    case extremeBottomLeading

    // Centers use your “extreme” xy values
    fileprivate var center: UnitPoint {
        switch self {
        case .extremeTopLeading:     return .init(x: -0.5, y: -0.5)
        case .extremeTopTrailing:    return .init(x:  1.5, y: -0.5)
        case .extremeBottomTrailing: return .init(x:  1.5, y:  1.5)
        case .extremeBottomLeading:  return .init(x: -0.5, y:  1.5)
        }
    }

    /// Builds the default DS-driven gradient for this preset using your scheme colors.
    func makeStyle(using scheme: DesignSchemeColors) -> AnyShapeStyle {
        AnyShapeStyle(
            RadialGradient(
                colors: [
                    scheme.background.foreground,   // matches Color("backgroundVariant")
                    scheme.background.background    // matches Color("background")
                ],
                center: center,
                startRadius: 600,
                endRadius: 900
            )
        )
    }
}
