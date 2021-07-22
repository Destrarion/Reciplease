import Foundation
import CoreData

protocol RecipeCoreDataManagerProtocol {
    func addRecipe(recipe: Recipe)
    func getRecipes() -> [Recipe]
    func deleteRecipe(with title: String)
}

class RecipeCoreDataManager: RecipeCoreDataManagerProtocol {
    
    private let coreDataContextProvider = CoreDataContextProvider.shared
    
    
    /// Add the recipe into CoreData
    ///
    /// This function will add the title, image, total time , ingredients and the url  into CoreData to become a Favorite Recipe.
    /// - Parameter recipe: Recipe to add in favorite
    func addRecipe(recipe: Recipe) {
        let recipeEntity = RecipeEntity(context: coreDataContextProvider.viewContext)
        recipeEntity.title = recipe.label
        recipeEntity.imageURL = recipe.image
        recipeEntity.totalTime = recipe.totalTime
        recipeEntity.ingredientLines = recipe.ingredientLines
        recipeEntity.foodCategories = recipe.ingredients.compactMap(\.foodCategory)
        recipeEntity.instructionUrl = recipe.url
        coreDataContextProvider.saveContext()
    }
    
    /// Function called to get all the favorite recipe.
    ///
    /// Get all the favorite recipe with their titles, images, total time , ingredients and the URL.
    /// - Returns: Return Recipe, to fit in the tableview of RecipeListController
    func getRecipes() -> [Recipe] {
        
        let recipeEntities = getRecipeEntities()
        
        let recipes = recipeEntities.map { recipeEntity in
            Recipe(
                label: recipeEntity.title ?? "",
                image: recipeEntity.imageURL ?? "",
                url: recipeEntity.instructionUrl ?? "",
                ingredientLines: recipeEntity.ingredientLines ?? [],
                ingredients: recipeEntity.foodCategories?.map { foodCategory in
                    Ingredient(foodCategory: foodCategory)
                } ?? [],
                totalTime: recipeEntity.totalTime
            )
        }
        
        return recipes
        
    }
    
    /// Function to delete favorite recipe in Core Data.
    /// - Parameter title: Title of the recipe to delete
    func deleteRecipe(with title: String) {
        let recipeEntities = getRecipeEntities()
        for recipeEntity in recipeEntities where recipeEntity.title == title {
            coreDataContextProvider.viewContext.delete(recipeEntity)
            
        }
        
        guard let _ = try? coreDataContextProvider.viewContext.save() else { return }
        
    }
    
    /// Delete all the favorite recipe in CoreData.
    ///
    /// Called for test for CoreData
    func deleteAllRecipes() {
        let recipeEntities = getRecipeEntities()
        
        for recipeEntity in recipeEntities {
            coreDataContextProvider.viewContext.delete(recipeEntity)
        }
        
        guard let _ = try? coreDataContextProvider.viewContext.save() else { return }
    }
    
    

    
    
    /// Function to get a specific entity in CoreData, Return RecipeEntity to get access to the favorite Recipe in CoreData
    /// - Returns: RecipeEntity, contains the information for the title, image, total time , ingredients and the url.
    private func getRecipeEntities() -> [RecipeEntity] {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        return (try? coreDataContextProvider.viewContext.fetch(request)) ?? []
    }
    
    
    
}
