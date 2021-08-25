//
//  observables_test.swift
//  observables-test
//
//  Created by Saba Khutsishvili on 25.08.21.
//

import XCTest
import RxSwift

class observables_test: XCTestCase {

    func test_something() {
        let a = 1
        
        test_observables()
        
        XCTAssertEqual(a, 1)
    }
    
    func test_observables() {
        example(of: "just, of, from") {
          let one = 1
          let two = 2
          let three = 3
          
          let observable = Observable<Int>.just(one)
        }
    }

}
