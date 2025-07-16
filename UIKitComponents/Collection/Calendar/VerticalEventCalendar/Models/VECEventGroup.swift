//
//  VECEventGroup.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/17/25.
//

struct VECEventGroup: Hashable, Equatable {
    let month: Int
    let year: Int
    var events: Set<VECEvent>
    
    init(date: Date, events: [VECEvent] = []) {
        self.month = date.month
        self.year = date.year
        self.events = []
        self.events.formUnion(events)
    }
    
    mutating func insert(_ event: VECEvent) {
        events.update(with: event)
    }
    
    mutating func insert(contentsOf events: [VECEvent]) {
        self.events.updated(contentsOf: events)
    }
    
    mutating func remove(_ event: VECEvent) {
        events.remove(event)
    }
    
    mutating func remove(_ index: Set<VECEvent>.Index) {
        events.remove(at: index)
    }
    
    mutating func remove(where predicate: @escaping (VECEvent) throws -> Bool) -> VECEvent {
        guard let index = try? events.firstIndex(where: predicate) else { fatalError("인덱스가 받아오지 못했습니다.") }
        return events.remove(at: index)
    }
     
    static func == (lhs: VECEventGroup, rhs: VECEventGroup) -> Bool {
        lhs.year == rhs.year && lhs.month == rhs.month
    }
    
    static func == (lhs: VECEventGroup, rhs: Date) -> Bool {
        lhs.year == rhs.year && lhs.month == rhs.month
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(month)
        hasher.combine(year)
    }
}
