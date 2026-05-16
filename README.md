# VerticalCalendar

A highly customizable vertical calendar component for iOS, built with UIKit and Compositional Layout.

## Features
- Smooth vertical scrolling
- Modern UI with `UICollectionViewCompositionalLayout`
- Support for custom ViewModels and Managers

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/VerticalCalendar.git", from: "1.0.0")
]
```

Or add it via Xcode:
1. File > Add Packages...
2. Enter the repository URL

## Quick Start

To use `VerticalCalendar`, you need to implement the required protocols (`VCCalendar`, `VCMonth`, `VCDay`, `VCCalendarManager`, and `VCViewModel`).

```swift
import UIKit
import VerticalCalendar

// 1. Implement your models and managers
// (See the protocols in the Abstracts folder)

// 2. Initialize your ViewModel
let viewModel = YourCustomViewModel(manager: yourManager)

// 3. Create ViewController
let calendarVC = VCalendar(viewModel: viewModel)

// 4. Register Cells
calendarVC.collectionView.register(YourDayCell.self, forCellWithReuseIdentifier: "DayCell")
```

## Requirements
- iOS 14.0+
- Swift 5.9+

## License
MIT
