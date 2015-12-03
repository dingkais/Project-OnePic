//
//  PhotoCell.swift
//  Xcode-OnePic
//
//  Created by Kai Ding on 12/3/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var photoImageView: UIImageView!

    func setPhotoImage (photoImage: UIImage) {
        photoImageView.image = photoImage
    }

}
