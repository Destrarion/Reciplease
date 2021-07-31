//
//  RecipeCoreDataManagerMock.swift
//  RecipleaseTests
//
//  Created by Fabien Dietrich on 31/07/2021.
//

import Foundation
@testable import Reciplease


class RecipeCoreDataManagerMock: RecipeCoreDataManagerProtocol {
    
    private var storedRecipes: [Recipe] = []
    
    func addRecipe(recipe: Recipe) {
        storedRecipes.append(recipe)
    }
    
    func getRecipes() -> [Recipe] {
        return storedRecipes
    }
    
    func deleteRecipe(with title: String) {
        storedRecipes.removeAll { recipe in
            recipe.label == recipe.label
        }
    }
    
}
