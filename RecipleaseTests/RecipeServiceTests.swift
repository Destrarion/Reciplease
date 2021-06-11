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
    
  
    // MARK: Test RecipeServiceError
    #warning("not understood how to set error in the URL")
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
                uri: "",
                label: "Pizza",
                image: " ",
                source: "",
                url: "",
                shareAs: "",
                yield: 3,
                dietLabels: [],
                healthLabels: [],
                cautions: [],
                ingredientLines: [],
                ingredients: [],
                calories: 4,
                totalWeight: 4,
                totalTime: 4,
                cuisineType: nil,
                mealType: nil,
                dishType: nil,
                totalNutrients: [:],
                totalDaily: [:]
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
                uri: "",
                label: "Pizza",
                image: "test.com",
                source: "",
                url: "",
                shareAs: "",
                yield: 3,
                dietLabels: [],
                healthLabels: [],
                cautions: [],
                ingredientLines: [],
                ingredients: [],
                calories: 4,
                totalWeight: 4,
                totalTime: 4,
                cuisineType: nil,
                mealType: nil,
                dishType: nil,
                totalNutrients: [:],
                totalDaily: [:]
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
                uri: "",
                label: "Pizza",
                image: "test.com",
                source: "",
                url: "",
                shareAs: "",
                yield: 3,
                dietLabels: [],
                healthLabels: [],
                cautions: [],
                ingredientLines: [],
                ingredients: [],
                calories: 4,
                totalWeight: 4,
                totalTime: 4,
                cuisineType: nil,
                mealType: nil,
                dishType: nil,
                totalNutrients: [:],
                totalDaily: [:]
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

}
