# DesignSystem

A SwiftUI-first design system library for iOS, providing a set of customizable, theme-aware UI components.

## Features
- Consistent color schemes and theming via a color provider protocol
- App-wide color configuration with environment propagation
- Ready-to-use, accessible components:
  - `DesignButton`
  - `DesignRow`
  - `DesignTextField`
  - `DesignCard`
  - `DesignToggle`
  - `DesignListItem`
  - `DesignProgressBar`
  - `BaseView`
- Easy integration: just `import DesignSystem` in your app
- Modern SwiftUI patterns and best practices

## Usage
1. Define your color palette by conforming to `DesignSystemColorProvider`.
2. Set your color provider at the app or root view level using `.designSystemColorProvider(...)`.
3. Use any DesignSystem component in your views. All components will automatically use your color scheme.

## Example
```swift
import DesignSystem

struct MyColors: DesignSystemColorProvider { ... }

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .designSystemColorProvider(MyColors())
        }
    }
}
```

## Components
- `DesignButton`
- `DesignRow`
- `DesignTextField`
- `DesignCard`
- `DesignToggle`
- `DesignListItem`
- `DesignProgressBar`
- `BaseView`

All components are public and available with a single `import DesignSystem`.

## Installation

Add this package to your Xcode project:

1. In Xcode, go to File → Add Package Dependencies
2. Enter the package URL
3. Select the version you want to use

## Quick Start

### 1. Define Your Colors

Create a struct that implements `DesignSystemColorProvider`:

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

### 2. Set Colors App-Wide (Recommended)

Set your custom colors once at the app level, and all DesignSystem components will automatically use them:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .designSystemColorProvider(MyCustomColors())
        }
    }
}
```

### 3. Use Components

Now you can use DesignSystem components anywhere in your app without specifying colors:

```swift
struct ContentView: View {
    var body: some View {
        BaseView {
            VStack(spacing: 16) {
                DesignButton(
                    title: "Primary Button",
                    action: { print("Button tapped!") }
                )
                
                DesignButton(
                    title: "Accent Button",
                    scheme: .accent,
                    action: { print("Accent tapped!") }
                )
                
                DesignRow(title: "My Row") {
                    Image(systemName: "star.fill")
                }
                
                DesignRow(title: "Secondary Row", scheme: .secondary) {
                    Image(systemName: "heart.fill")
                }
                
                DesignTextField(
                    placeholder: "Enter your name",
                    text: $name,
                    scheme: .primary
                )
            }
        }
    }
}
```

## Color Schemes

The DesignSystem supports three color schemes:

- **Primary** (default): Main button and row styling
- **Secondary**: Alternative styling option
- **Accent**: Highlighted styling for important actions

## Advanced Usage

### Setting Colors for Specific Views

If you want different colors for specific parts of your app, you can override the app-wide colors:

```swift
struct SpecialView: View {
    var body: some View {
        VStack {
            DesignButton(title: "Special Button") { }
        }
        .designSystemColorProvider(DifferentColors())
    }
}
```

### Custom Background Gradients

You can create background gradients from your color scheme:

```swift
BaseView(
    background: MyCustomColors().createBackgroundGradient()
) {
    // Your content here
}
```

## Components

### DesignButton

A customizable button component with support for different color schemes.

```swift
DesignButton(
    title: "Button Title",
    scheme: .primary, // optional, defaults to .primary
    action: { /* your action */ }
)
```

### DesignRow

A flexible row component that can contain any content.

```swift
DesignRow(
    title: "Row Title", // optional
    scheme: .primary, // optional, defaults to .primary
    action: { /* optional tap action */ }
) {
    // Your content here
    Image(systemName: "star.fill")
    Text("Some text")
}
```

### DesignTextField

A customizable text input field with support for different color schemes.

```swift
DesignTextField(
    placeholder: "Enter your name",
    text: $name,
    scheme: .primary // optional, defaults to .primary
)
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

### DesignCard

A container for grouping content with padding, background, and optional shadow.

```swift
DesignCard(scheme: .primary) {
    VStack(alignment: .leading) {
        Text("Card Title")
            .font(.headline)
        Text("Card content goes here.")
    }
}
```

### DesignToggle

A styled switch for boolean values.

```swift
@State private var isOn = false

DesignToggle(
    title: "Enable notifications",
    isOn: $isOn,
    scheme: .primary // optional, defaults to .primary
)
```

### DesignListItem

A row with leading/trailing icons, title, subtitle, and tap action.

```swift
DesignListItem(
    title: "List Item",
    subtitle: "Optional subtitle",
    scheme: .primary, // optional, defaults to .primary
    leading: { Image(systemName: "star.fill") },
    trailing: { Text("Detail") },
    action: { print("Tapped!") }
)
```

### DesignProgressBar

A progress indicator with custom colors and optional label.

```swift
DesignProgressBar(
    value: 0.7, // 0.0 ... 1.0
    title: "Loading...",
    scheme: .accent // optional, defaults to .accent
)
```

## Accessibility

All DesignSystem components are built with accessibility in mind. To ensure your app is usable by everyone:

- Use clear, descriptive titles and labels for all components.
- All interactive components (buttons, toggles, list items) are accessible by default.
- Colors are chosen for sufficient contrast, but always test with your own palette.
- You can add `.accessibilityLabel`, `.accessibilityHint`, and other SwiftUI accessibility modifiers to any component.
- Test your app with VoiceOver and Dynamic Type.

**Example:**
```swift
DesignButton(title: "Save")
    .accessibilityLabel("Save changes")
    .accessibilityHint("Saves your current work")
```

## Requirements

- iOS 17.0+
- Swift 6.1+
- Xcode 15.0+

## License

This package is available under the MIT license. 