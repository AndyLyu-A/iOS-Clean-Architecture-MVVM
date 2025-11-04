import Foundation

extension HealthMetric {
    static func stub(
        type: HealthMetricType = .steps,
        value: Double = 1000,
        unit: String = "steps",
        date: Date = Date()
    ) -> Self {
        HealthMetric(
            type: type,
            value: value,
            unit: unit,
            date: date
        )
    }
}

extension HealthSummary {
    static func stub(
        steps: HealthMetric? = HealthMetric.stub(type: .steps, value: 8000, unit: "steps"),
        heartRate: HealthMetric? = HealthMetric.stub(type: .heartRate, value: 72, unit: "bpm"),
        sleep: HealthMetric? = HealthMetric.stub(type: .sleep, value: 7.5, unit: "hours"),
        activeMinutes: HealthMetric? = HealthMetric.stub(type: .activeMinutes, value: 30, unit: "minutes"),
        lastUpdated: Date = Date()
    ) -> Self {
        HealthSummary(
            steps: steps,
            heartRate: heartRate,
            sleep: sleep,
            activeMinutes: activeMinutes,
            lastUpdated: lastUpdated
        )
    }
}
