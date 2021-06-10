

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
