//
//  ProductDetailsViewController.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var productImageDisplayCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var ratingVIew: UIView!
    @IBOutlet weak var ratingNumLbl: UILabel!
    @IBOutlet weak var reviewCountNumLbl: UILabel!
    @IBOutlet weak var productLikeView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    
    var product: ProductDataModel?
    var productId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        cellRegister()
        if let id = productId {
            fetchProductById(id)
        }
        // Do any additional setup after loading the view.
    }
    func updateUI(){
        detailsView.layer.cornerRadius = 22
        
        ratingVIew.layer.cornerRadius = 8
        ratingVIew.layer.borderWidth = 0.8
        ratingVIew.layer.borderColor = UIColor.lightGray.cgColor
        
        productLikeView.layer.cornerRadius = 8
        productLikeView.layer.borderWidth = 0.8
        productLikeView.layer.borderColor = UIColor.lightGray.cgColor
        
        questionView.layer.cornerRadius = 8
        questionView.layer.borderWidth = 0.8
        questionView.layer.borderColor = UIColor.lightGray.cgColor
        
        priceView.layer.cornerRadius = 8
        cartBtn.layer.cornerRadius = 8
        
        guard let product = product else { return }
        
        productNameLbl.text = product.title
        priceLbl.text = "$\(product.price ?? 0)"
        descriptionLbl.text = product.description
        ratingNumLbl.text = "\(product.rating?.rate ?? 0.0)"
        reviewCountNumLbl.text = "\(product.rating?.count ?? 0) Reviews"
    }
    
    func cellRegister(){
        productImageDisplayCV.delegate = self
        productImageDisplayCV.dataSource = self
        productImageDisplayCV.register(UINib(nibName: "ProductImageDisplayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageDisplayCollectionViewCell")
    }

    @IBAction func addtoCartBtnAction(_ sender: UIButton) {
        
        guard let product = product else { return }
        CartManager.shared.addToCart(product)

//           let alert = UIAlertController(title: "Added to Cart", message: "Product has been added!", preferredStyle: .alert)
//           alert.addAction(UIAlertAction(title: "OK", style: .default))
//           present(alert, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let checkoutVC = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        navigationController?.pushViewController(checkoutVC, animated: true)

    }
    @IBAction func topBackBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// extension for handling collectionVIews

extension ProductDetailsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = productImageDisplayCV.dequeueReusableCell(withReuseIdentifier: "ProductImageDisplayCollectionViewCell", for: indexPath) as! ProductImageDisplayCollectionViewCell
        
        
        if let imageUrlString = product?.image, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        
                        cell.productImages.image = UIImage(data: data)
                        
                    }
                }
            }.resume()
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    
}

//exxtension for network call
extension ProductDetailsViewController{
    func fetchProductById(_ id: Int) {
        guard let url = URL(string: "https://fakestoreapi.com/products/\(id)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching product: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let product = try decoder.decode(ProductDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.product = product
                    self.updateUI()
                    self.productImageDisplayCV.reloadData()
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }
    
}
