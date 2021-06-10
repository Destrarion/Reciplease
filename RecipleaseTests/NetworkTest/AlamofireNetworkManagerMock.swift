//
//  AlamofireNetworkManagerMock.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 04/06/2021.
//

import Foundation
@testable import Reciplease



class AlamofireNetworkManagerSuccessMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        let recipeResponse = RecipeResponse(q: "", from: 0, to: 10, more: true, count: 5, hits: [
            Hit(recipe: Recipe(
                    uri: "",
                    label: "Pizza",
                    image: "",
                    source: "",
                    url: "",
                    shareAs: "",
                    yield: 3,
                    dietLabels: [],
                    healthLabels: [],
                    cautions: [],
                    ingredientLines: [],
                    ingredients: [],
                    calories: 4,
                    totalWeight: 4,
                    totalTime: 4,
                    cuisineType: nil,
                    mealType: nil,
                    dishType: nil,
                    totalNutrients: [:],
                    totalDaily: [:])
                )
        ])
        
        callback(.success(recipeResponse as! T))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.success(Data()))
    }
    
    
}


class AlamofireNetworkManagerFailureMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        callback(.failure(.noData))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.failure(.noData))
    }
    
    
}
