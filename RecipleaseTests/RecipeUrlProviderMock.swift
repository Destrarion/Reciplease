//
//  RecipeUrlProviderMock.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 11/06/2021.
//

import Foundation

@testable import Reciplease

class RecipeUrlProviderMock: RecipeUrlProviderProtocol {
    func createRecipeRequestUrl(ingredients: [String]) -> URL? {
        return nil
    }
    
}
