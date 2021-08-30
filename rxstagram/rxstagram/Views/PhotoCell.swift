//
//  PhotoCell.swift
//  rxstagram
//
//  Created by Saba Khutsishvili on 30.08.21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    var representedAssetIdentifier: String!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func flash() {
        imageView.alpha = 0
        setNeedsDisplay()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.imageView.alpha = 1
        })
    }
    
}
