import Foundation

protocol SaveAPIKeyUseCase {
    func execute(apiKey: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DefaultSaveAPIKeyUseCase: SaveAPIKeyUseCase {
    private let secureStorageRepository: SecureStorageRepository
    
    init(secureStorageRepository: SecureStorageRepository) {
        self.secureStorageRepository = secureStorageRepository
    }
    
    func execute(apiKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        secureStorageRepository.saveAPIKey(apiKey, completion: completion)
    }
}

protocol GetAPIKeyUseCase {
    func execute(completion: @escaping (Result<String?, Error>) -> Void)
}

final class DefaultGetAPIKeyUseCase: GetAPIKeyUseCase {
    private let secureStorageRepository: SecureStorageRepository
    
    init(secureStorageRepository: SecureStorageRepository) {
        self.secureStorageRepository = secureStorageRepository
    }
    
    func execute(completion: @escaping (Result<String?, Error>) -> Void) {
        secureStorageRepository.getAPIKey(completion: completion)
    }
}
