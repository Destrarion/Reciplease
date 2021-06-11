//
//  AlamofireSessionMocks.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 04/06/2021.
//

import Foundation
import Alamofire
@testable import Reciplease


class AlamofireSessionFailureMock: AlamofireSessionProtocol {
    func fetchDecodable<T: Decodable>(url: URL, completion: @escaping (DataResponse<T, AFError>) -> Void) {
        
        //let recipeResponser = RecipeResponse(q: "", from: 0, to: 10, more: true, count: 5, hits: [])
        
        let dataResponse = DataResponse(
            request: nil,
            response: nil,
            data: nil,
            metrics: nil,
            serializationDuration: 0.5,
            result: Result<T, AFError>.failure(AFError.explicitlyCancelled)
        )
        
        completion(dataResponse)
    }
    
    
    func fetchJsonData(url: URL, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
        
        let dataResponse = DataResponse(
            request: nil,
            response: nil,
            data: nil,
            metrics: nil,
            serializationDuration: 0.5,
            result: Result<Any, AFError>.failure(AFError.explicitlyCancelled)
        )
        
        completion(dataResponse)
    }
}



class AlamofireSessionSuccessMock: AlamofireSessionProtocol {
    func fetchDecodable<T: Decodable>(url: URL, completion: @escaping (DataResponse<T, AFError>) -> Void) {
        
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
        
        let dataResponse = DataResponse(
            request: nil,
            response: nil,
            data: nil,
            metrics: nil,
            serializationDuration: 0.5,
            result: Result<T, AFError>.success(recipeResponse as! T)
        )
        
        completion(dataResponse)
    }
    
    
    func fetchJsonData(url: URL, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
        
        let dataResponse = DataResponse(
            request: nil,
            response: nil,
            data: Data(),
            metrics: nil,
            serializationDuration: 0.5,
            result: Result<Any, AFError>.success(Data())
        )
        
        completion(dataResponse)
    }
}

