import XCTest
@testable import ExampleMVVM

class OnboardingViewModelTests: XCTestCase {
    
    func testViewModelCanBeInstantiated() {
        let actions = OnboardingViewModelActions(didCompleteOnboarding: {})
        let viewModel = DefaultOnboardingViewModel(actions: actions)
        
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading.value)
        XCTAssertNil(viewModel.error.value)
    }
}
