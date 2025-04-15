//
//  ProductDataModel.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import Foundation

struct ProductDataModel : Codable {
    let id : Int?
    let title : String?
    let price : Double?
    let description : String?
    let category : String?
    let image : String?
    let rating : Rating?
}

struct Rating : Codable {
    let rate : Double?
    let count : Int?
}

struct Category {
    let name: String
    let imageName: String
}
