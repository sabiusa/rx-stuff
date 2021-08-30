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

}
