//
//  RecipeServiceTests.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 04/06/2021.
//


import XCTest
@testable import Reciplease

class RecipeServiceTests: XCTestCase {
    

    func test_failure() {
        let networkManagerMock = AlamofireNetworkManagerFailureMock()
        let recipeService = RecipeService(networkManager: networkManagerMock)


        recipeService.getRecipes(ingredients: ["beef"]) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .failedToGetRecipes)
            case .success: XCTFail()
            }
        }



    }
    
    func test_success() {
        let networkManagerMock = AlamofireNetworkManagerSuccessMock()
        let recipeService = RecipeService(networkManager: networkManagerMock)


        recipeService.getRecipes(ingredients: ["beef"]) { result in
            switch result {
            case .failure: XCTFail()
            case .success:
                XCTAssertEqual(recipeService.recipes.first!.label, "Pizza")
            }
        }



    }


}
