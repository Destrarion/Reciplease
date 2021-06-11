#warning("Need Documentation")

import XCTest
@testable import Reciplease

class RealBackendDecodeTests: XCTestCase {
    
    
    
    func test_given() {
        
        let recipeService = RecipeService()
        
        let expectation = expectation(description: "Wait for recipes from backend")
        
        //1
        recipeService.getRecipes(ingredients: ["beef", "smashed potatoes"]) { result in
            //3
            switch result {
            case .success: XCTAssertTrue(true)
            case .failure: XCTFail()
            }
            
            expectation.fulfill()
            
            
        }
        
        //2
        wait(for: [expectation], timeout: 3)
        
    }
    
    func test_givenasd() {
        
        let recipeService = RecipeService()
        
        let expectation = expectation(description: "Wait for recipes from backend")
        
        //1
        recipeService.getRecipes(ingredients: ["beef", "smashed carort"]) { result in
            //3
            switch result {
            case .success: XCTAssertTrue(true)
            case .failure: XCTFail()
            }
            
            expectation.fulfill()
            
            
        }
        
        //2
        wait(for: [expectation], timeout: 3)
        
    }
}
