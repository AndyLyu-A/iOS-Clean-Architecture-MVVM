import XCTest

class FetchHealthSummaryUseCaseTests: XCTestCase {
    
    enum TestError: Error {
        case fetchFailed
    }
    
    func testFetchHealthSummaryUseCase_whenAuthorizedAndFetchSucceeds_thenReturnsSummary() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.authorizationStatus = .authorized
        let summary = HealthSummary.stub()
        repository.fetchHealthSummaryResult = .success(summary)
        let useCase = DefaultFetchHealthSummaryUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthSummary, Error>?
        let expectation = self.expectation(description: "Fetch completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.fetchHealthSummaryCallCount, 1)
        
        if case .success(let receivedSummary) = receivedResult {
            XCTAssertEqual(receivedSummary, summary)
        } else {
            XCTFail("Expected success")
        }
    }
    
    func testFetchHealthSummaryUseCase_whenNotAuthorized_thenReturnsError() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.authorizationStatus = .denied
        let useCase = DefaultFetchHealthSummaryUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthSummary, Error>?
        let expectation = self.expectation(description: "Fetch completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.fetchHealthSummaryCallCount, 0)
        
        if case .failure = receivedResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure")
        }
    }
    
    func testFetchHealthSummaryUseCase_whenAuthorizedButFetchFails_thenReturnsError() {
        // given
        let repository = HealthDataRepositoryMock()
        repository.authorizationStatus = .authorized
        repository.fetchHealthSummaryResult = .failure(TestError.fetchFailed)
        let useCase = DefaultFetchHealthSummaryUseCase(healthDataRepository: repository)
        
        var receivedResult: Result<HealthSummary, Error>?
        let expectation = self.expectation(description: "Fetch completes")
        
        // when
        useCase.execute { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(repository.fetchHealthSummaryCallCount, 1)
        
        if case .failure = receivedResult {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure")
        }
    }
}
