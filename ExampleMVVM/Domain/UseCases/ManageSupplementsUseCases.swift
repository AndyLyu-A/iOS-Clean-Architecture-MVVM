import Foundation

protocol FetchSupplementsUseCase {
    func execute(completion: @escaping (Result<[Supplement], Error>) -> Void)
}

final class DefaultFetchSupplementsUseCase: FetchSupplementsUseCase {
    private let supplementsRepository: SupplementsRepository
    
    init(supplementsRepository: SupplementsRepository) {
        self.supplementsRepository = supplementsRepository
    }
    
    func execute(completion: @escaping (Result<[Supplement], Error>) -> Void) {
        supplementsRepository.fetchSupplements(completion: completion)
    }
}

protocol SaveSupplementUseCase {
    func execute(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void)
}

final class DefaultSaveSupplementUseCase: SaveSupplementUseCase {
    private let supplementsRepository: SupplementsRepository
    
    init(supplementsRepository: SupplementsRepository) {
        self.supplementsRepository = supplementsRepository
    }
    
    func execute(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void) {
        supplementsRepository.saveSupplement(supplement, completion: completion)
    }
}

protocol UpdateSupplementUseCase {
    func execute(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void)
}

final class DefaultUpdateSupplementUseCase: UpdateSupplementUseCase {
    private let supplementsRepository: SupplementsRepository
    
    init(supplementsRepository: SupplementsRepository) {
        self.supplementsRepository = supplementsRepository
    }
    
    func execute(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void) {
        supplementsRepository.updateSupplement(supplement, completion: completion)
    }
}

protocol DeleteSupplementUseCase {
    func execute(id: Supplement.Identifier, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DefaultDeleteSupplementUseCase: DeleteSupplementUseCase {
    private let supplementsRepository: SupplementsRepository
    
    init(supplementsRepository: SupplementsRepository) {
        self.supplementsRepository = supplementsRepository
    }
    
    func execute(id: Supplement.Identifier, completion: @escaping (Result<Void, Error>) -> Void) {
        supplementsRepository.deleteSupplement(id: id, completion: completion)
    }
}
