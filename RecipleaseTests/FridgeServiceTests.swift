//
//  FridgeServiceTests.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 02/04/2021.
//

import XCTest
@testable import Reciplease

class FridgeServiceTests: XCTestCase {
    func testGivenFridgeWithMultipleIngredients_whenClearIngredients_thenIngredientsEmpty() {
        let fridgeService = FridgeService()
        
        fridgeService.add(ingredient: "Tomato")
        fridgeService.add(ingredient: "Lemon")
        
        
        
        fridgeService.removeIngredients()
        
        
        
        XCTAssertTrue(fridgeService.ingredients.isEmpty)
        
        
    }
    
    
    func testGivenFridgeWithTomatoIngredients_whenRemoveTomato_thenTomatoIsRemoved() {
        let fridgeService = FridgeService()
        
        fridgeService.add(ingredient: "Tomato")
        fridgeService.add(ingredient: "Lemon")
        
        
        
        fridgeService.removeIngredient(at: 0)
        
        
        
        XCTAssertFalse(fridgeService.ingredients.contains("Tomato"))
        
        
    }
   

}
