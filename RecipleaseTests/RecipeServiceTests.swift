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
            case .success :
                XCTAssertEqual(recipeService.searchedRecipes.first!.label, "Pizza")
            }
        }
    }
    
  
    // MARK: Test RecipeServiceError
    func test_givenBadUrlProviderl_whenGetRecipes_thenErrorCouldNotCreateUrl() {
        let recipeUrlProviderMock = RecipeUrlProviderMock()
        let recipeService = RecipeService(recipeUrlProvider: recipeUrlProviderMock)
        
        let expectation = expectation(description: "Waiting for queue change")
        
        recipeService.getRecipes(ingredients: ["✈︎.com"]) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, RecipeServiceError.couldNotCreateURL)
                
            case .success:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    func test_givenRecipeWithInvalidRecipeImageUrl_whenGetImageRecipe_thenErrorCouldNotCreateUrl() {
        let recipeService = RecipeService()
        
        let recipe = Recipe(
            label: "Pizza",
            image: "",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 4
        )
        
        let expectation = expectation(description: "Waiting for queue change")
        
        recipeService.getImageRecipe(recipe: recipe) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, RecipeServiceError.couldNotCreateURL)
            case .success:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    
    func test_givenValidRecipeUrlWithFailingNetworkManager_whenGetImageRecipe_thenErrorFaildToGetRecipeImage() {
        let networkManagerMock = AlamofireNetworkManagerFailureMock()
        let recipeService = RecipeService(networkManager: networkManagerMock)
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 4
        )
        
        let expectation = expectation(description: "Waiting for queue change")
        
        recipeService.getImageRecipe(recipe: recipe) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, RecipeServiceError.failedToGetRecipeImage)
            case .success:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_givenValidRecipeUrlWithSuccessNetworkManager_whenGetImageRecipe_thenGetRecipeDataSuccessfully() {
        let networkManagerMock = AlamofireNetworkManagerSuccessMock()
        let recipeService = RecipeService(networkManager: networkManagerMock)
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 4
        )
        
        let expectation = expectation(description: "Waiting for queue change")
        
        recipeService.getImageRecipe(recipe: recipe) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let data):
                XCTAssertNotNil(data)
            }
            expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    func test_givenRecipeWithCookingTotalTime2_whenFormat_thenGet2m() {
        
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 2
        )
        
        XCTAssertEqual(recipe.formatCookingTimeToString(), "2m")
        
    }
    
    func test_givenRecipeWithCookingTotalTime2point2_whenFormat_thenGet2m() {
        
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 2.2
        )
        
        XCTAssertEqual(recipe.formatCookingTimeToString(), "2m")
        
    }
    
    func test_givenRecipeWithCookingTotalTime0_whenFormat_thenGetDefaultDashes() {
        
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 0
        )
        
        XCTAssertEqual(recipe.formatCookingTimeToString(), "--")
        
    }
    
    func test_givenRecipeWithCookingTotalTime60_whenFormat_thenGet1h() {
        
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 60
        )
        
        XCTAssertEqual(recipe.formatCookingTimeToString(), "1h")
        
    }

    
    func test_givenRecipeWithCookingTotalTime10000_whenFormat_thenGet1h() {
        
        
        let recipe = Recipe(
            label: "Pizza",
            image: "www.google.com",
            url: "",
            ingredientLines: [],
            ingredients: [],
            totalTime: 10000
        )
        
        XCTAssertEqual(recipe.formatCookingTimeToString(), "6d 23h")
        
    }

}
