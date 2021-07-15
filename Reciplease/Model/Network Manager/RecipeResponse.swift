// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recipeResponse = try? newJSONDecoder().decode(RecipeResponse.self, from: jsonData)

import Foundation


// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    
    
    /// Total cooking / prepration time for the recipe in minutes
    let totalTime: Double
    
    func formatCookingTimeToString() -> String? {
        
        guard totalTime != 0.0 else {
            return "--"
        }
        
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.maximumUnitCount = 2
        

        
        let dateComponents = DateComponents(minute: Int(totalTime))
    
    
        
        return formatter.string(for: dateComponents)
        
        
        // return Int(round(totalTime / 60)).description + "m"
    }
}




// MARK: - Ingredient
struct Ingredient: Codable {
    let foodCategory: String?
}
