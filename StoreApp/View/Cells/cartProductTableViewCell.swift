//
//  cartProductTableViewCell.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import UIKit

class cartProductTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var imageBgView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var productCountNumLbl: UILabel!
    @IBOutlet weak var increaseBtn: UIButton!
    
    var onIncreaseTapped: (() -> Void)?
    var onDecreaseTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageBgView.layer.cornerRadius = 8
        
        increaseBtn.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        decreaseBtn.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
    }
    
    @objc func increaseTapped() {
        onIncreaseTapped?()
    }
    
    @objc func decreaseTapped() {
        onDecreaseTapped?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
