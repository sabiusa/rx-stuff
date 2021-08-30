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
    
    func test_session() {
        example(of: "session") {
            let bag = DisposeBag()
            
            enum UserSession {
                case loggedIn, loggedOut
            }
            
            enum LoginError: Error {
                case invalidCredentials
            }
            
            let relay = BehaviorRelay(value: UserSession.loggedOut)
            relay
                .subscribe { event in
                    print(event)
                }
                .disposed(by: bag)
            
            func logInWith(username: String, password: String, completion: (Error?) -> Void) {
                guard username == "johnny@appleseed.com",
                      password == "appleseed"
                else {
                    completion(LoginError.invalidCredentials)
                    return
                }
                relay.accept(.loggedIn)
            }
            
            func logOut() {
                relay.accept(.loggedOut)
            }
            
            func performActionRequiringLoggedInUser(_ action: () -> Void) {
                if (relay.value == .loggedIn) {
                    action()
                }
            }
            
            for i in 1 ... 2 {
                let password = i % 2 == 0 ? "appleseed" : "password"
                
                logInWith(username: "johnny@appleseed.com", password: password) { error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    print("User logged in.")
                }
                
                performActionRequiringLoggedInUser {
                    print("Successfully did something only a logged in user can do.")
                }
            }
        }
    }
    
}
