
// Curently URLSession, planned to change to AlamoFire later

import Foundation

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void)
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
//MARK: - Public
    
    // Fuction to call API, to receive text data.
    func fetch<T: Decodable>(url: URL, callback: @escaping (Result<T, NetworkManagerError>) -> Void) {
        
        task = session.dataTask(with: url) { (data, response, error) in
           
                
                guard error == nil else {
                    callback(.failure(.unknownError))
                    return
                }
                
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                else {
                    callback(.failure(.responseCodeIsInvalid))
                    return
                }
                
                guard let data = data else {
                    callback(.failure(.noData))
                    return
                }
                
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    callback(.failure(.failedToDecodeJsonToCodableStruct))
                    return
                }
                
                callback(.success(decodedData))
            
        }
        task?.resume()
        
        
       
    }
    
    
    
    // Function to call API for image. Used in WeatherService to receive Image of the Weather.
    func fetchData(url: URL, callback: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        
        task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                callback(.failure(.unknownError))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                callback(.failure(.responseCodeIsInvalid))
                return
            }
            
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            
            callback(.success(data))
            
        }
        task?.resume()
    }
    
    //MARK: - Private
    private let session: URLSession
    
    private var task: URLSessionDataTask?
    
   
}

