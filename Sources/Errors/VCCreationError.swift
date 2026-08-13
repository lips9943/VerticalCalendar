//
//  VCCreationError.swift
//  VerticalCalendar
//
//  Created by 고혁준 on 9/2/25.
//
import Foundation

public struct VCCreationError {
    public static func invalidDateFormat(_ date: Date) -> VCError { VCError.invalidDateFormat(date) }
}
