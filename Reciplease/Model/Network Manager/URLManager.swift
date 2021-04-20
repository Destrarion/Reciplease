//
//  URLManager.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 15/04/2021.
//

import Foundation

func createWeatherImageCodeRequestUrl(imageCode: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = ""
    urlComponents.path = "/img/wn/\(imageCode)@2x.png"
    
    return urlComponents.url
}
//https://www.edamam.com/web-img/d37/d376c145f2a59befa7738a2c35caab31.jpg
