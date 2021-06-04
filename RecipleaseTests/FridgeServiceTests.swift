//
//  FridgeServiceTests.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 02/04/2021.
//

import XCTest
@testable import Reciplease

class FridgeServiceTests: XCTestCase {
    
    
    func test_givenNewEmptyIngredient_whenAddIngredient_thenGetIngredientEmptyFailure() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsEmpty)
        case .success: XCTFail()
        }
        
    }
    
    
    
    func test_givenNewIngredient_whenAddIngredient_thenGetIngredientIsAdded() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "tomato") {
        case .failure: XCTFail()
        case .success: XCTAssertEqual(fridgeService.ingredients.first!, "tomato")
        }
    }
    
    
    // MARK: Whitespaces
    
    func test_givenNewIngredientWithEmptySpacesAtTheEnd_whenAddIngredient_thenIngredientIsAddedWithoutSpaces() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "tomato       ") {
        case .failure: XCTFail()
        case .success: XCTAssertEqual(fridgeService.ingredients.first!, "tomato")
        }
    }
    
    
    func test_givenNewIngredientWithEmptySpacesAtTheBeginning_wenAddIngredient_thenIngredientIsAddedWithoutSpaces() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "      tomato") {
        case .failure: XCTFail()
        case .success: XCTAssertEqual(fridgeService.ingredients.first!, "tomato")
        }
    }
    
    
    
    func test_givenNewIngredientWithEmptySpacesAtTheBeginningAndEnd_wenAddIngredient_thenIngredientIsAddedWithoutSpaces() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "      tomato      ") {
        case .failure: XCTFail()
        case .success: XCTAssertEqual(fridgeService.ingredients.first!, "tomato")
        }
    }
    
    
    
    // MARK: Already added ingredient
    
    func test_givenAlreadyAddedIngredient_whenAddIngredient_thenGetIngredientIsAlreadyAddedFAilure() {
        let fridgeService = FridgeService()
        
        _ = fridgeService.add(ingredient: "tomato")
        
        switch fridgeService.add(ingredient: "tomato") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsAlreadyAdded)
        case .success: XCTFail()
        }
        
    }
    
    func test_givenAlreadyAddedIngredientCapitalized_whenAddIngredient_thenGetIngredientIsAlreadyAddedFAilure() {
        let fridgeService = FridgeService()
        
        _ = fridgeService.add(ingredient: "Tomato")
        
        switch fridgeService.add(ingredient: "tomato") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsAlreadyAdded)
        case .success: XCTFail()
        }
        
    }
    
    func test_givenAlreadyAddedIngredientNotCapitalized_whenAddIngredientCapitalized_thenGetIngredientIsAlreadyAddedFAilure() {
        let fridgeService = FridgeService()
        
        _ = fridgeService.add(ingredient: "tomato")
        
        switch fridgeService.add(ingredient: "Tomato") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsAlreadyAdded)
        case .success: XCTFail()
        }
        
    }
    
    func test_givenAlreadyAddedIngredientWithBeginEmptzSpaces_whenAddIngredientCapitalized_thenGetIngredientIsAlreadyAddedFAilure() {
        let fridgeService = FridgeService()
        
        _ = fridgeService.add(ingredient: "   tomato")
        switch fridgeService.add(ingredient: "tomato") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsAlreadyAdded)
        case .success: XCTFail()
        }
        
    }
    
    
    // MARK: Special character
    
    
    func test_givenNewIngredientWithSpecialCharacters_whenAddIngredientCapitalized_thenGetIngredientIsAlreadyAddedFAilure() {
        let fridgeService = FridgeService()
        
        switch fridgeService.add(ingredient: "tomato@@ƒ¢¡ø[[][]Ò") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientContainsSpecialCharacter)
        case .success: XCTFail()
        }
        
    }
    func test_givenUnicodeEmojiIngredient_whenAddIngredientEmoji_thenUnicodeEmojiRemovedSuccess() {
        let fridgeService = FridgeService()
        
        
        // 🍅
        // tomate
        // Unicode: U+1F345, UTF-8: F0 9F 8D 85
        switch fridgeService.add(ingredient: "tomato 🍅") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientContainsSpecialCharacter)
        case .success: XCTFail()
        }
        
    }
    
    
    // MARK: Spaces and words
    func test_givenIngredients_whenRemoveAllIngredient_thenIngredientEmpty(){
        let fridgeservice = FridgeService()
        
        fridgeservice.ingredients = ["potatoes", "lettuce", "strawberry"]
        
        fridgeservice.removeIngredients()
        
        XCTAssertEqual(fridgeservice.ingredients, [])
        
    }
    
    func test_givenEmptyIngredient_whenAddingIngredient_thenErrorFailedToAddIngredientIsEmpty() {
        let fridgeservice = FridgeService()
        
        switch fridgeservice.add(ingredient: "") {
        case .failure(let error): XCTAssertEqual(error, .failedToAddIngredientIsEmpty)
        case .success: (XCTFail())
        }
        
    }
    
    func test_givenThreeIngredients_whenRemove2ndIngredient_thenRemove2ndIngredient() {
        let fridgeservice = FridgeService()
        fridgeservice.ingredients = ["beef","lemon","potatoes"]
        
        fridgeservice.removeIngredient(at: 1)
        
        XCTAssertEqual("potatoes", fridgeservice.ingredients[1])
    }
    
    func test_givenIngredientWithWhiteSpace_WhenAddingIngredient_thenIngredientAdded() {
        let fridgeservice = FridgeService()
        
        switch fridgeservice.add(ingredient: "Smashed Potatoes"){
        case .failure(let error) :XCTFail(error.errorDescription)
        case .success(): XCTAssertEqual(fridgeservice.ingredients.first, "smashed potatoes")
        }
        
    }
    
    //MARK: - Enumeration Error
    func test_givenFridgeServiceErrorFailToAddIngredientIsEmpty_whenErrorOccure_thenErrorDescriptionStringIngredientIsEmpty() {
        
        let fridgeError = FridgeServiceError.failedToAddIngredientIsEmpty
        
        XCTAssertEqual(fridgeError.errorDescription, "Ingredient is empty")
    }
    
    func test_givenFridgeServiceErrorfailedToAddIngredientIsAlreadyAdded_whenErrorOccure_thenErrorDescriptionStringIngredientIsAlreadyAdded() {
        
        let fridgeError = FridgeServiceError.failedToAddIngredientIsAlreadyAdded
        
        XCTAssertEqual(fridgeError.errorDescription, "Ingredient is already added")
    }
    
    func test_givenFridgeServiceErrorfailedToAddIngredientContainsSpecialCharacter_whenErrorOccure_thenErrorDescriptionStringIngredientContainsSpecialCharacter() {
        let fridgeError = FridgeServiceError.failedToAddIngredientContainsSpecialCharacter
        
        XCTAssertEqual(fridgeError.errorDescription, "Ingredient contains special character")
        
    }
    
    

}
