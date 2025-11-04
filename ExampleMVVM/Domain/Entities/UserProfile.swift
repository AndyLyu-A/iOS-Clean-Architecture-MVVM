import Foundation

struct UserProfile: Equatable {
    let id: String
    let email: String?
    let name: String?
    let dateOfBirth: Date?
    let createdAt: Date
    let updatedAt: Date
}
