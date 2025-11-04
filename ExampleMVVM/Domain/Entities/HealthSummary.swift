import Foundation

struct HealthSummary: Equatable {
    let dateRange: DateRange
    let metrics: [HealthMetric]
    let averages: [HealthMetricType: Double]
    let trends: [HealthMetricType: TrendDirection]
}

enum TrendDirection: String, Equatable {
    case up
    case down
    case stable
}
