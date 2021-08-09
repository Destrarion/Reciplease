import Foundation
@testable import Reciplease

class AlamofireNetworkManagerSuccessMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        let recipeResponse = RecipeResponse( hits: [
            Hit(recipe: Recipe(
                label: "Pizza",
                image: "",
                url: "",
                ingredientLines: [],
                ingredients: [],
                totalTime: 0
            )
        )])
        
        callback(.success(recipeResponse as! T))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.success(Data()))
    }
    
    func isConnectedToInternet() -> Bool {
        return true
    }
}


class AlamofireNetworkManagerFailureMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        callback(.failure(.noData))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.failure(.noData))
    }
    
    func isConnectedToInternet() -> Bool {
        return false
    }
}

class AlamofireNetworkManagerWorkingConnectionButFailureFetchMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        callback(.failure(.noData))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.failure(.noData))
    }
    
    func isConnectedToInternet() -> Bool {
        return true
    }
}



class AlamofireNetworkManagerWorkingConnectionAndEmptyFetchRecipesMock: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        let recipeResponse = RecipeResponse(hits: [])
        
        callback(.success(recipeResponse as! T))
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        callback(.failure(.noData))
    }
    
    func isConnectedToInternet() -> Bool {
        return true
    }
}

