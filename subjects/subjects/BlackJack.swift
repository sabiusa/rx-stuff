//
//  BlackJack.swift
//  subjects
//
//  Created by Saba Khutsishvili on 30.08.21.
//

import Foundation

public struct BlackJack {
    
    public let cards = [
        ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
        ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
        ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
        ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
    ]
    
    public func cardString(for hand: [(String, Int)]) -> String {
        return hand.map { $0.0 }.joined(separator: "")
    }
    
    public func points(for hand: [(String, Int)]) -> Int {
        return hand.map { $0.1 }.reduce(0, +)
    }
    
    public enum HandError: Error {
        case busted(points: Int)
    }
    
}
