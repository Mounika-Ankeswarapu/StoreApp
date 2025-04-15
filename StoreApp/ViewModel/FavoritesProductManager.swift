//
//  FavoritesProductManager.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}

    var favoriteProducts: [ProductDataModel] = []
}
