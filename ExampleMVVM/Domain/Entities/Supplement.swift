import Foundation

enum SupplementType: String, Equatable, CaseIterable {
    case vitamin
    case mineral
    case herb
    case amino
    case other
}

struct SupplementDosage: Equatable {
    let amount: Double
    let unit: String
    let frequency: String
    let timeOfDay: [String]
}

struct Supplement: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let name: String
    let type: SupplementType
    let dosage: SupplementDosage
    let startDate: Date
    let endDate: Date?
    let notes: String?
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
}
