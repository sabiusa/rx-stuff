//
//  observables_test.swift
//  observables-test
//
//  Created by Saba Khutsishvili on 25.08.21.
//

import XCTest
import RxSwift

class observables_test: XCTestCase {
    
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
    
    func test_range() {
        example(of: "range") {
            let obs = Observable<Int>.range(start: 1, count: 10)
            
            obs.subscribe(
                onNext: { i in
                    let n = Double(i)
                    
                    let fib = ((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded()
                    print(fib)
                }
            )
        }
    }

}