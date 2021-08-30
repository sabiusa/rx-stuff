//
//  relays_tests.swift
//  relays-tests
//
//  Created by Saba Khutsishvili on 30.08.21.
//

import XCTest
import RxSwift
import RxRelay

class relays_tests: XCTestCase {

    func test_publishRelay() {
        example(of: "PublishRelay") {
            let bag = DisposeBag()
            
            let relay = PublishRelay<String>()
            relay.accept("Knock knock")
            
            relay
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: bag)
            
            relay.accept("Who dis")
        }
    }
    
    func test_behaviorRelay() {
        example(of: "BehaviorRelay") {
            let bag = DisposeBag()
            
            let relay = BehaviorRelay(value: "Initial value")
            relay.accept("New value")
            
            relay
                .subscribe(onNext: {
                    print("1) \($0)")
                })
                .disposed(by: bag)
            
            relay.accept("2")
            
            relay.subscribe(onNext: {
                print("2) \($0)")
            })
            .disposed(by: bag)
            
            relay.accept("3")
            
            print(relay.value)
        }
    }
    
    func test_blackJack() {
        example(of: "BlackJack") {
            let bag = DisposeBag()
            let bj = BlackJack()
            
            let dealtHand = PublishSubject<[(String, Int)]>()
          
            func deal(_ cardCount: UInt) {
                var deck = bj.cards
                var cardsRemaining = deck.count
                var hand = [(String, Int)]()
            
                for _ in 0 ..< cardCount {
                    let randomIndex = Int.random(in: 0 ..< cardsRemaining)
                    hand.append(deck[randomIndex])
                    deck.remove(at: randomIndex)
                    cardsRemaining -= 1
                }
            
                let points = bj.points(for: hand)
                if (points > 21) {
                    dealtHand.onError(BlackJack.HandError.busted(points: points))
                } else {
                    dealtHand.onNext(hand)
                }
            }
          
            dealtHand
                .subscribe(
                    onNext: { hand in
                        print(bj.cardString(for: hand))
                    },
                    onError: { error in
                        print("Loser: \(error)")
                    }
                )
                .disposed(by: bag)
          
            deal(3)
        }
    }

}
