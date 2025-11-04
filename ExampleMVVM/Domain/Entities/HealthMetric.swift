import Foundation

enum HealthMetricType: String, Equatable {
    case steps
    case heartRate
    case sleep
    case activeMinutes
}

struct HealthMetric: Equatable {
    let type: HealthMetricType
    let value: Double
    let unit: String
    let date: Date
}

struct HealthSummary: Equatable {
    let steps: HealthMetric?
    let heartRate: HealthMetric?
    let sleep: HealthMetric?
    let activeMinutes: HealthMetric?
    let lastUpdated: Date
    
    var isEmpty: Bool {
        steps == nil && heartRate == nil && sleep == nil && activeMinutes == nil
    }
}
