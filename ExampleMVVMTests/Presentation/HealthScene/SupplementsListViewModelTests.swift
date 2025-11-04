import XCTest
@testable import ExampleMVVM

class SupplementsListViewModelTests: XCTestCase {
    
    func testViewModelCanBeInstantiated() {
        let actions = SupplementsListViewModelActions(showSupplementDetail: { _ in }, didUpdateSupplements: {})
        let viewModel = DefaultSupplementsListViewModel(actions: actions)
        
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
        XCTAssertTrue(viewModel.supplements.value.isEmpty)
    }
}
