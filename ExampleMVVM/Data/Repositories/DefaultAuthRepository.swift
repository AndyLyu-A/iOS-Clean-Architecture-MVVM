import Foundation

final class DefaultAuthRepository: AuthRepository {
    
    func observeAuthState(completion: @escaping (Result<UserProfile?, Error>) -> Void) -> Cancellable? {
        // TODO: Implement Firebase Auth state observer
        completion(.success(nil))
        return nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // TODO: Implement Firebase Auth sign in
        completion(.failure(NSError(domain: "AuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])))
    }
    
    func signUp(email: String, password: String, name: String?, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // TODO: Implement Firebase Auth sign up
        completion(.failure(NSError(domain: "AuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])))
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        // TODO: Implement Firebase Auth sign out
        completion(.failure(NSError(domain: "AuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not implemented"])))
    }
    
    func getCurrentUser() -> UserProfile? {
        // TODO: Implement Firebase Auth get current user
        return nil
    }
}
