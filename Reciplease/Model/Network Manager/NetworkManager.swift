

import Foundation
import Alamofire

protocol AlamofireSessionProtocol {
    func fetchDecodable<T: Decodable>(url: URL, completion: @escaping (DataResponse<T, AFError>) -> Void)
    func fetchJsonData(url: URL, completion: @escaping (DataResponse<Any, AFError>) -> Void)
}


class AlamofireSession: AlamofireSessionProtocol {
    
    func fetchDecodable<T: Decodable>(url: URL, completion: @escaping (DataResponse<T, AFError>) -> Void) {
        AF.request(url).responseDecodable() { (response: DataResponse<T, AFError>) in
            completion(response)
        }
    }
    
    func fetchJsonData(url: URL, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
        AF.request(url).responseJSON { (dataResponse) in
            completion(dataResponse)
        }
    }
    
}


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
            data: nil,
            metrics: nil,
            serializationDuration: 0.5,
            result: Result<Any, AFError>.success(Data())
        )
        
        completion(dataResponse)
    }
}






protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void)
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void)
}

class AlamofireNetworkManager: NetworkManagerProtocol {
    
    init(alamofireSession: AlamofireSessionProtocol = AlamofireSession()) {
        self.alamofireSession = alamofireSession
    }
    
    private let alamofireSession: AlamofireSessionProtocol
    
    
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        alamofireSession.fetchDecodable(url: url) { (response: DataResponse<T, AFError>) in
            
            switch response.result {
            case .success(let decoddedData):
                callback(.success(decoddedData))
                return
            case .failure(_):
                callback(.failure(.failedToDecodeJsonToCodableStruct))
                return
            }
            
        }
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        alamofireSession.fetchJsonData(url: url) { (dataResponse) in
            
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            
            callback(.success(data))
            
        }
    }
}
