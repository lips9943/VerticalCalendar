# VerticalCalendar 🗓️

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

A premium, highly customizable vertical scrolling calendar for iOS. Built with **UIKit** and **Compositional Layout**, it provides a smooth and modern user experience for date selection and schedule management.

## ✨ What is VerticalCalendar?

`VerticalCalendar` is more than just a simple calendar view; it's a **protocol-oriented calendar framework**.

Unlike rigid calendar libraries, `VerticalCalendar` is designed with flexibility in mind:

- **Protocol-Driven Architecture**: Every component (Calendar, Month, Day, Manager, and ViewModel) is defined by protocols, allowing you to inject your own custom logic and data models easily.
- **Modern Layout**: Leverages `UICollectionViewCompositionalLayout` for high-performance scrolling and responsive design.
- **Customizable UI**: While it comes with sensible defaults, you can easily subclass `VCalendar` or register your own cells to completely change the look and feel.
- **Automatic Year View**: Includes a built-in floating year indicator that updates as the user scrolls.

## 📦 Installation

### Swift Package Manager (Recommended)

You can install `VerticalCalendar` via [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, select **File > Add Packages...**
2. Enter the following URL in the search bar:
   ```text
   https://github.com/lips9943/VerticalCalendar.git
   ```
3. Set the **Dependency Rule** to "Up to Next Major Version" and click **Add Package**.

Alternatively, add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/lips9943/VerticalCalendar.git", from: "1.0.0")
]
```

## 🚀 Quick Start

`VerticalCalendar` is designed to be lightweight and flexible. Because it doesn't force a specific UI, you need to register the cells you want to use. You can use the provided default implementations to get started quickly.

```swift
import UIKit
import VerticalCalendar

// 1. Initialize your manager (Handles date range and calculations)
// Defaults to -60 years and +60 years from today
let manager = VCDefaultCalendarManager()

// 2. Initialize your ViewModel
let viewModel = VCDefaultViewModel(calendarManager: manager)

// 3. Create the Calendar ViewController
let calendarVC = VCalendar(viewModel: viewModel)

// 4. Register the default cells (Crucial step!)
calendarVC.collectionView.register(
    VCDayCell.self, 
    forCellWithReuseIdentifier: VCDayCell.reuseIdentifier
)
calendarVC.collectionView.register(
    VCMonthReusableView.self,
    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
    withReuseIdentifier: VCMonthReusableView.identifier
)

// 5. Present or push the ViewController
present(calendarVC, animated: true)
```

## 🛠 Default Implementations

To help you get started, the library includes several "Default" implementations that follow the required protocols:

- `VCDefaultCalendarManager`: Handles basic date calculations and creates the calendar structure.
- `VCDefaultViewModel`: Manages the state of the calendar and provides data to the view controller.
- `VCDayCell`: A standard day cell showing the date number.
- `VCMonthReusableView`: A standard header showing the month and year.

## 🎨 Customization

The true power of `VerticalCalendar` lies in its **protocol-oriented design**. You can customize every part of the calendar by implementing the following protocols:

### Custom Cells
If you want a different look for your days or headers, simply create your own `UICollectionViewCell` and register it using the default identifiers:

```swift
// Register your own cell
calendarVC.collectionView.register(
    MyCustomDayCell.self, 
    forCellWithReuseIdentifier: VCDayCell.reuseIdentifier
)
```

### Custom Logic
You can create your own `ViewModel` or `CalendarManager` by conforming to `VCViewModel` and `VCCalendarManager`. This allows you to:
- Add events/dots to specific days.
- Change how dates are calculated.
- Support different calendar systems.

## 🛠 Requirements

| Requirement | Minimal Version |
| :---------- | :-------------- |
| **iOS**     | 16.0+           |
| **Swift**   | 5.9+            |
| **Xcode**   | 15.0+           |

## 📄 License

`VerticalCalendar` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
