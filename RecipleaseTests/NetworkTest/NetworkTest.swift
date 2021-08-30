import XCTest
@testable import Reciplease


class NetworkTest : XCTestCase {
    
    
    func test_givenAlamofireSessionFailureMock_WhenFetch_thenErrorFailedtoDecodeJsonToCodableStruct() {
        let alamaofireSession = AlamofireSessionFailureMock()
        let networkManager = AlamofireNetworkManager(alamofireSession: alamaofireSession)
        
        
        networkManager.fetch(url: URL(string: "www.google.com")!) { (result: Result<RecipeResponse, NetworkManagerError>) in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToDecodeJsonToCodableStruct)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    
    func test_givenAlamoFireSessionSuccessMock_whenFetch_thenFetchSuccess() {
        let alamaofireSession = AlamofireSessionSuccessMock()
        let networkManager = AlamofireNetworkManager(alamofireSession: alamaofireSession)
        
        
        networkManager.fetch(url: URL(string: "www.google.com")!) { (result: Result<RecipeResponse, NetworkManagerError>) in
            switch result {
            case .failure(let error):
                XCTFail(error.errorDescription ?? "")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    func test_givenAlamofireSessionFailureMock_whenFetchJsonData_thenErrorNoData() {
        let alamaofireSession = AlamofireSessionFailureMock()
        let networkManager = AlamofireNetworkManager(alamofireSession: alamaofireSession)
        
        networkManager.fetchData(url: URL(string: "www.qwant.com")!) { (result: Result<Data, NetworkManagerError>) in
            switch result {
            case .failure (let error):
                XCTAssertEqual(error, .noData)
            case .success:
                XCTFail()
            }
        }
        
    }
    
    func test_givenAlamofireSessionSuccesMock_whenFetchJsonData_thenSuccessData() {
        let alamaofireSession = AlamofireSessionSuccessMock()
        let networkManager = AlamofireNetworkManager(alamofireSession: alamaofireSession)
        
        networkManager.fetchData(url: URL(string: "www.qwant.com")!) { (result: Result<Data, NetworkManagerError>) in
            switch result {
            case .failure(let error):
                XCTFail(error.errorDescription ?? "")
            case .success(let data):
                XCTAssertNotNil(data)
            }
        }
    }
    
    
    func test_giv() {

        let networkReachibilityMock = NetworkReachabilityManagerAlamofireMock(isReachable: true)
        let networkManager = AlamofireNetworkManager(networkReachabilityManager: networkReachibilityMock)
        
        XCTAssertTrue(networkManager.isConnectedToInternet())
        
    }
    
    func test_give() {

        let networkReachibilityMock = NetworkReachabilityManagerAlamofireMock(isReachable: false)
        let networkManager = AlamofireNetworkManager(networkReachabilityManager: networkReachibilityMock)
        
        XCTAssertFalse(networkManager.isConnectedToInternet())
        
    }
    
    func test_giveeeee() {

        let networkManager = AlamofireNetworkManager(networkReachabilityManager: nil)
        
        XCTAssertFalse(networkManager.isConnectedToInternet())
        
    }
}
