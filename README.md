# DesignSystem

A SwiftUI-first design system library for iOS, providing a set of customizable, theme-aware UI components.

## Features
- Consistent color schemes and theming via a color provider protocol
- App-wide color configuration with environment propagation
- **Automatic color scheme propagation:** Components nested within a `DesignCard` (or other container) will automatically use the next color scheme in the sequence, making your UI visually distinct and reducing boilerplate. You can still override the color scheme manually if needed.
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

## Automatic Color Scheme Propagation

One of the key features of this package is automatic color scheme propagation. When you nest a component (such as `DesignButton`, `DesignRow`, `DesignTextField`, `DesignListItem`, or `DesignToggle`) inside a container like `DesignCard`, the child component will automatically use the next color scheme in the sequence (e.g., primary → secondary → primary), making your UI visually distinct without extra code.

You can always override the color scheme by passing the `scheme` parameter explicitly.

**Example:**

```swift
DesignCard(scheme: .primary) {
    DesignButton(title: "Action") // uses .secondary by default
    DesignButton(title: "Primary", scheme: .primary) // uses .primary explicitly
    DesignRow(title: "Info") { ... } // uses .secondary by default
    DesignTextField(placeholder: "Email", text: $email) // uses .secondary by default
}
```

This approach reduces boilerplate and ensures a consistent, scalable design system for your app.

---

## Component Reference

Below are detailed descriptions for each component, including all parameters, types, defaults, and usage examples. This is useful if you want to pass the repo link straight to your AI/LLM in order to create UI for your app using the components available in this package.

### DesignButton

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| title     | String | Yes | – | The text to display inside the button. |
| scheme    | DesignScheme? | No | Propagated | The color scheme to use (.primary, .secondary, .accent). If not provided, uses the propagated scheme from the environment. |
| action    | (() -> Void)? | No | nil | The action to perform when the button is tapped. If nil, the button is not tappable. |

**Full Example:**
```swift
DesignButton(title: "Primary Button", action: { print("Tapped!") })
DesignButton(title: "Accent Button", scheme: .accent, action: { print("Accent!") })
```

**Usage Notes:**
- Color scheme propagates from parent containers (e.g., DesignCard).
- Accessible by default; use `.accessibilityLabel` as needed.

---

### DesignRow

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| title     | String? | No | nil | Optional title displayed above the row content. |
| scheme    | DesignScheme? | No | Propagated | The color scheme to use. |
| action    | (() -> Void)? | No | nil | Optional tap action for the row. |
| content   | ViewBuilder | Yes | – | The custom content to display in the row. |

**Full Example:**
```swift
DesignRow(title: "My Row", action: { print("Tapped") }) {
    Image(systemName: "star.fill")
    Text("Row content")
}
```

**Usage Notes:**
- Color scheme propagates from parent containers.
- The row is tappable if `action` is provided.

---

### DesignTextField

| Parameter   | Type           | Required | Default     | Description |
|-------------|----------------|----------|-------------|-------------|
| placeholder | String         | Yes      | –           | Placeholder text when the field is empty. |
| text        | Binding<String>| Yes      | –           | The bound text value. |
| scheme      | DesignScheme?  | No       | Propagated  | The color scheme to use. |

**Full Example:**
```swift
@State var name = ""
DesignTextField(placeholder: "Enter your name", text: $name, scheme: .primary)
```

**Usage Notes:**
- Color scheme propagates from parent containers.
- Accessible by default.

---

### DesignCard

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| title     | String? | No | nil | Optional title displayed at the top of the card. |
| scheme    | DesignScheme | No | .primary | The color scheme to use for the card. |
| spacing   | Spacing | No | .medium | The vertical spacing between elements. |
| content   | ViewBuilder | Yes | – | The content to display inside the card. |

**Full Example:**
```swift
DesignCard(title: "Card Title", scheme: .secondary) {
    Text("Card content")
    DesignButton(title: "Action")
}
```

**Usage Notes:**
- Sets the default color scheme for child components (propagation). This is the only component that doesnt have colour scheme propogation.
- Adds padding, background, and shadow.

---

