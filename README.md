# DesignSystem

A SwiftUI design system package that provides customizable UI components with support for user-defined color schemes.

## Features

- **DesignButton**: Customizable buttons with different color schemes
- **DesignRow**: Flexible row components with customizable styling
- **BaseView**: Foundation view with background and padding
- **Custom Color Support**: Define your own color schemes in your project

## Installation

Add this package to your Xcode project:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the package URL
3. Select the version you want to use

## Basic Usage

```swift
import SwiftUI
import DesignSystem

struct ContentView: View {
    var body: some View {
        BaseView {
            VStack(spacing: 16) {
                DesignButton(
                    title: "Primary Button",
                    action: { print("Button tapped!") }
                )
                
                DesignRow(title: "My Row") {
                    Image(systemName: "star.fill")
                }
            }
        }
    }
}
```

## Custom Colors

You can define your own color scheme by implementing the `DesignSystemColorProvider` protocol:

```swift
struct MyCustomColors: DesignSystemColorProvider {
    let primaryForeground: Color = .white
    let primaryBackground: Color = .blue
    let secondaryForeground: Color = .black
    let secondaryBackground: Color = .lightGray
    let accentForeground: Color = .white
    let accentBackground: Color = .orange
}
```

Then apply your custom colors to your views by setting the color provider once at the top level:

```swift
struct ContentView: View {
    var body: some View {
        BaseView {
            VStack(spacing: 16) {
                // All components below will automatically use your custom colors
                DesignButton(
                    title: "Primary Button",
                    action: { print("Button tapped!") }
                )
                
                DesignButton(
                    title: "Secondary Button",
                    scheme: .secondary,
                    action: { print("Secondary tapped!") }
                )
                
                DesignButton(
                    title: "Accent Button",
                    scheme: .accent,
                    action: { print("Accent tapped!") }
                )
                
                DesignRow(title: "Primary Row") {
                    Image(systemName: "star.fill")
                }
                
                DesignRow(title: "Accent Row", scheme: .accent) {
                    Image(systemName: "bolt.fill")
                }
            }
            .designSystemColorProvider(MyCustomColors())
        }
    }
}
```

## Color Schemes

The DesignSystem supports three color schemes:

- **Primary**: Default button and row styling
- **Secondary**: Alternative styling option
- **Accent**: Highlighted styling for important actions

You can specify a scheme for individual components:

```swift
DesignButton(
    title: "Accent Button",
    scheme: .accent,
    action: { print("Accent button tapped!") }
)
```

## Components

### DesignButton

A customizable button component with support for different color schemes.

```swift
DesignButton(
    title: "Button Title",
    scheme: .primary, // optional
    action: { /* your action */ }
)
```

### DesignRow

A flexible row component that can contain any content.

```swift
DesignRow(
    title: "Row Title", // optional
    action: { /* optional tap action */ }
) {
    // Your content here
    Image(systemName: "star.fill")
    Text("Some text")
}
```

### BaseView

A foundation view that provides background gradient and padding. You can use your custom colors to create a background gradient.

```swift
// Using default background
BaseView {
    // Your content here
}

// Using custom background gradient from your color provider
BaseView(
    background: MyCustomColors().createBackgroundGradient()
) {
    // Your content here
}

// Using a completely custom gradient
BaseView(
    background: LinearGradient(
        colors: [.blue, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
) {
    // Your content here
}
```

## Requirements

- iOS 17.0+
- Swift 6.1+
- Xcode 15.0+

## License

This package is available under the MIT license. 