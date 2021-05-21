//
//  FridgeServiceTests.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 02/04/2021.
//

import XCTest
@testable import Reciplease

class FridgeServiceTests: XCTestCase {
//    func testGivenFridgeWithMultipleIngredients_whenClearIngredients_thenIngredientsEmpty() {
//        let fridgeService = FridgeService()
//
//        _ = fridgeService.add(ingredient: "Tomato")
//        _ = fridgeService.add(ingredient: "Lemon")
//
//
//
//        fridgeService.removeIngredients()
//
//
//
//        XCTAssertTrue(fridgeService.ingredients.isEmpty)
//
//
//    }
//
//
//    func testGivenFridgeWithTomatoIngredients_whenRemoveTomato_thenTomatoIsRemoved() {
//        let fridgeService = FridgeService()
//
//        _ = fridgeService.add(ingredient: "Tomato")
//        _ = fridgeService.add(ingredient: "Lemon")
//
//
//        fridgeService.removeIngredient(at: 0)
//
//
//
//        XCTAssertFalse(fridgeService.ingredients.contains("Tomato"))
//
//
//    }
    
    
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
    
    
}
