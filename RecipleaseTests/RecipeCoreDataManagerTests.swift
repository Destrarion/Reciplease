import XCTest
@testable import Reciplease

class RecipeCoreDataManagerTests: XCTestCase {

    func test_givenOneSingleRecipeAddedToDatabase_whenGetRecipes_thenGetOnlyOne() throws {
        let recipeCoreDataManager = RecipeCoreDataManager()
        
        XCTAssertEqual(recipeCoreDataManager.getRecipes().count, 0)
        
        let recipe = createSimpleRecipe(with: "Pizza")
        
        recipeCoreDataManager.addRecipe(recipe: recipe)
        
        let recipes = recipeCoreDataManager.getRecipes()
        
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first!.label, "Pizza")
        
       
    }
    
    func test_givenPizzaAndPastaInDatabase_whenDeletePizza_thenGetOnlyPasta() throws {
        let recipeCoreDataManager = RecipeCoreDataManager()
        
        XCTAssertEqual(recipeCoreDataManager.getRecipes().count, 0)
        
        let pizzaRecipe = createSimpleRecipe(with: "Pizza")
        let pastaRecipe = createSimpleRecipe(with: "Pasta")
        
        recipeCoreDataManager.addRecipe(recipe: pizzaRecipe)
        recipeCoreDataManager.addRecipe(recipe: pastaRecipe)
        
        let recipesBeforeDeletion = recipeCoreDataManager.getRecipes()
        
        XCTAssertEqual(recipesBeforeDeletion.count, 2)
        XCTAssertEqual(recipesBeforeDeletion.first!.label, "Pizza")
        
        recipeCoreDataManager.deleteRecipe(with: "Pizza")
        
        let recipesAfterDeletion = recipeCoreDataManager.getRecipes()
        
        XCTAssertEqual(recipesAfterDeletion.count, 1)
        XCTAssertEqual(recipesAfterDeletion.first!.label, "Pasta")
        
       
    }
    
    func test_givenFailingFetchContext_whenGetRecipes_thenGetEmptyArray() throws {
        let coreDataContextProviderMock = CoreDataContextProviderMock()
        let recipeCoreDataManager = RecipeCoreDataManager(coreDataContextProvider: coreDataContextProviderMock)
        
        XCTAssertTrue(recipeCoreDataManager.getRecipes().isEmpty)
       
    }
    
    private func createSimpleRecipe(with title: String) -> Recipe {
        Recipe(
            label: title,
            image: "",
            url: "",
            ingredientLines: [],
            ingredients: [.init(foodCategory: "italian")],
            totalTime: 4
        )
    }

    
    override func setUp() {
        super.setUp()
        let recipeCoreDataManager = RecipeCoreDataManager()
        recipeCoreDataManager.deleteAllRecipes()
    }
    
    override func tearDown() {
        super.tearDown()
        let recipeCoreDataManager = RecipeCoreDataManager()
        recipeCoreDataManager.deleteAllRecipes()
    }
    
  

}
