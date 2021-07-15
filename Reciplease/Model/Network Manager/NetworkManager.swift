import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void)
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void)
}

class AlamofireNetworkManager: NetworkManagerProtocol {
    
    init(alamofireSession: AlamofireSessionProtocol = AlamofireSession()) {
        self.alamofireSession = alamofireSession
    }
    
    private let alamofireSession: AlamofireSessionProtocol
    
    /// Function for getting recipe from the API of edaman with the ingredients in the Fridge.
    /// Called in RecipeService.
    /// - Parameters:
    ///   - url: URL created from RecipeUrlProvider with the ingredients
    ///   - callback: Success : Recipe / Failure : Failed to decode Json to Codable Struct
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
    
    /// Fetch data with Alamofire on the Url to get image for the recipe.
    ///
    /// Called in RecipeService in the function getImageRecipe.
    /// - Parameters:
    ///   - url: Url of the recipe in Recipe.image
    ///   - callback: Callback the data if success. Else error with .noData.
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
