//
//  ViewController.swift
//  rx-test
//
//  Created by Saba Khutsishvili on 02.09.21.
//

import UIKit
import RxSwift
import RxRelay

class Obj {
    
    var value = 1
    
    func test() {
        testMem {
            print(self.value)
        }
    }
    
    func testMem(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            self.value += 1
            completion()
        }
    }
    
    deinit {
        print("deinit")
    }
}

class ViewController: UIViewController {
    
    let relay = BehaviorRelay(value: 0)
    let bag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        testMem()
    }
    
    func testRelay() {
        relay
            .take(2)
            .subscribe(
                onNext: { val in
                    print(val)
                },
                onCompleted: { [unowned self] in
                    print("Completed", self.relay.value)
                }
            )
            .disposed(by: bag)
        
        doInBG {}
    }
    
    func testMem() {
        var obj: Obj? = Obj()
        print(obj?.value)
        obj?.test()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            obj = nil
        }
    }

    func doInBG(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            self.relay.accept(1)
//            completion()
        }
    }
    
    
}

