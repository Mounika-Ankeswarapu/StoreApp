//
//  CheckoutViewController.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import UIKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var productCartView: UIView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var productListTV: UITableView!
    
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var cartCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        registerCell()
        CartManager.shared.loadCart()
        productListTV.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CartManager.shared.loadCart()
        productListTV.reloadData()
        updateCartCountLabel()
    }

    func updateUI(){
        topView.layer.cornerRadius = 22
        productCartView.layer.cornerRadius = 22
        addressView.layer.cornerRadius = 8
        checkoutBtn.layer.cornerRadius = 10
        cartCountLbl.layer.cornerRadius = cartCountLbl.frame.height / 2
    }

    func registerCell(){
        
        productListTV.delegate = self
        productListTV.dataSource = self
        productListTV.register(UINib(nibName: "cartProductTableViewCell", bundle: nil), forCellReuseIdentifier: "cartProductTableViewCell")
    }
    
    @IBAction func checkoutBtnClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Thank You!", message: "Your order has been placed successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                CartManager.shared.clearCart()
                self.productListTV.reloadData()
                self.updateCartCountLabel()
            }))
            present(alert, animated: true, completion: nil)
    }
    
    func updateCartCountLabel() {
        let totalCount = CartManager.shared.cartItems.reduce(0) { $0 + $1.quantity }
        cartCountLbl.text = "\(totalCount)"
        cartCountLbl.isHidden = totalCount == 0
        
    }

    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productListTV.dequeueReusableCell(withIdentifier: "cartProductTableViewCell", for: indexPath) as! cartProductTableViewCell
        let cartItem = CartManager.shared.cartItems[indexPath.row]
        
        cell.productNameLbl.text = cartItem.product.title
        cell.priceLbl.text = "$\(cartItem.totalPrice)"
        cell.productCountNumLbl.text = "\(cartItem.quantity)"

        // Load image
        if let imageUrl = cartItem.product.image, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.productImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        cell.increaseBtn.isEnabled = cartItem.quantity < 10
        cell.decreaseBtn.isEnabled = cartItem.quantity > 0


        // Assign button actions with closures
        cell.onIncreaseTapped = {
            CartManager.shared.updateQuantity(for: cartItem.product.id ?? 0, increase: true)
            self.productListTV.reloadData()
            self.updateCartCountLabel()
        }
        cell.onDecreaseTapped = {
            CartManager.shared.updateQuantity(for: cartItem.product.id ?? 0, increase: false)
            self.productListTV.reloadData()
            self.updateCartCountLabel()
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
