//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Fabien Dietrich on 11/06/2021.
//

import Foundation
import CoreData

protocol RecipeCoreDataManagerProtocol {
    func addRecipe(recipe: Recipe)
    func getRecipes() -> [Recipe]
    func deleteRecipe(with title: String)
}

class RecipeCoreDataManager: RecipeCoreDataManagerProtocol {
    
    private let coreDataContextProvider = CoreDataContextProvider.shared
    
    
    func addRecipe(recipe: Recipe) {
        let recipeEntity = RecipeEntity(context: coreDataContextProvider.viewContext)
        recipeEntity.title = recipe.label
        
        coreDataContextProvider.saveContext()
    }
    
    func getRecipes() -> [Recipe] {
        
        let recipeEntities = getRecipeEntities()
        
        let recipes = recipeEntities.map { recipeEntity in
            Recipe(
                uri: "",
                label: recipeEntity.title ?? "",
                image: "",
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
        }
        
        return recipes
        
    }
    
    func deleteRecipe(with title: String) {
        let recipeEntities = getRecipeEntities()
        print(recipeEntities)
        for recipeEntity in recipeEntities where recipeEntity.title == title {
            coreDataContextProvider.viewContext.delete(recipeEntity)
            print(recipeEntity)
            print("deleted")
            print(recipeEntities)
            
        }
        
        guard let _ = try? coreDataContextProvider.viewContext.save() else { return }
        
    }
    
    func deleteAllRecipes() {
        let recipeEntities = getRecipeEntities()
        
        for recipeEntity in recipeEntities {
            coreDataContextProvider.viewContext.delete(recipeEntity)
        }
        
        guard let _ = try? coreDataContextProvider.viewContext.save() else { return }
    }
    
    

    
    
    private func getRecipeEntities() -> [RecipeEntity] {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        return (try? coreDataContextProvider.viewContext.fetch(request)) ?? []
    }
    
    
    
}
