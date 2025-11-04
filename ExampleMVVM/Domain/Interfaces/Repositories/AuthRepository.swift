import Foundation

protocol AuthRepository {
    func signInWithApple(
        presentationContextProvider: Any,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    )
    func getCurrentUser() -> UserProfile?
    func signOut() throws
}
