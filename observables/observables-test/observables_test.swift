//
//  observables_test.swift
//  observables-test
//
//  Created by Saba Khutsishvili on 25.08.21.
//

import XCTest
import RxSwift

class observables_test: XCTestCase {

    func test_rx() {
        let a = 1
        
        test_empty()
        test_never()
        test_singleValue()
        
        XCTAssertEqual(a, 1)
    }
    
    func test_empty() {
        example(of: "empty") {
            let obs = Observable<Void>.empty()
            
            obs.subscribe(
                onNext: { elem in
                    print(elem)
                },
                onCompleted: {
                    print("complete")
                }
            )
        }
    }
    
    func test_never() {
        example(of: "never") {
            let obs = Observable<Void>.never()
            
            obs.subscribe(
                onNext: { elem in
                    print(elem)
                },
                onError: { error in
                    print(error)
                },
                onCompleted: {
                    print("complete")
                }
            )
        }
    }
    
    func test_singleValue() {
        example(of: "just, of, from") {
            let one = 1
            let two = 2
            let three = 3
          
            let obs = Observable.of(one, two, three)
            obs.subscribe { event in
                if let elem = event.element {
                    print(elem)
                } else if event.isCompleted {
                    print("complete")
                }
            }
        }
    }

}
