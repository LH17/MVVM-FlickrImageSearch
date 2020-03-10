//
//  ImageCollectionViewCell.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/11/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    var placeholder: UIImage?
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    var cellViewModel: PhotoListViewModelCell? {
        didSet {
            DispatchQueue.main.async {
                
            }
            descLabel.text = cellViewModel?.descText
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        placeholder = UIImage(named: "")
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
