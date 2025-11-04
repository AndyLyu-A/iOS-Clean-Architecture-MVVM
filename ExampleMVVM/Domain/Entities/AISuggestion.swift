import Foundation

enum SuggestionCategory: String, Equatable {
    case supplement
    case exercise
    case nutrition
    case lifestyle
    case medical
}

enum SuggestionPriority: String, Equatable {
    case low
    case medium
    case high
    case urgent
}

struct AISuggestion: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let category: SuggestionCategory
    let priority: SuggestionPriority
    let title: String
    let description: String
    let reasoning: String?
    let basedOnMetrics: [HealthMetricType]
    let createdAt: Date
}
