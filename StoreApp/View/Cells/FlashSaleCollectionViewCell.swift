//
//  FlashSaleCollectionViewCell.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 14/04/25.
//

import UIKit

class FlashSaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var favoriteButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = 12
    }

    @IBAction func favBtnTapped(_ sender: UIButton) {
            favoriteButtonTapped?()
        }
}
