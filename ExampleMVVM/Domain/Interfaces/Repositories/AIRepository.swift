import Foundation

protocol AIRepository {
    func generateSuggestions(for healthSummary: HealthSummary, supplements: [Supplement], completion: @escaping (Result<[AISuggestion], Error>) -> Void)
    func analyzeTrends(for metrics: [HealthMetric], completion: @escaping (Result<[AISuggestion], Error>) -> Void)
}
