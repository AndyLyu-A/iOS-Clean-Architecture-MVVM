import Foundation

protocol GenerateAISuggestionsUseCase {
    func execute(for healthSummary: HealthSummary, supplements: [Supplement], completion: @escaping (Result<[AISuggestion], Error>) -> Void)
}

final class DefaultGenerateAISuggestionsUseCase: GenerateAISuggestionsUseCase {
    private let aiRepository: AIRepository
    
    init(aiRepository: AIRepository) {
        self.aiRepository = aiRepository
    }
    
    func execute(for healthSummary: HealthSummary, supplements: [Supplement], completion: @escaping (Result<[AISuggestion], Error>) -> Void) {
        aiRepository.generateSuggestions(for: healthSummary, supplements: supplements, completion: completion)
    }
}
