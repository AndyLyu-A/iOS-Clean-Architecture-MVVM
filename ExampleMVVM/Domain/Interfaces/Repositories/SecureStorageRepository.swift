import Foundation

protocol SecureStorageRepository {
    func saveAPIKey(_ key: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAPIKey(completion: @escaping (Result<String?, Error>) -> Void)
    func deleteAPIKey(completion: @escaping (Result<Void, Error>) -> Void)
    func saveValue(_ value: String, forKey key: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getValue(forKey key: String, completion: @escaping (Result<String?, Error>) -> Void)
    func deleteValue(forKey key: String, completion: @escaping (Result<Void, Error>) -> Void)
}
