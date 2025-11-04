import Foundation

final class DefaultAIRepository: AIRepository {
    
    func generateSuggestions(for healthSummary: HealthSummary, supplements: [Supplement], completion: @escaping (Result<[AISuggestion], Error>) -> Void) {
        // TODO: Implement OpenAI API call for suggestions generation
        completion(.success([]))
    }
    
    func analyzeTrends(for metrics: [HealthMetric], completion: @escaping (Result<[AISuggestion], Error>) -> Void) {
        // TODO: Implement OpenAI API call for trends analysis
        completion(.success([]))
    }
}
