import Foundation
import AuthenticationServices

enum AuthError: Error {
    case cancelled
    case failed
    case invalidCredential
    case notInteractive
    case unknown
}

final class DefaultAuthRepository: NSObject {
    
    private let secureStorage: SecureStorageRepository
    private var continuation: ((Result<UserProfile, Error>) -> Void)?
    
    private let userIdKey = "apple_user_id"
    private let emailKey = "apple_user_email"
    private let fullNameKey = "apple_user_fullname"
    
    init(secureStorage: SecureStorageRepository) {
        self.secureStorage = secureStorage
        super.init()
    }
}

extension DefaultAuthRepository: AuthRepository {
    
    func signInWithApple(
        presentationContextProvider: Any,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
        self.continuation = completion
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        
        if let contextProvider = presentationContextProvider as? ASAuthorizationControllerPresentationContextProviding {
            controller.presentationContextProvider = contextProvider
        }
        
        controller.performRequests()
    }
    
    func getCurrentUser() -> UserProfile? {
        guard let userId = try? secureStorage.load(key: userIdKey) else {
            return nil
        }
        
        let email = try? secureStorage.load(key: emailKey)
        let fullName = try? secureStorage.load(key: fullNameKey)
        
        return UserProfile(userId: userId, email: email, fullName: fullName)
    }
    
    func signOut() throws {
        try? secureStorage.delete(key: userIdKey)
        try? secureStorage.delete(key: emailKey)
        try? secureStorage.delete(key: fullNameKey)
    }
}

extension DefaultAuthRepository: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?(.failure(AuthError.invalidCredential))
            continuation = nil
            return
        }
        
        let userId = credential.user
        let email = credential.email
        let fullName: String?
        
        if let givenName = credential.fullName?.givenName,
           let familyName = credential.fullName?.familyName {
            fullName = "\(givenName) \(familyName)"
        } else {
            fullName = credential.fullName?.givenName ?? credential.fullName?.familyName
        }
        
        do {
            try secureStorage.save(key: userIdKey, value: userId)
            if let email = email {
                try secureStorage.save(key: emailKey, value: email)
            }
            if let fullName = fullName {
                try secureStorage.save(key: fullNameKey, value: fullName)
            }
            
            let userProfile = UserProfile(userId: userId, email: email, fullName: fullName)
            continuation?(.success(userProfile))
        } catch {
            continuation?(.failure(error))
        }
        
        continuation = nil
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let authError: Error
        if let asError = error as? ASAuthorizationError {
            switch asError.code {
            case .canceled:
                authError = AuthError.cancelled
            case .failed:
                authError = AuthError.failed
            case .invalidResponse:
                authError = AuthError.invalidCredential
            case .notHandled:
                authError = AuthError.notInteractive
            case .unknown:
                authError = AuthError.unknown
            @unknown default:
                authError = AuthError.unknown
            }
        } else {
            authError = error
        }
        
        continuation?(.failure(authError))
        continuation = nil
    }
}
