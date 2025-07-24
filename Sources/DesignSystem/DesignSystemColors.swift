import SwiftUI

@propertyWrapper
public struct DesignSystemColors: DynamicProperty {
    @Environment(\.designSystemColorProvider) private var provider

    public var wrappedValue: DesignSystemColorProvider { provider }

    public init() {}
} 
