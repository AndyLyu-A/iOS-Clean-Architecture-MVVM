import Foundation

protocol AuthRepository {
    func observeAuthState(completion: @escaping (Result<UserProfile?, Error>) -> Void) -> Cancellable?
    func signIn(email: String, password: String, completion: @escaping (Result<UserProfile, Error>) -> Void)
    func signUp(email: String, password: String, name: String?, completion: @escaping (Result<UserProfile, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func getCurrentUser() -> UserProfile?
}
