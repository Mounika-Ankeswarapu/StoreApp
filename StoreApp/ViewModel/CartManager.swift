//
//  CartManager.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private let cartKey = "cart_items"

    private init() {
        loadCart()
    }

    var cartItems: [CartItem] = []

    func addToCart(_ product: ProductDataModel) {
        if let existingItem = cartItems.first(where: { $0.product.id == product.id }) {
            if existingItem.quantity < 10 {
                existingItem.quantity += 1
            }
        } else {
            let newItem = CartItem(product: product, quantity: 1)
            cartItems.append(newItem)
        }
        saveCart()
    }


    func updateQuantity(for productId: Int, increase: Bool) {
        if let index = cartItems.firstIndex(where: { $0.product.id == productId }) {
            var item = cartItems[index]

            if increase {
                if item.quantity < 10 {
                    item.quantity += 1
                }
            } else {
                item.quantity -= 1
                if item.quantity <= 0 {
                    cartItems.remove(at: index)
                } else {
                    cartItems[index] = item
                }
            }

            saveCart()
        }
    }


    func removeItem(at index: Int) {
        cartItems.remove(at: index)
        saveCart()
    }


    func saveCart() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cartItems) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }

    func loadCart() {
        if let savedCart = UserDefaults.standard.data(forKey: cartKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([CartItem].self, from: savedCart) {
                cartItems = decoded
            }
        }
    }

    func clearCart() {
        cartItems.removeAll()
        UserDefaults.standard.removeObject(forKey: cartKey)
    }
}
