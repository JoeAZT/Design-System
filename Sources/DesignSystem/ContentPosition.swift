//
//  ContentAlignment.swift
//  DesignSystem
//
//  Created by Joe Taylor on 01/09/2025.
//

import SwiftUI

// MARK: - Unified alignment enum

public enum ContentPosition {
    case topLeading
    case topCenter
    case topTrailing
    case centerLeading
    case center
    case centerTrailing
    case bottomLeading
    case bottomCenter
    case bottomTrailing

    var frameAlignment: Alignment {
        switch self {
        case .topLeading:      return .topLeading
        case .topCenter:       return .top
        case .topTrailing:     return .topTrailing
        case .centerLeading:   return .leading
        case .center:          return .center
        case .centerTrailing:  return .trailing
        case .bottomLeading:   return .bottomLeading
        case .bottomCenter:    return .bottom
        case .bottomTrailing:  return .bottomTrailing
        }
    }

    var stackAlignment: HorizontalAlignment {
        switch self {
        case .topLeading, .centerLeading, .bottomLeading:
            return .leading
        case .topCenter, .center, .bottomCenter:
            return .center
        case .topTrailing, .centerTrailing, .bottomTrailing:
            return .trailing
        }
    }
}
