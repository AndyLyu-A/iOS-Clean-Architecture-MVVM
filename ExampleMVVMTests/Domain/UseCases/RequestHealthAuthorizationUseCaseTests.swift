import XCTest

class RequestHealthAuthorizationUseCaseTests: XCTestCase {
    
    enum TestError: Error {
        case authorizationFailed
    }
    
    func testRequestHealthAuthorizationUseCase_whenAuthorizationSucceeds_thenReturnsAuthorizedStatus() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.requestAuthorizationResult = .success(.authorized)
        let useCase = DefaultRequestHealthAuthorizationUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthAuthorizationStatus, Error>?
        let expectation = self.expectation(description: "Authorization completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.requestAuthorizationCallCount, 1)
        
        if case .success(let status) = receivedResult {
            XCTAssertEqual(status, .authorized)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testRequestHealthAuthorizationUseCase_whenAuthorizationDenied_thenReturnsDeniedStatus() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.requestAuthorizationResult = .success(.denied)
        let useCase = DefaultRequestHealthAuthorizationUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthAuthorizationStatus, Error>?
        let expectation = self.expectation(description: "Authorization completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.requestAuthorizationCallCount, 1)
        
        if case .success(let status) = receivedResult {
            XCTAssertEqual(status, .denied)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testRequestHealthAuthorizationUseCase_whenAuthorizationFails_thenReturnsError() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.requestAuthorizationResult = .failure(TestError.authorizationFailed)
        let useCase = DefaultRequestHealthAuthorizationUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthAuthorizationStatus, Error>?
        let expectation = self.expectation(description: "Authorization completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.requestAuthorizationCallCount, 1)
        
        if case .failure = receivedResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure")
        }
    }
}
