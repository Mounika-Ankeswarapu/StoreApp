//
//  CartItemCount.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import Foundation

class CartItem: Codable {
    var product: ProductDataModel
    var quantity: Int

    init(product: ProductDataModel, quantity: Int = 1) {
        self.product = product
        self.quantity = quantity
    }

    var totalPrice: Double {
        return (product.price ?? 0) * Double(quantity)
    }
}
