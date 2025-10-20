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

    fileprivate var center: UnitPoint {
        switch self {
        case .extremeTopLeading:     return .init(x: -0.5, y: -0.5)
        case .extremeTopTrailing:    return .init(x:  1.5, y: -0.5)
        case .extremeBottomTrailing: return .init(x:  1.5, y:  1.5)
        case .extremeBottomLeading:  return .init(x: -0.5, y:  1.5)
        }
    }

    func makeStyle(using scheme: DesignSchemeColors) -> AnyShapeStyle {
        AnyShapeStyle(
            RadialGradient(
                colors: [
                    scheme.background.foreground,   // "backgroundVariant"
                    scheme.background.background    // "background"
                ],
                center: center,
                startRadius: 600,
                endRadius: 900
            )
        )
    }
}

// MARK: - Public API

public extension View {
    /// Apply a DS preset background that fills the entire screen (ignores safe areas).
    func designBackground(_ preset: DesignBackgroundPreset) -> some View {
        modifier(DesignBackgroundScreenFill(preset: preset))
    }

    /// Apply any ShapeStyle (Color, Gradient, Material) as a screen-filling background.
    func designBackground<S: ShapeStyle>(_ style: S) -> some View {
        modifier(DesignBackgroundScreenFill(style: AnyShapeStyle(style)))
    }

    /// Apply the package's default DS background (same as BaseView’s default) and fill screen.
    func designDefaultBackground() -> some View {
        modifier(DesignBackgroundScreenFill())
    }
}

// MARK: - Implementation

private struct DesignBackgroundScreenFill: ViewModifier {
    @Environment(\.designSchemeColors) private var schemeColors

    // One of these will be set
    var style: AnyShapeStyle?
    var preset: DesignBackgroundPreset?

    init(style: AnyShapeStyle? = nil, preset: DesignBackgroundPreset? = nil) {
        self.style = style
        self.preset = preset
    }

    func body(content: Content) -> some View {
        content.background(
            // Using a view builder so we can attach ignoresSafeArea specifically to the background.
            Rectangle()
                .fill(resolvedStyle)
                .ignoresSafeArea(.container, edges: .all)
        )
    }

    private var resolvedStyle: AnyShapeStyle {
        if let style { return style }
        if let preset { return preset.makeStyle(using: schemeColors) }

        // Fallback to the same default as BaseView
        return AnyShapeStyle(
            LinearGradient(
                colors: Array(repeating: schemeColors.background.foreground, count: 6)
                        + [schemeColors.background.background],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        )
    }
}
