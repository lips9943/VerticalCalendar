//
//  Set.swift
//  UIKitComponents
//
//  Created by 고혁준 on 7/17/25.
//

extension Set {
    func update<S>(contentsOf sequence: S) -> Set<Element> where S : Sequence, Element == S.Element {
        var result = self
        sequence.forEach { result.update(with: $0) }
        return result
    }
    
    mutating func updated<S>(contentsOf sequence: S) where S : Sequence, Element == S.Element {
        sequence.forEach { self.update(with: $0) }
    }
}
