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
    
    var body: some View {
        let selection = Binding<Int>(
            get: { self.tabIndex },
            set: { index, t in
                if index == 0 && isCalendar {
                    calendarDoubleTabbed = true
                    print("double")
                    return
                }
                
                isCalendar = index == 0 ? true : false
                tabIndex = index
                calendarDoubleTabbed = false
            }
        )
        
        TabView(selection: selection) {
            Tab(value: 0) {
                VCTestPreview(presentMonthSelectionVC: $calendarDoubleTabbed)
            } label: {
                Text("Calendar")
            }
            
            Tab(value: 1) {
                Text("hi")
            } label: {
                Text("더미")
            }
            
            
            Tab(value: 2) {
                Text("ds")
            } label: {
                Text("dasdf")
            }
        }
    }
}

#Preview {
    ContentView()
}
