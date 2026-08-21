//
//  CellConfigureDelegate.swift
//  VerticalCalendar
//
//  Created by Jun on 8/22/26.
//
import UIKit

public protocol CellConfigureDelegate: AnyObject {
    func configureTodayCell(_ cell: VCDayCell, canTodayViewConfigure view: VCDayCellLabel, preloadSize size: CGSize)
}
