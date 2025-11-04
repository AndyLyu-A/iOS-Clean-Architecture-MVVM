import Foundation

struct UserProfile: Equatable {
    let userId: String
    let email: String?
    let fullName: String?
    
    init(userId: String, email: String? = nil, fullName: String? = nil) {
        self.userId = userId
        self.email = email
        self.fullName = fullName
    }
}
