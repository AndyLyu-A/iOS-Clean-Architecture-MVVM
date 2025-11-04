import XCTest
@testable import ExampleMVVM

class DashboardViewModelTests: XCTestCase {
    
    func testViewModelCanBeInstantiated() {
        let actions = DashboardViewModelActions(showSupplements: {}, showSettings: {})
        let viewModel = DefaultDashboardViewModel(actions: actions)
        
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
        XCTAssertNil(viewModel.healthSummary.value)
        XCTAssertTrue(viewModel.suggestions.value.isEmpty)
    }
}
