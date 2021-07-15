

import Foundation
import Alamofire



protocol AlamofireSessionProtocol {
    func fetchDecodable<T: Decodable>(url: URL, completion: @escaping (DataResponse<T, AFError>) -> Void)
    func fetchJsonData(url: URL, completion: @escaping (DataResponse<Any, AFError>) -> Void)
}


/// Class for using AlamoFire. For fetching Data and JsonData
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
