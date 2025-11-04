#!/usr/bin/env python3
import subprocess
import os

# List of files to add to the main target
main_target_files = [
    "ExampleMVVM/Domain/Entities/HealthMetric.swift",
    "ExampleMVVM/Domain/Interfaces/Repositories/HealthDataRepository.swift",
    "ExampleMVVM/Domain/UseCases/RequestHealthAuthorizationUseCase.swift",
    "ExampleMVVM/Domain/UseCases/FetchHealthSummaryUseCase.swift",
    "ExampleMVVM/Data/Repositories/DefaultHealthDataRepository.swift",
    "ExampleMVVM/Presentation/HealthDashboard/ViewModel/HealthDashboardViewModel.swift",
    "ExampleMVVM/Presentation/HealthDashboard/View/HealthDashboardViewController.swift",
    "ExampleMVVM/Presentation/HealthDashboard/View/HealthDashboardViewController.storyboard",
    "ExampleMVVM/Presentation/HealthDashboard/Flows/HealthDashboardFlowCoordinator.swift",
    "ExampleMVVM/Application/DIContainer/HealthDashboardSceneDIContainer.swift",
    "ExampleMVVM/Mocks/HealthDataRepositoryMock.swift",
    "ExampleMVVM/Stubs/HealthMetric+Stub.swift",
    "ExampleMVVM/Resources/ExampleMVVM.entitlements",
]

# List of files to add to the test target
test_target_files = [
    "ExampleMVVMTests/Domain/UseCases/RequestHealthAuthorizationUseCaseTests.swift",
    "ExampleMVVMTests/Domain/UseCases/FetchHealthSummaryUseCaseTests.swift",
    "ExampleMVVMTests/Presentation/HealthDashboard/HealthDashboardViewModelTests.swift",
]

print("Files have been created. Please add them to the Xcode project manually:")
print("\nMain target files:")
for f in main_target_files:
    print(f"  - {f}")
print("\nTest target files:")
for f in test_target_files:
    print(f"  - {f}")
