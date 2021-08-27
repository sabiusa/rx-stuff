//
//  subjects_test.swift
//  subjects-test
//
//  Created by Saba Khutsishvili on 26.08.21.
//

import XCTest
import RxSwift

class subjects_test: XCTestCase {
    
    func test_publishSubject() {
        example(of: "PublishSubject") {
            let bag = DisposeBag()
            
            let pub = PublishSubject<String>()
            pub.on(.next("Hello"))
            
            let sub = pub
                .subscribe(onNext: { val in
                    print(val)
                })
            
            pub.on(.next("World"))
            pub.onNext("!")
            
            sub.disposed(by: bag)
        }
    }

}
