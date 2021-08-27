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
    
    func test_publishSubject_complete() {
        example(of: "PublishSubject complete") {
            let bag = DisposeBag()
            
            let pub = PublishSubject<String>()
            pub.on(.next("Hello"))
            
            let sub = pub
                .subscribe { event in
                    print("2)", event.element ?? event)
                }
            
            pub.onNext("3")
            pub.onCompleted()
            
            let sub2 = pub
                .subscribe(
                    onNext: { print($0) },
                    onCompleted: { print("Already completed") }
                )
                
            sub.disposed(by: bag)
            sub2.disposed(by: bag)
        }
    }
    
    func test_oneOff() {
        example(of: "One Off") {
            let bag = DisposeBag()
            
            let pub = PublishSubject<Int>()
            pub.onNext(1)
            
            let sub = pub
                .take(1)
                .subscribe(
                    onNext: { print($0) },
                    onCompleted: { print("completed after 1") }
                )
            
            pub.onNext(2)
            pub.onNext(3)
            pub.onNext(4)
            
            sub.disposed(by: bag)
        }
    }
    
    func test_behaviorSubject() {
        example(of: "BehaviorSubject") {
            let bag = DisposeBag()
            
            let subj = BehaviorSubject(value: "Intial value")
            
            subj
                .subscribe {
                    self.printEvent(label: "1)", event: $0)
                }
                .disposed(by: bag)
            
            subj.onNext("1")
            
            subj
                .subscribe {
                    self.printEvent(label: "2)", event: $0)
                }
                .disposed(by: bag)
            
            subj.onNext("2")
        }
    }
    
    func test_replaySubject() {
        example(of: "ReplaySubject") {
            let bag = DisposeBag()
            
            let subj = ReplaySubject<Int>.create(bufferSize: 2)
            subj.onNext(1)
            subj.onNext(2)
            subj.onNext(3)
            
            subj
                .subscribe {
                    self.printEvent(label: "1)", event: $0)
                }
                .disposed(by: bag)
            
            subj.onNext(4)
            
            subj
                .subscribe {
                    self.printEvent(label: "2)", event: $0)
                }
                .disposed(by: bag)
        }
    }
    
    func test_replaySubject_error() {
        example(of: "ReplaySubject error") {
            let bag = DisposeBag()
            
            enum MyError: Error {
                case myError
            }
            
            let subj = ReplaySubject<Int>.create(bufferSize: 2)
            subj.onNext(1)
            subj.onNext(2)
            subj.onNext(3)
            
            subj
                .subscribe {
                    self.printEvent(label: "1)", event: $0)
                }
                .disposed(by: bag)
            
            subj.onError(MyError.myError)
            
            subj
                .subscribe {
                    self.printEvent(label: "2)", event: $0)
                }
                .disposed(by: bag)
        }
    }

    private func printEvent<T: CustomStringConvertible>(label: String, event: RxSwift.Event<T>) {
        print(label, (event.element ?? event.error) ?? event)
    }
}