### DesignToggle

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| title     | String | Yes | – | The label to display next to the toggle. |
| isOn      | Binding<Bool> | Yes | – | The bound boolean value. |
| scheme    | DesignScheme? | No | Propagated | The color scheme to use. |

**Full Example:**
```swift
@State var enabled = false
DesignToggle(title: "Enable notifications", isOn: $enabled, scheme: .accent)
```

**Usage Notes:**
- Color scheme propagates from parent containers.
- Accessible by default.

---

### DesignListItem

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| title     | String | Yes | – | The main text to display. |
| subtitle  | String? | No | nil | Optional subtitle below the title. |
| scheme    | DesignScheme? | No | Propagated | The color scheme to use. |
| leading   | ViewBuilder | No | EmptyView | Optional leading view (e.g., icon). |
| trailing  | ViewBuilder | No | EmptyView | Optional trailing view (e.g., detail text). |
| action    | (() -> Void)? | No | nil | Optional tap action for the row. |

**Full Example:**
```swift
DesignListItem(
    title: "List Item",
    subtitle: "Optional subtitle",
    scheme: .primary,
    leading: { Image(systemName: "star.fill") },
    trailing: { Text("Detail") },
    action: { print("Tapped!") }
)
```

**Usage Notes:**
- Color scheme propagates from parent containers.
- Tappable if `action` is provided.
- Use both `leading` and `trailing` for full-featured list items.

---

### DesignProgressBar

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| value     | Double | Yes | – | The progress value (0.0 to 1.0). |
| title     | String? | No | nil | Optional label above the bar. |
| lowerBound| String? | No | nil | Optional label shown at the start (left) of the progress bar. |
| upperBound| String? | No | nil | Optional label shown at the end (right) of the progress bar. |
| scheme    | DesignScheme? | No | Propagated | The color scheme to use. |
| fontSize  | FontSize | No | .medium | The font size for the title. |
| spacing   | CGFloat | No | 8 | The vertical spacing and padding between elements. |
| height    | Height | No | .medium | The height of the progress bar capsules. |

**Full Example:**
```swift
DesignProgressBar(
    value: 0.7,
    title: "Loading...",
    lowerBound: "0%",
    upperBound: "100%",
    scheme: .accent,
    fontSize: .large,
    spacing: 16,
    height: .large
)
```

**Usage Notes:**
- Color scheme propagates from parent containers.
- Use `fontSize` to adjust the title size.
- The lower and upper bounds are only shown if provided.

---

### BaseView

| Parameter   | Type             | Required | Default   | Description |
|-------------|------------------|----------|-----------|-------------|
| background  | LinearGradient?  | No       | nil       | Optional background gradient. If nil, uses the default. |
| padding     | CGFloat          | No       | 16        | Padding for the content. |
| alignment   | HorizontalAlignment | No    | .leading  | Alignment for the content. |
| content     | ViewBuilder      | Yes      | –         | The content to display inside the view. |

**Full Example:**
```swift
BaseView(background: MyColors().createBackgroundGradient(), padding: 24, alignment: .center) {
    Text("Hello World")
    DesignCard {
        Text("Inside a card!")
    }
}
```

**Usage Notes:**
- Use as the root container for screens.
- Supports custom backgrounds and safe area handling.

---

## Color Scheme Propagation

All components (except BaseView) support automatic color scheme propagation. When you nest a component inside a container like `DesignCard`, the child will use the next color scheme in the sequence unless you explicitly set the `scheme` parameter.

**Example:**
```swift
DesignCard(scheme: .primary) {
    DesignButton(title: "Action") // uses .secondary by default
    DesignListItem(title: "Info") // uses .secondary by default
}
```

## Accessibility

All components are built with accessibility in mind. Use `.accessibilityLabel`, `.accessibilityHint`, and other SwiftUI accessibility modifiers as needed.

---

## Accessing Design System Colors in Your Own Components

You can use the current design system colors in your own views and custom components:

```swift
import DesignSystem

struct MyCustomView: View {
    @DesignSystemColors var colors

    var body: some View {
        Rectangle()
            .fill(colors.primaryBackground)
        // Use any color from your DesignSystemColorProvider
    }
}
```

This ensures your custom components always match your app’s theme and color scheme.

---
