//
//  FavoritesViewController.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favCountLbl: UILabel!
    
    @IBOutlet weak var favProductCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favCountLbl.text = "\(FavoritesManager.shared.favoriteProducts.count)"
        favProductCV.reloadData()
    }

    
    func registerCell(){
        favProductCV.delegate = self
        favProductCV.dataSource = self
        favProductCV.register(UINib(nibName: "FlashSaleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FlashSaleCollectionViewCell")
    }

}

extension FavoritesViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return FavoritesManager.shared.favoriteProducts.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = favProductCV.dequeueReusableCell(withReuseIdentifier: "FlashSaleCollectionViewCell", for: indexPath) as! FlashSaleCollectionViewCell
            let product = FavoritesManager.shared.favoriteProducts[indexPath.row]
            
            cell.productNameLbl.text = product.title
            cell.priceLbl.text = "$\(product.price ?? 0)"
            if let imageUrl = product.image, let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.productImg.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }

            return cell
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.size.width - 10)/2
        return CGSize(width: size, height:360)
        
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
       // let selectedProduct = productsData[indexPath.row]
       // productVC.productId = selectedProduct.id
        self.navigationController?.pushViewController(productVC, animated: true)
    }
}
