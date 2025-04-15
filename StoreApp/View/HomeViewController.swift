//
//  HomeViewController.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 14/04/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categorySeeAllBtn: UIButton!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var flashSaleView: UIView!
    @IBOutlet weak var flashSaleSeeAllBtn: UIButton!
    @IBOutlet weak var flashSaleCV: UICollectionView!
    
    var productsData: [ProductDataModel] = []

    let categories: [Category] = [
        Category(name: "Clothing", imageName: "laundry"),
        Category(name: "Electronics", imageName: "device"),
        Category(name: "Jwellery", imageName: "jewelry"),
        Category(name: "Toys", imageName: "storage-box"),
        Category(name: "Books", imageName: "stack-of-books")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        updateUI()
        fetchData()
    }
    
    func updateUI(){
        topView.layer.cornerRadius = 20
        categoryView.layer.cornerRadius = 20
        flashSaleView.layer.cornerRadius = 20
        
    }

    func registerCells(){
        categoryCV.delegate = self
        categoryCV.dataSource = self
        categoryCV.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        flashSaleCV.delegate = self
        flashSaleCV.dataSource = self
        flashSaleCV.register(UINib(nibName: "FlashSaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FlashSaleCollectionViewCell")
        
    }
   

}

// extension for handling collectionVIews

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == categoryCV {
            return categories.count
        }else {
            return productsData.count
        }
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV{
            let cell = categoryCV.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            let category = categories[indexPath.row]
            cell.categoryNameLbl.text = category.name
            cell.Categoryimage.image = UIImage(named: category.imageName)
            return cell
        }else{
            let cell = flashSaleCV.dequeueReusableCell(withReuseIdentifier: "FlashSaleCollectionViewCell", for: indexPath) as! FlashSaleCollectionViewCell
            //handling fav button
            cell.favoriteButtonTapped = { [weak self] in
                guard let self = self else { return }
                let product = productsData[indexPath.row]
                if !FavoritesManager.shared.favoriteProducts.contains(where: { $0.id == product.id }) {
                    FavoritesManager.shared.favoriteProducts.append(product)
                    cell.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    // If you want to allow removing from favorites:
                    FavoritesManager.shared.favoriteProducts.removeAll { $0.id == product.id }
                    cell.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }

            cell.imgView.layer.cornerRadius = 12
            if !productsData.isEmpty {
                let product = productsData[indexPath.row]
                cell.priceLbl.text = "$\(product.price ?? 0)"
                cell.productNameLbl.text = product.title
                // Load image from URL
                if let imageUrl = product.image, let url = URL(string: imageUrl) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
                            DispatchQueue.main.async {
                                cell.productImg.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            } else {
                //cell.priceLbl.text = "$120"
            }
           
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCV {
            return CGSize(width: 250, height: 120)
        }else{
            let size = (collectionView.frame.size.width - 10)/2
            return CGSize(width: size, height:360)
        }
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let productVC = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        let selectedProduct = productsData[indexPath.row]
        productVC.productId = selectedProduct.id
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}

// using this extension for handling networkcalls
extension HomeViewController{
    func fetchData() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.productsData = data
                    self?.flashSaleCV.reloadData()
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    
                }
            }
        }
    }

}
