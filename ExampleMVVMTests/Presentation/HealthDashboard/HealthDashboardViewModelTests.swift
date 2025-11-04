import XCTest

class HealthDashboardViewModelTests: XCTestCase {
    
    enum TestError: Error {
        case testError
    }
    
    class RequestHealthAuthorizationUseCaseMock: RequestHealthAuthorizationUseCase {
        var executeCallCount = 0
        var executeBlock: ((Result<HealthAuthorizationStatus, Error>) -> Void) -> Void = { _ in }
        
        func execute(completion: @escaping (Result<HealthAuthorizationStatus, Error>) -> Void) {
            executeCallCount += 1
            executeBlock(completion)
        }
    }
    
    class FetchHealthSummaryUseCaseMock: FetchHealthSummaryUseCase {
        var executeCallCount = 0
        var executeBlock: ((Result<HealthSummary, Error>) -> Void) -> Void = { _ in }
        
        func execute(completion: @escaping (Result<HealthSummary, Error>) -> Void) {
            executeCallCount += 1
            executeBlock(completion)
        }
    }
    
    func testViewDidLoad_whenAuthorizationSucceeds_thenLoadsHealthData() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        let summary = HealthSummary.stub()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.authorized))
        }
        
        fetchUseCase.executeBlock = { completion in
            completion(.success(summary))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(authUseCase.executeCallCount, 1)
        XCTAssertEqual(fetchUseCase.executeCallCount, 1)
        XCTAssertEqual(viewModel.state.value, .loaded)
        XCTAssertEqual(viewModel.healthSummary.value, summary)
        XCTAssertFalse(viewModel.lastUpdatedText.value.isEmpty)
    }
    
    func testViewDidLoad_whenAuthorizationDenied_thenShowsPermissionDeniedState() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.denied))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(authUseCase.executeCallCount, 1)
        XCTAssertEqual(fetchUseCase.executeCallCount, 0)
        XCTAssertEqual(viewModel.state.value, .permissionDenied)
        XCTAssertNil(viewModel.healthSummary.value)
    }
    
    func testViewDidLoad_whenAuthorizationNotDetermined_thenShowsInitialState() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.notDetermined))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(authUseCase.executeCallCount, 1)
        XCTAssertEqual(fetchUseCase.executeCallCount, 0)
        XCTAssertEqual(viewModel.state.value, .initial)
    }
    
    func testRequestPermission_whenAuthorizationGranted_thenLoadsData() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        let summary = HealthSummary.stub()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.authorized))
        }
        
        fetchUseCase.executeBlock = { completion in
            completion(.success(summary))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.requestPermission()
        
        // then
        XCTAssertEqual(viewModel.state.value, .loaded)
        XCTAssertEqual(viewModel.healthSummary.value, summary)
    }
    
    func testRefreshData_whenAuthorized_thenFetchesNewData() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        let summary = HealthSummary.stub()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.authorized))
        }
        
        fetchUseCase.executeBlock = { completion in
            completion(.success(summary))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // Load initially
        viewModel.viewDidLoad()
        
        // when
        viewModel.refreshData()
        
        // then
        XCTAssertEqual(fetchUseCase.executeCallCount, 2)
        XCTAssertEqual(viewModel.state.value, .loaded)
    }
    
    func testFetchHealthSummary_whenFetchFails_thenShowsError() {
        // given
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        
        authUseCase.executeBlock = { completion in
            completion(.success(.authorized))
        }
        
        fetchUseCase.executeBlock = { completion in
            completion(.failure(TestError.testError))
        }
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(viewModel.state.value, .error)
        XCTAssertFalse(viewModel.errorMessage.value.isEmpty)
    }
    
    func testOpenSettings_whenCalled_thenTriggersAction() {
        // given
        var openSettingsCalled = false
        let actions = HealthDashboardViewModelActions {
            openSettingsCalled = true
        }
        
        let authUseCase = RequestHealthAuthorizationUseCaseMock()
        let fetchUseCase = FetchHealthSummaryUseCaseMock()
        
        let viewModel = DefaultHealthDashboardViewModel(
            requestAuthorizationUseCase: authUseCase,
            fetchHealthSummaryUseCase: fetchUseCase,
            actions: actions,
            mainQueue: DispatchQueueTypeMock()
        )
        
        // when
        viewModel.openSettings()
        
        // then
        XCTAssertTrue(openSettingsCalled)
    }
}
