//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 05/03/2021.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {

    func testUrlMultiple() {
        let urlProvider = RecipeUrlProvider()
        let url = urlProvider.createRecipeRequestUrl(ingredients: ["chicken","lemon"])
        XCTAssertEqual(url!.absoluteString, "https://api.edamam.com/search?q=chicken,lemon&app_id=24cc3abb&app_key=67d0ce73e19bd16320ed7534c84eb38f&from=0&to=50")
    }
    
    func testUrlEmpty() {
        let urlProvider = RecipeUrlProvider()
        let url = urlProvider.createRecipeRequestUrl(ingredients: [])
        XCTAssertEqual(url!.absoluteString, "https://api.edamam.com/search?q=&app_id=24cc3abb&app_key=67d0ce73e19bd16320ed7534c84eb38f&from=0&to=50")
    }
    
    func testUrlSingle() {
        let urlProvider = RecipeUrlProvider()
        let url = urlProvider.createRecipeRequestUrl(ingredients: ["chicken"])
        XCTAssertEqual(url!.absoluteString, "https://api.edamam.com/search?q=chicken&app_id=24cc3abb&app_key=67d0ce73e19bd16320ed7534c84eb38f&from=0&to=50")
    }
    
}
