import Foundation
import Security

final class KeychainSecureStorageRepository: SecureStorageRepository {
    
    private let serviceName: String
    
    init(serviceName: String = Bundle.main.bundleIdentifier ?? "com.examplemvvm.app") {
        self.serviceName = serviceName
    }
    
    func save(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw SecureStorageError.saveFailed
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecureStorageError.saveFailed
        }
    }
    
    func load(key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw SecureStorageError.itemNotFound
            }
            throw SecureStorageError.loadFailed
        }
        
        guard let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw SecureStorageError.loadFailed
        }
        
        return value
    }
    
    func delete(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecureStorageError.deleteFailed
        }
    }
}
