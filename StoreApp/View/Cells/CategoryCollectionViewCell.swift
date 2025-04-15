//
//  CategoryCollectionViewCell.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 14/04/25.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgBgView: UIView!
    @IBOutlet weak var Categoryimage: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBgView.layer.cornerRadius = imgBgView.frame.height/2 
    }

}
