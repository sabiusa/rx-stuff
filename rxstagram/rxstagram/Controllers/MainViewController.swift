//
//  MainViewController.swift
//  rxstagram
//
//  Created by Saba Khutsishvili on 30.08.21.
//

import UIKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    private let bag = DisposeBag()
    private let images = BehaviorRelay(value: [UIImage]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images
            .subscribe(onNext: { [weak imagePreview] photos in
                guard let preview = imagePreview else { return }
                
                preview.image = photos.collage(size: preview.frame.size)
            })
            .disposed(by: bag)
    }
    
    @IBAction func actionClear() {
        images.accept([])
    }
    
    @IBAction func actionSave() {
        
    }
    
    @IBAction func actionAdd() {
        let image = UIImage(named: "IMG_1907")!
        let newImages = images.value + [image]
        images.accept(newImages)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        let alert = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Close",
                style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                    
                }
            )
        )
        
        present(alert, animated: true, completion: nil)
    }
    
}
