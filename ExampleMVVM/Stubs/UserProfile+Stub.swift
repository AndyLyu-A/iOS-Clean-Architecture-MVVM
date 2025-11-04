import Foundation

extension UserProfile {
    static func stub(
        userId: String = "123",
        email: String? = "test@example.com",
        fullName: String? = "Test User"
    ) -> Self {
        UserProfile(userId: userId, email: email, fullName: fullName)
    }
}
