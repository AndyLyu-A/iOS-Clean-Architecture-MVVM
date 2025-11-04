import XCTest
@testable import ExampleMVVM

class SettingsViewModelTests: XCTestCase {
    
    func testViewModelCanBeInstantiated() {
        let actions = SettingsViewModelActions(didSignOut: {})
        let viewModel = DefaultSettingsViewModel(actions: actions)
        
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
        XCTAssertFalse(viewModel.healthKitAuthorized.value)
    }
}
