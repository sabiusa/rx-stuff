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
            .dispose()
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
            .dispose()
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
            .dispose()
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
            .dispose()
        }
    }
    
    func test_dispose() {
        example(of: "dispose") {
            let obs = Observable.of("A", "B", "C")
            let subs = obs.subscribe { event in
                print(event)
            }
            subs.dispose()
        }
    }
    
    func test_disposeBag() {
        example(of: "DisposeBag") {
            let bag = DisposeBag()
            
            Observable.of("a", "b", "c")
                .subscribe { event in
                    print(event)
                }
                .disposed(by: bag)
        }
    }
    
    func test_create() {
        example(of: "create") {
            let bag = DisposeBag()
            
            Observable<String>.create { obs in
                obs.onNext("1")
                
                obs.onCompleted()
                
                obs.onNext("?")
                
                return Disposables.create()
            }
            .subscribe(
                onNext: { print($0) },
                onError: { print($0) },
                onCompleted: { print("completed") },
                onDisposed: { print("disposed") }
            )
            .disposed(by: bag)
        }
    }

    func test_error() {
        example(of: "error") {
            let bag = DisposeBag()
            
            enum MyError: Error {
                case myError
            }
            
            Observable<String>.create { obs in
                obs.onNext("1")
                
                obs.onError(MyError.myError)
                
                obs.onNext("?")
                
                return Disposables.create()
            }
            .subscribe(
                onNext: { print($0) },
                onError: { print($0) },
                onCompleted: { print("completed") },
                onDisposed: { print("disposed") }
            )
            .disposed(by: bag)
        }
    }
    
    func test_defer() {
        example(of: "defer") {
            let bag = DisposeBag()
            
            var flag = false
            
            let factory: Observable<Int> = Observable.deferred {
                flag.toggle()
                
                if flag {
                    return Observable.of(1, 2, 3)
                } else {
                    return Observable.of(4, 5, 6)
                }
            }
            
            for _ in 0 ... 3 {
                factory.subscribe(onNext: {
                    print($0, terminator: " ")
                })
                .disposed(by: bag)
                
                print()
            }
        }
    }
    
    func test_trait_single() {
        example(of: "Single") {
            let bag = DisposeBag()
            
            enum FileError: Error {
                case notFound
                case unreadable
                case encodingFailed
            }
            
            func loadText(from fileName: String) -> Single<String> {
                return Single.create { single in
                    let disp = Disposables.create()
                    
                    let bundle = Bundle(for: Helper.self)
                    
                    guard let path = bundle.path(forResource: fileName, ofType: "txt")
                    else {
                        single(.error(FileError.notFound))
                        return disp
                    }
                    
                    guard let data = FileManager.default.contents(atPath: path)
                    else {
                        single(.error(FileError.unreadable))
                        return disp
                    }
                    
                    guard let content = String(data: data, encoding: .utf8)
                    else {
                        single(.error(FileError.encodingFailed))
                        return disp
                    }
                    
                    single(.success(content))
                    return disp
                }
            }
            
            loadText(from: "text")
                .subscribe { result in
                    switch result {
                    case .success(let content):
                        print("File: ")
                        print(content)
                    case .error(let error):
                        print("Error: ", error)
                    }
                }
                .disposed(by: bag)
        }
    }
    
    func test_do() {
        example(of: "do") {
            let bag = DisposeBag()
            
            Observable<Void>.never()
                .do(onSubscribe: {
                    print("Subscribed")
                })
                .subscribe(
                    onNext: { element in
                        print(element)
                    },
                    onCompleted: {
                        print("Completed")
                    },
                    onDisposed: {
                        print("Disposed")
                    }
                )
                .disposed(by: bag)
        }
    }
    
    func test_debug() {
        example(of: "debug") {
            let bag = DisposeBag()
            
            Observable<Void>.never()
                .debug("test-debug", trimOutput: false)
                .subscribe(onDisposed: { print("Disposed") })
                .disposed(by: bag)
        }
    }
    
}
