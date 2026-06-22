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
    @State var isCalendar: Bool = true
    @State var calendarDoubleTabbed: Bool = false
    @State var isLoading: Bool = true
    
    var body: some View {
        let selection = Binding<Int>(
            get: { self.tabIndex },
            set: { index, t in
                if index == 0 && isCalendar {
                    calendarDoubleTabbed = true
                    return
                }
                
                isCalendar = index == 0 ? true : false
                tabIndex = index
                calendarDoubleTabbed = false
            }
        )
        
        TabView(selection: selection) {
            Tab(value: 0) {
                VCTestPreview(presentMonthSelectionVC: $calendarDoubleTabbed, isLoading: $isLoading)
                    .task {
                        try? await Task.sleep(for: .seconds(5))
                        isLoading = false
                    }
            } label: {
                Text("Calendar")
            }
            
            Tab(value: 1) {
                Text("hi")
            } label: {
                Text("Hello")
            }
            
            
            Tab(value: 2) {
                Text("Profile")
            } label: {
                Text("Profile")
            }
        }
    }
}

#Preview {
    ContentView()
}
