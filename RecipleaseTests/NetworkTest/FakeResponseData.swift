#warning("Not Used")
import Foundation

class FakeResponseData {
    // MARK: - Data
    static var RecipeCorrectData: Data? {
        getDataFromJsonFile(fileName: "Recipe")
    }

    private static func getDataFromJsonFile(fileName: String) -> Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
    

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    class MockError: Error {}
    static let error = MockError()
}
