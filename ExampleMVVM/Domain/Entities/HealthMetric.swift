import Foundation

enum HealthMetricType: String, Equatable {
    case steps
    case heartRate
    case bloodPressure
    case sleep
    case weight
    case bloodGlucose
    case activeEnergy
    case exerciseMinutes
}

struct HealthMetric: Equatable {
    let type: HealthMetricType
    let value: Double
    let unit: String
    let date: Date
    let source: String?
}

struct DateRange: Equatable {
    let startDate: Date
    let endDate: Date
}
