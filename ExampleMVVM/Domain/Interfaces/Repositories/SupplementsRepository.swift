import Foundation

protocol SupplementsRepository {
    func fetchSupplements(completion: @escaping (Result<[Supplement], Error>) -> Void)
    func fetchSupplement(id: Supplement.Identifier, completion: @escaping (Result<Supplement, Error>) -> Void)
    func saveSupplement(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void)
    func updateSupplement(_ supplement: Supplement, completion: @escaping (Result<Supplement, Error>) -> Void)
    func deleteSupplement(id: Supplement.Identifier, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchActiveSupplements(completion: @escaping (Result<[Supplement], Error>) -> Void)
}
