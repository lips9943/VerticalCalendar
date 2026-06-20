//
//  ContentView.swift
//  TestPreview
//
//  Created by 고혁준 on 6/18/26.
//

import SwiftUI
import UIKit
import VerticalCalendar

struct ContentView: View {
    @State var tabIndex: Int = 0
    var body: some View {
        TabView(selection: $tabIndex) {
            Tab(value: 0) {
                VCTestPreview()
            } label: {
                Text("Calendar")
            }

            Tab(value: 1) {
                Text("hi")
            } label: {
                Text("더미")
            }

        }
        
    }
}

#Preview {
    ContentView()
}
