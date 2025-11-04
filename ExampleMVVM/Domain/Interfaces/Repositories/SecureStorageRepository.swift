import Foundation

enum SecureStorageError: Error {
    case saveFailed
    case loadFailed
    case deleteFailed
    case itemNotFound
}

protocol SecureStorageRepository {
    func save(key: String, value: String) throws
    func load(key: String) throws -> String
    func delete(key: String) throws
}
