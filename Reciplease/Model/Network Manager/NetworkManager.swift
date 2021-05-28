

import Foundation
import Alamofire


protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void)
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void)
}

class AlamofireNetworkManager: NetworkManagerProtocol {
    func fetch<T>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) where T : Decodable {
        AF.request(url).responseDecodable(completionHandler: { (response: DataResponse<T, AFError>) in
            
            switch response.result {
            case .success(let decoddedData):
                callback(.success(decoddedData))
                return
            case .failure:
                callback(.failure(.failedToDecodeJsonToCodableStruct))
                return
            }
            
        })
    }
    
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        AF.request(url).responseJSON { (dataResponse) in
            
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            
            callback(.success(data))
            
        }
    }
}
