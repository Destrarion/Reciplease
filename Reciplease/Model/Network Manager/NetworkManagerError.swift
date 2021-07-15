import Foundation


/// Error corresponding of all that concern the Network.
/// - NoData : if there's no data received by the API
/// - failedToDecodeJsonToCodableStruct: If the received API does not fit the RecipeResponse.
enum NetworkManagerError: Error {
    /// If there's no data received by the API
    case noData
    /// If the received API does not fit the RecipeResponse.
    case failedToDecodeJsonToCodableStruct
}


extension NetworkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "noData"
        case .failedToDecodeJsonToCodableStruct: return "failedToDecodeJsonToCodableStruct"
        }
    }
}
