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

}
