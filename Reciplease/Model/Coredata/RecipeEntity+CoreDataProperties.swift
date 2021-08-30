//
//  RecipeEntity+CoreDataProperties.swift
//  
//
//  Created by Fabien Dietrich on 30/08/2021.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var foodCategories: [String]
    @NSManaged public var imageURL: String
    @NSManaged public var ingredientLines: [String]
    @NSManaged public var instructionUrl: String
    @NSManaged public var title: String
    @NSManaged public var totalTime: Double

}
