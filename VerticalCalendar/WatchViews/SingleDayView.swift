//
//  SingleDayView.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/29/25.
//
//
//import SwiftUI
//import WatchKit
//
//public struct SingleDayView: View {
//    private var currentDate: Date = Date()
//    private var watchSize = WKInterfaceDevice.current().screenBounds
//    public var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading, spacing: 0) {
//                HStack(alignment: .top) {
//                    Text("\(currentDate.day!)")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                        .lineLimit(1)
//                        .padding(.top, watchSize.width / 15)
//                        .padding(.leading, watchSize.width / 7.5)
//                    Spacer()
//                    Text("\(currentDate.month!)/\(currentDate.year!.description)")
//                        .font(.caption2)
//                        .padding([.top, .trailing], watchSize.width / 12)
//                    
//                }
//                
//                Spacer()
//            }.background {
//                Rectangle()
//                    .fill(Color.gray.opacity(0.2))
//                
//            }.clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
//        }
//    }
//}
//
//#Preview {
//    SingleDayView()
//}
