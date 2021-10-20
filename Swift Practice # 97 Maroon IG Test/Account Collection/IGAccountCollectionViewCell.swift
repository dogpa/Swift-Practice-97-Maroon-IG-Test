//
//  IGAccountCollectionViewCell.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/19.
//

import UIKit

class IGAccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var AccountCoPhoto: UIImageView!
    
    @IBOutlet weak var AtPhotoWidthConstraint: NSLayoutConstraint!
    
    
    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
    override func awakeFromNib() {
    super.awakeFromNib()
    AtPhotoWidthConstraint?.constant = Self.width
        
        
    }
}
