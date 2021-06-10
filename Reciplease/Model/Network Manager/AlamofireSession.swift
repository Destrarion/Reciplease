//
//  AlamofireSession.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 04/06/2021.
//

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
