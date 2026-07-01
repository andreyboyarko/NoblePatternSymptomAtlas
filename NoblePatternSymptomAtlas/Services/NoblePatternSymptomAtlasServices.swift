import Foundation
import UIKit

final class NoblePatternSymptomAtlasPersistenceService {
    private let NoblePatternSymptomAtlasDefaults: UserDefaults
    private let NoblePatternSymptomAtlasLogsKey = "NoblePatternSymptomAtlas.logs"
    private let NoblePatternSymptomAtlasSettingsKey = "NoblePatternSymptomAtlas.settings"
    private let NoblePatternSymptomAtlasSampleDataSeededKey = "NoblePatternSymptomAtlas.sampleDataSeeded"
    private let NoblePatternSymptomAtlasTrackedSymptomsKey = "NoblePatternSymptomAtlas.trackedSymptoms"
    private let NoblePatternSymptomAtlasTrackedSymptomCheckInsKey = "NoblePatternSymptomAtlas.trackedSymptomCheckIns"
    private let NoblePatternSymptomAtlasEncoder = JSONEncoder()
    private let NoblePatternSymptomAtlasDecoder = JSONDecoder()

    init(defaults NoblePatternSymptomAtlasDefaults: UserDefaults = .standard) {
        self.NoblePatternSymptomAtlasDefaults = NoblePatternSymptomAtlasDefaults
    }

    func NoblePatternSymptomAtlasLoadLogs() -> [NoblePatternSymptomAtlasLogEntry] {
        guard let NoblePatternSymptomAtlasData = NoblePatternSymptomAtlasDefaults.data(forKey: NoblePatternSymptomAtlasLogsKey),
              let NoblePatternSymptomAtlasLogs = try? NoblePatternSymptomAtlasDecoder.decode([NoblePatternSymptomAtlasLogEntry].self, from: NoblePatternSymptomAtlasData) else {
            return []
        }
        return NoblePatternSymptomAtlasLogs.sorted { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
    }

    func NoblePatternSymptomAtlasSaveLogs(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) {
        guard let NoblePatternSymptomAtlasData = try? NoblePatternSymptomAtlasEncoder.encode(NoblePatternSymptomAtlasLogs) else { return }
        NoblePatternSymptomAtlasDefaults.set(NoblePatternSymptomAtlasData, forKey: NoblePatternSymptomAtlasLogsKey)
    }

    func NoblePatternSymptomAtlasLoadSettings() -> NoblePatternSymptomAtlasSettings {
        guard let NoblePatternSymptomAtlasData = NoblePatternSymptomAtlasDefaults.data(forKey: NoblePatternSymptomAtlasSettingsKey),
              let NoblePatternSymptomAtlasSettings = try? NoblePatternSymptomAtlasDecoder.decode(NoblePatternSymptomAtlasSettings.self, from: NoblePatternSymptomAtlasData) else {
            return NoblePatternSymptomAtlasSettings()
        }
        return NoblePatternSymptomAtlasSettings
    }

    func NoblePatternSymptomAtlasSaveSettings(_ NoblePatternSymptomAtlasSettings: NoblePatternSymptomAtlasSettings) {
        guard let NoblePatternSymptomAtlasData = try? NoblePatternSymptomAtlasEncoder.encode(NoblePatternSymptomAtlasSettings) else { return }
        NoblePatternSymptomAtlasDefaults.set(NoblePatternSymptomAtlasData, forKey: NoblePatternSymptomAtlasSettingsKey)
    }

    func NoblePatternSymptomAtlasLoadTrackedSymptoms() -> [NoblePatternSymptomAtlasTrackedSymptom] {
        guard let NoblePatternSymptomAtlasData = NoblePatternSymptomAtlasDefaults.data(forKey: NoblePatternSymptomAtlasTrackedSymptomsKey),
              let NoblePatternSymptomAtlasTrackedSymptoms = try? NoblePatternSymptomAtlasDecoder.decode([NoblePatternSymptomAtlasTrackedSymptom].self, from: NoblePatternSymptomAtlasData) else {
            return []
        }
        return NoblePatternSymptomAtlasTrackedSymptoms
    }

    func NoblePatternSymptomAtlasSaveTrackedSymptoms(_ NoblePatternSymptomAtlasTrackedSymptoms: [NoblePatternSymptomAtlasTrackedSymptom]) {
        guard let NoblePatternSymptomAtlasData = try? NoblePatternSymptomAtlasEncoder.encode(NoblePatternSymptomAtlasTrackedSymptoms) else { return }
        NoblePatternSymptomAtlasDefaults.set(NoblePatternSymptomAtlasData, forKey: NoblePatternSymptomAtlasTrackedSymptomsKey)
    }

    func NoblePatternSymptomAtlasLoadTrackedSymptomCheckIns() -> [NoblePatternSymptomAtlasTrackedSymptomCheckIn] {
        guard let NoblePatternSymptomAtlasData = NoblePatternSymptomAtlasDefaults.data(forKey: NoblePatternSymptomAtlasTrackedSymptomCheckInsKey),
              let NoblePatternSymptomAtlasCheckIns = try? NoblePatternSymptomAtlasDecoder.decode([NoblePatternSymptomAtlasTrackedSymptomCheckIn].self, from: NoblePatternSymptomAtlasData) else {
            return []
        }
        return NoblePatternSymptomAtlasCheckIns.sorted { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
    }

    func NoblePatternSymptomAtlasSaveTrackedSymptomCheckIns(_ NoblePatternSymptomAtlasCheckIns: [NoblePatternSymptomAtlasTrackedSymptomCheckIn]) {
        guard let NoblePatternSymptomAtlasData = try? NoblePatternSymptomAtlasEncoder.encode(NoblePatternSymptomAtlasCheckIns) else { return }
        NoblePatternSymptomAtlasDefaults.set(NoblePatternSymptomAtlasData, forKey: NoblePatternSymptomAtlasTrackedSymptomCheckInsKey)
    }

    func NoblePatternSymptomAtlasHasSeededSampleData() -> Bool {
        NoblePatternSymptomAtlasDefaults.bool(forKey: NoblePatternSymptomAtlasSampleDataSeededKey)
    }

    func NoblePatternSymptomAtlasMarkSampleDataSeeded() {
        NoblePatternSymptomAtlasDefaults.set(true, forKey: NoblePatternSymptomAtlasSampleDataSeededKey)
    }

    func NoblePatternSymptomAtlasReset() {
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasLogsKey)
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasSettingsKey)
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasTrackedSymptomsKey)
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasTrackedSymptomCheckInsKey)
        NoblePatternSymptomAtlasMarkSampleDataSeeded()
    }
}

enum NoblePatternSymptomAtlasSampleDataFactory {
    static let NoblePatternSymptomAtlasSampleNotePrefix = "Sample data: "
    private static let NoblePatternSymptomAtlasLegacySampleNotes: Set<String> = [
        "Woke with a headache after short sleep.",
        "Felt better by afternoon.",
        "Mild nausea after breakfast.",
        "Long workday with elevated stress.",
        "Worked late and slept poorly.",
        "Severity lower later in the day.",
        "Low energy but manageable.",
        "Stress rose in the evening.",
        "Headache appeared after less than six hours of sleep.",
        "Seasonal symptoms were mild.",
        "High stress morning.",
        "Sat at desk for most of the day.",
        "Stomach discomfort after a heavy meal.",
        "Rest helped later in the day.",
        "Short sleep and early headache.",
        "Severity lower after medication and food.",
        "Brief dizziness after workout.",
        "Evening tiredness.",
        "Poor sleep before a busy morning.",
        "High stress afternoon.",
        "Mild allergy symptoms.",
        "Logged tightness during a stressful evening.",
        "Headache after waking early.",
        "Brief symptom noted before sleep."
    ]

    static func NoblePatternSymptomAtlasIsSampleLog(_ NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) -> Bool {
        NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes.hasPrefix(NoblePatternSymptomAtlasSampleNotePrefix) ||
        NoblePatternSymptomAtlasLegacySampleNotes.contains(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes)
    }

    static func NoblePatternSymptomAtlasMakeLogs(now NoblePatternSymptomAtlasNow: Date = Date(), calendar NoblePatternSymptomAtlasCalendar: Calendar = .current) -> [NoblePatternSymptomAtlasLogEntry] {
        [
            NoblePatternSymptomAtlasMakeLog(dayOffset: 0, hour: 8, minute: 20, symptoms: [.headache], severity: 6, mood: .low, sleepHours: 5, stress: .high, activity: .work, meals: "Coffee and toast", medicationName: "Ibuprofen", medicationDose: "200mg", notes: "Woke with a headache after short sleep.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: 0, hour: 13, minute: 45, symptoms: [.fatigue], severity: 3, mood: .neutral, sleepHours: 5, stress: .medium, activity: .work, meals: "Soup and crackers", medicationName: nil, medicationDose: nil, notes: "Felt better by afternoon.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -1, hour: 9, minute: 10, symptoms: [.nausea], severity: 4, mood: .neutral, sleepHours: 7, stress: .medium, activity: .walking, meals: "Light breakfast", medicationName: nil, medicationDose: nil, notes: "Mild nausea after breakfast.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -1, hour: 18, minute: 25, symptoms: [.fatigue, .anxiety], severity: 5, mood: .low, sleepHours: 7, stress: .high, activity: .work, meals: "Rice and vegetables", medicationName: nil, medicationDose: nil, notes: "Long workday with elevated stress.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -2, hour: 7, minute: 55, symptoms: [.headache, .dizziness], severity: 7, mood: .low, sleepHours: 4, stress: .high, activity: .rest, meals: "Tea", medicationName: "Ibuprofen", medicationDose: "200mg", notes: "Worked late and slept poorly.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -2, hour: 15, minute: 30, symptoms: [.headache], severity: 3, mood: .neutral, sleepHours: 4, stress: .medium, activity: .walking, meals: "Pasta", medicationName: nil, medicationDose: nil, notes: "Severity lower later in the day.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -3, hour: 10, minute: 40, symptoms: [.fatigue], severity: 4, mood: .good, sleepHours: 8, stress: .low, activity: .walking, meals: "Oatmeal and fruit", medicationName: nil, medicationDose: nil, notes: "Low energy but manageable.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -3, hour: 21, minute: 15, symptoms: [.anxiety], severity: 5, mood: .low, sleepHours: 8, stress: .high, activity: .rest, meals: "Salad", medicationName: nil, medicationDose: nil, notes: "Stress rose in the evening.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -4, hour: 6, minute: 50, symptoms: [.headache], severity: 6, mood: .neutral, sleepHours: 5, stress: .medium, activity: .rest, meals: "Coffee", medicationName: nil, medicationDose: nil, notes: "Headache appeared after less than six hours of sleep.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -4, hour: 12, minute: 5, symptoms: [.runnyNose, .soreThroat], severity: 3, mood: .good, sleepHours: 5, stress: .low, activity: .work, meals: "Sandwich", medicationName: "Cetirizine", medicationDose: "10mg", notes: "Seasonal symptoms were mild.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -5, hour: 8, minute: 35, symptoms: [.fatigue], severity: 5, mood: .low, sleepHours: 6, stress: .high, activity: .work, meals: "Toast", medicationName: nil, medicationDose: nil, notes: "High stress morning.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -5, hour: 17, minute: 50, symptoms: [.fatigue, .backPain], severity: 6, mood: .neutral, sleepHours: 6, stress: .high, activity: .work, meals: "Chicken and rice", medicationName: nil, medicationDose: nil, notes: "Sat at desk for most of the day.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -6, hour: 11, minute: 15, symptoms: [.stomachPain], severity: 4, mood: .neutral, sleepHours: 7, stress: .medium, activity: .walking, meals: "Spicy lunch", medicationName: nil, medicationDose: nil, notes: "Stomach discomfort after a heavy meal.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -6, hour: 22, minute: 10, symptoms: [.fatigue], severity: 3, mood: .good, sleepHours: 7, stress: .low, activity: .rest, meals: "Soup", medicationName: nil, medicationDose: nil, notes: "Rest helped later in the day.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -7, hour: 7, minute: 30, symptoms: [.headache], severity: 7, mood: .low, sleepHours: 4, stress: .high, activity: .work, meals: "Coffee only", medicationName: "Ibuprofen", medicationDose: "200mg", notes: "Short sleep and early headache.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -7, hour: 14, minute: 20, symptoms: [.headache], severity: 4, mood: .neutral, sleepHours: 4, stress: .medium, activity: .work, meals: "Vegetable bowl", medicationName: nil, medicationDose: nil, notes: "Severity lower after medication and food.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -8, hour: 9, minute: 0, symptoms: [.dizziness], severity: 3, mood: .good, sleepHours: 8, stress: .low, activity: .gym, meals: "Eggs and fruit", medicationName: nil, medicationDose: nil, notes: "Brief dizziness after workout.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -8, hour: 19, minute: 35, symptoms: [.fatigue], severity: 4, mood: .neutral, sleepHours: 8, stress: .medium, activity: .rest, meals: "Pasta", medicationName: nil, medicationDose: nil, notes: "Evening tiredness.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -9, hour: 8, minute: 45, symptoms: [.headache, .fatigue], severity: 6, mood: .low, sleepHours: 5, stress: .high, activity: .work, meals: "Toast and coffee", medicationName: nil, medicationDose: nil, notes: "Poor sleep before a busy morning.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -10, hour: 16, minute: 10, symptoms: [.anxiety, .fatigue], severity: 6, mood: .veryLow, sleepHours: 6, stress: .high, activity: .work, meals: "Snack", medicationName: nil, medicationDose: nil, notes: "High stress afternoon.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -11, hour: 10, minute: 25, symptoms: [.runnyNose], severity: 2, mood: .good, sleepHours: 8, stress: .low, activity: .walking, meals: "Yogurt", medicationName: "Cetirizine", medicationDose: "10mg", notes: "Mild allergy symptoms.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -12, hour: 20, minute: 5, symptoms: [.chestTightness, .anxiety], severity: 5, mood: .low, sleepHours: 7, stress: .high, activity: .rest, meals: "Rice bowl", medicationName: nil, medicationDose: nil, notes: "Logged tightness during a stressful evening.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -13, hour: 6, minute: 40, symptoms: [.headache], severity: 6, mood: .neutral, sleepHours: 5, stress: .medium, activity: .running, meals: "Banana", medicationName: nil, medicationDose: nil, notes: "Headache after waking early.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasMakeLog(dayOffset: -13, hour: 23, minute: 10, symptoms: [.shortnessOfBreath], severity: 4, mood: .neutral, sleepHours: 5, stress: .medium, activity: .rest, meals: "Light dinner", medicationName: nil, medicationDose: nil, notes: "Brief symptom noted before sleep.", now: NoblePatternSymptomAtlasNow, calendar: NoblePatternSymptomAtlasCalendar)
        ].sorted { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
    }

    private static func NoblePatternSymptomAtlasMakeLog(
        dayOffset NoblePatternSymptomAtlasDayOffset: Int,
        hour NoblePatternSymptomAtlasHour: Int,
        minute NoblePatternSymptomAtlasMinute: Int,
        symptoms NoblePatternSymptomAtlasSymptoms: [NoblePatternSymptomAtlasSymptom],
        severity NoblePatternSymptomAtlasSeverity: Double,
        mood NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMood,
        sleepHours NoblePatternSymptomAtlasSleepHours: Int,
        stress NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStressLevel,
        activity NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivity,
        meals NoblePatternSymptomAtlasMeals: String,
        medicationName NoblePatternSymptomAtlasMedicationName: String?,
        medicationDose NoblePatternSymptomAtlasMedicationDose: String?,
        notes NoblePatternSymptomAtlasNotes: String,
        now NoblePatternSymptomAtlasNow: Date,
        calendar NoblePatternSymptomAtlasCalendar: Calendar
    ) -> NoblePatternSymptomAtlasLogEntry {
        let NoblePatternSymptomAtlasBaseDay = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: NoblePatternSymptomAtlasDayOffset, to: NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasNow)) ?? NoblePatternSymptomAtlasNow
        let NoblePatternSymptomAtlasDate = NoblePatternSymptomAtlasCalendar.date(bySettingHour: NoblePatternSymptomAtlasHour, minute: NoblePatternSymptomAtlasMinute, second: 0, of: NoblePatternSymptomAtlasBaseDay) ?? NoblePatternSymptomAtlasBaseDay
        let NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedicationEntry?

        if let NoblePatternSymptomAtlasMedicationName = NoblePatternSymptomAtlasMedicationName,
           let NoblePatternSymptomAtlasMedicationDose = NoblePatternSymptomAtlasMedicationDose {
            NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasMedicationEntry(
                NoblePatternSymptomAtlasName: NoblePatternSymptomAtlasMedicationName,
                NoblePatternSymptomAtlasDose: NoblePatternSymptomAtlasMedicationDose,
                NoblePatternSymptomAtlasTime: NoblePatternSymptomAtlasDate
            )
        } else {
            NoblePatternSymptomAtlasMedication = nil
        }

        return NoblePatternSymptomAtlasLogEntry(
            NoblePatternSymptomAtlasSymptoms: NoblePatternSymptomAtlasSymptoms,
            NoblePatternSymptomAtlasSeverity: NoblePatternSymptomAtlasSeverity,
            NoblePatternSymptomAtlasDate: NoblePatternSymptomAtlasDate,
            NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMood,
            NoblePatternSymptomAtlasSleepHours: NoblePatternSymptomAtlasSleepHours,
            NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStress,
            NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivity,
            NoblePatternSymptomAtlasMeals: NoblePatternSymptomAtlasMeals,
            NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedication,
            NoblePatternSymptomAtlasNotes: NoblePatternSymptomAtlasSampleNotePrefix + NoblePatternSymptomAtlasNotes
        )
    }
}

enum NoblePatternSymptomAtlasAnalyticsService {
    static func NoblePatternSymptomAtlasSummary(for NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar = .current) -> NoblePatternSymptomAtlasPatternSummary {
        guard !NoblePatternSymptomAtlasLogs.isEmpty else {
            return .NoblePatternSymptomAtlasEmpty
        }

        let NoblePatternSymptomAtlasSymptomPairs = NoblePatternSymptomAtlasSymptom.allCases.map { NoblePatternSymptomAtlasSymptom in
            (NoblePatternSymptomAtlasSymptom, NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasSymptom) }.count)
        }
        let NoblePatternSymptomAtlasTopSymptoms = NoblePatternSymptomAtlasSymptomPairs
            .filter { $0.1 > 0 }
            .sorted { $0.1 == $1.1 ? $0.0.rawValue < $1.0.rawValue : $0.1 > $1.1 }
            .prefix(5)
            .map { $0 }

        let NoblePatternSymptomAtlasBucketCounts = NoblePatternSymptomAtlasTimeBucket.allCases.map { NoblePatternSymptomAtlasBucket in
            (NoblePatternSymptomAtlasBucket, NoblePatternSymptomAtlasLogs.filter { NoblePatternSymptomAtlasTimeBucket.NoblePatternSymptomAtlasBucket(for: $0.NoblePatternSymptomAtlasDate, calendar: NoblePatternSymptomAtlasCalendar) == NoblePatternSymptomAtlasBucket }.count)
        }
        let NoblePatternSymptomAtlasMostActiveTime = NoblePatternSymptomAtlasBucketCounts.max { $0.1 < $1.1 }?.0

        let NoblePatternSymptomAtlasSleepPattern = NoblePatternSymptomAtlasSleepSummary(NoblePatternSymptomAtlasLogs)
        let NoblePatternSymptomAtlasStressPattern = NoblePatternSymptomAtlasStressSummary(NoblePatternSymptomAtlasLogs)
        let NoblePatternSymptomAtlasWeekdayPattern = NoblePatternSymptomAtlasWeekdaySummary(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar)
        let NoblePatternSymptomAtlasMoodPattern = NoblePatternSymptomAtlasMoodSummary(NoblePatternSymptomAtlasLogs)
        let NoblePatternSymptomAtlasMedicationPattern = NoblePatternSymptomAtlasMedicationSummary(NoblePatternSymptomAtlasLogs)

        return NoblePatternSymptomAtlasPatternSummary(
            NoblePatternSymptomAtlasTopSymptoms: NoblePatternSymptomAtlasTopSymptoms,
            NoblePatternSymptomAtlasMostActiveTime: NoblePatternSymptomAtlasMostActiveTime,
            NoblePatternSymptomAtlasSleepPattern: NoblePatternSymptomAtlasSleepPattern,
            NoblePatternSymptomAtlasStressPattern: NoblePatternSymptomAtlasStressPattern,
            NoblePatternSymptomAtlasWeekdayPattern: NoblePatternSymptomAtlasWeekdayPattern,
            NoblePatternSymptomAtlasMoodPattern: NoblePatternSymptomAtlasMoodPattern,
            NoblePatternSymptomAtlasMedicationPattern: NoblePatternSymptomAtlasMedicationPattern,
            NoblePatternSymptomAtlasRecentPattern: NoblePatternSymptomAtlasSleepPattern,
            NoblePatternSymptomAtlasInsights: NoblePatternSymptomAtlasInsights(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasDailySeverity: NoblePatternSymptomAtlasDailySeverity(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar),
            NoblePatternSymptomAtlasTimeBuckets: NoblePatternSymptomAtlasBucketCounts,
            NoblePatternSymptomAtlasHeatmap: NoblePatternSymptomAtlasHeatmap(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar)
        )
    }

    static func NoblePatternSymptomAtlasFilteredLogs(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], filter NoblePatternSymptomAtlasFilter: NoblePatternSymptomAtlasReportFilter, calendar NoblePatternSymptomAtlasCalendar: Calendar = .current) -> [NoblePatternSymptomAtlasLogEntry] {
        let NoblePatternSymptomAtlasStart = NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasDateFrom)
        let NoblePatternSymptomAtlasEnd = NoblePatternSymptomAtlasCalendar.date(bySettingHour: 23, minute: 59, second: 59, of: NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasDateTo) ?? NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasDateTo
        return NoblePatternSymptomAtlasLogs.filter {
            $0.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasStart && $0.NoblePatternSymptomAtlasDate <= NoblePatternSymptomAtlasEnd
        }
    }

    private static func NoblePatternSymptomAtlasSleepSummary(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> String {
        let NoblePatternSymptomAtlasShortSleep = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSleepHours < 6 }
        guard !NoblePatternSymptomAtlasShortSleep.isEmpty else {
            return "Possible correlation: Sleep under 6 hours has not been logged often enough yet."
        }
        let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasMostCommonSymptom(in: NoblePatternSymptomAtlasShortSleep)
        return "Possible correlation: Less than 6h sleep -> \(NoblePatternSymptomAtlasTop?.rawValue ?? "symptoms") appears more often."
    }

    private static func NoblePatternSymptomAtlasStressSummary(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> String {
        let NoblePatternSymptomAtlasHigh = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasStress == .high }
        let NoblePatternSymptomAtlasOther = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasStress != .high }
        guard !NoblePatternSymptomAtlasHigh.isEmpty, !NoblePatternSymptomAtlasOther.isEmpty else {
            return "Possible correlation: High stress needs more comparison logs."
        }
        let NoblePatternSymptomAtlasHighAverage = Double(NoblePatternSymptomAtlasHigh.flatMap(\.NoblePatternSymptomAtlasSymptoms).count) / Double(NoblePatternSymptomAtlasHigh.count)
        let NoblePatternSymptomAtlasOtherAverage = max(0.1, Double(NoblePatternSymptomAtlasOther.flatMap(\.NoblePatternSymptomAtlasSymptoms).count) / Double(NoblePatternSymptomAtlasOther.count))
        let NoblePatternSymptomAtlasLift = max(0, Int(((NoblePatternSymptomAtlasHighAverage / NoblePatternSymptomAtlasOtherAverage) - 1) * 100))
        return "Possible correlation: High stress -> symptoms logged \(NoblePatternSymptomAtlasLift)% more frequently."
    }

    private static func NoblePatternSymptomAtlasWeekdaySummary(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> String {
        let NoblePatternSymptomAtlasSymbols = NoblePatternSymptomAtlasCalendar.weekdaySymbols
        var NoblePatternSymptomAtlasCounts: [Int: Int] = [:]
        for NoblePatternSymptomAtlasLog in NoblePatternSymptomAtlasLogs {
            let NoblePatternSymptomAtlasWeekday = NoblePatternSymptomAtlasCalendar.component(.weekday, from: NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate)
            NoblePatternSymptomAtlasCounts[NoblePatternSymptomAtlasWeekday, default: 0] += NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.count
        }
        let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasCounts.sorted { $0.value > $1.value }.prefix(2).map { NoblePatternSymptomAtlasSymbols[$0.key - 1] }
        return NoblePatternSymptomAtlasTop.isEmpty ? "Possible pattern: Weekday patterns need more logs." : "Possible pattern: Most symptoms appear on \(NoblePatternSymptomAtlasTop.joined(separator: " and "))."
    }

    private static func NoblePatternSymptomAtlasMoodSummary(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> String {
        let NoblePatternSymptomAtlasLowMood = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasIsLow }
        guard !NoblePatternSymptomAtlasLowMood.isEmpty else {
            return "Possible correlation: Low mood needs more logs for comparison."
        }
        return "Possible correlation: Symptoms occur more frequently when mood is Low."
    }

    private static func NoblePatternSymptomAtlasMedicationSummary(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> String {
        let NoblePatternSymptomAtlasMedicationLogs = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasMedication != nil }
        guard let NoblePatternSymptomAtlasMedicationName = NoblePatternSymptomAtlasMedicationLogs.first?.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName, !NoblePatternSymptomAtlasMedicationName.isEmpty else {
            return "Possible pattern: Medication severity trends need medication logs."
        }
        let NoblePatternSymptomAtlasAverage = NoblePatternSymptomAtlasMedicationLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasMedicationLogs.count)
        let NoblePatternSymptomAtlasAllAverage = NoblePatternSymptomAtlasLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasLogs.count)
        let NoblePatternSymptomAtlasTrend = NoblePatternSymptomAtlasAverage <= NoblePatternSymptomAtlasAllAverage ? "tends to decrease" : "varies"
        return "Possible correlation: Symptom severity \(NoblePatternSymptomAtlasTrend) after \(NoblePatternSymptomAtlasMedicationName)."
    }

    private static func NoblePatternSymptomAtlasMostCommonSymptom(in NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasSymptom? {
        NoblePatternSymptomAtlasSymptom.allCases.max { NoblePatternSymptomAtlasLeft, NoblePatternSymptomAtlasRight in
            NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasLeft) }.count <
            NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasRight) }.count
        }
    }

    private static func NoblePatternSymptomAtlasDailySeverity(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> [(Date, Double)] {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasLogs) { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }
        return NoblePatternSymptomAtlasGrouped.map { NoblePatternSymptomAtlasDay, NoblePatternSymptomAtlasDayLogs in
            (NoblePatternSymptomAtlasDay, NoblePatternSymptomAtlasDayLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasDayLogs.count))
        }.sorted { $0.0 < $1.0 }
    }

    private static func NoblePatternSymptomAtlasHeatmap(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> [(Date, Int)] {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasLogs) { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }
        return NoblePatternSymptomAtlasGrouped.map { ($0.key, $0.value.flatMap(\.NoblePatternSymptomAtlasSymptoms).count) }.sorted { $0.0 < $1.0 }
    }

    private static func NoblePatternSymptomAtlasInsights(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> [NoblePatternSymptomAtlasPatternInsight] {
        var NoblePatternSymptomAtlasInsights: [NoblePatternSymptomAtlasPatternInsight] = []
        NoblePatternSymptomAtlasSeverityByTimeInsight(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasSymptomClusterInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasSameDayDirectionInsight(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasRepeatSymptomInsight(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasQuietDaysInsight(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasActivityInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasSleepRangeInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasLowMoodInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasMedicationInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasRecentChangeInsight(NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).map { NoblePatternSymptomAtlasInsights.append($0) }
        NoblePatternSymptomAtlasConsistencyInsight(NoblePatternSymptomAtlasLogs).map { NoblePatternSymptomAtlasInsights.append($0) }

        let NoblePatternSymptomAtlasPrioritized = NoblePatternSymptomAtlasInsights.sorted {
            if $0.NoblePatternSymptomAtlasDataCount == $1.NoblePatternSymptomAtlasDataCount {
                return $0.NoblePatternSymptomAtlasTitle < $1.NoblePatternSymptomAtlasTitle
            }
            return $0.NoblePatternSymptomAtlasDataCount > $1.NoblePatternSymptomAtlasDataCount
        }

        if NoblePatternSymptomAtlasPrioritized.isEmpty {
            return [
                NoblePatternSymptomAtlasPatternInsight(
                    id: "more-logs-needed",
                    NoblePatternSymptomAtlasTitle: "More Logs Needed",
                    NoblePatternSymptomAtlasText: "Possible pattern: Add more logs to unlock local insights.",
                    NoblePatternSymptomAtlasCategory: "Data",
                    NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasLogs.count,
                    NoblePatternSymptomAtlasExplanation: "Insights are based only on logs saved on this device."
                )
            ]
        }

        return Array(NoblePatternSymptomAtlasPrioritized.prefix(8))
    }

    private static func NoblePatternSymptomAtlasSeverityByTimeInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasLogs) {
            NoblePatternSymptomAtlasTimeBucket.NoblePatternSymptomAtlasBucket(for: $0.NoblePatternSymptomAtlasDate, calendar: NoblePatternSymptomAtlasCalendar)
        }
        let NoblePatternSymptomAtlasAverages = NoblePatternSymptomAtlasGrouped.compactMap { NoblePatternSymptomAtlasBucket, NoblePatternSymptomAtlasBucketLogs -> (NoblePatternSymptomAtlasTimeBucket, Double, Int)? in
            guard NoblePatternSymptomAtlasBucketLogs.count >= 2 else { return nil }
            let NoblePatternSymptomAtlasAverage = NoblePatternSymptomAtlasBucketLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasBucketLogs.count)
            return (NoblePatternSymptomAtlasBucket, NoblePatternSymptomAtlasAverage, NoblePatternSymptomAtlasBucketLogs.count)
        }
        guard let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasAverages.max(by: { $0.1 < $1.1 }) else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "severity-time-\(NoblePatternSymptomAtlasTop.0.rawValue)",
            NoblePatternSymptomAtlasTitle: "Severity by Time",
            NoblePatternSymptomAtlasText: "Possible pattern: Average severity is higher during \(NoblePatternSymptomAtlasTop.0.rawValue.lowercased()).",
            NoblePatternSymptomAtlasCategory: "Severity",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTop.2,
            NoblePatternSymptomAtlasExplanation: "Based on \(NoblePatternSymptomAtlasTop.2) \(NoblePatternSymptomAtlasTop.0.rawValue.lowercased()) logs with average severity \(NoblePatternSymptomAtlasFormat(NoblePatternSymptomAtlasTop.1))."
        )
    }

    private static func NoblePatternSymptomAtlasSymptomClusterInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        var NoblePatternSymptomAtlasPairs: [String: (NoblePatternSymptomAtlasSymptom, NoblePatternSymptomAtlasSymptom, Int)] = [:]
        for NoblePatternSymptomAtlasLog in NoblePatternSymptomAtlasLogs where NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.count > 1 {
            let NoblePatternSymptomAtlasSymptoms = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.sorted { $0.rawValue < $1.rawValue }
            for NoblePatternSymptomAtlasLeftIndex in NoblePatternSymptomAtlasSymptoms.indices {
                for NoblePatternSymptomAtlasRightIndex in NoblePatternSymptomAtlasSymptoms.indices where NoblePatternSymptomAtlasRightIndex > NoblePatternSymptomAtlasLeftIndex {
                    let NoblePatternSymptomAtlasLeft = NoblePatternSymptomAtlasSymptoms[NoblePatternSymptomAtlasLeftIndex]
                    let NoblePatternSymptomAtlasRight = NoblePatternSymptomAtlasSymptoms[NoblePatternSymptomAtlasRightIndex]
                    let NoblePatternSymptomAtlasKey = "\(NoblePatternSymptomAtlasLeft.rawValue)-\(NoblePatternSymptomAtlasRight.rawValue)"
                    let NoblePatternSymptomAtlasCurrent = NoblePatternSymptomAtlasPairs[NoblePatternSymptomAtlasKey]?.2 ?? 0
                    NoblePatternSymptomAtlasPairs[NoblePatternSymptomAtlasKey] = (NoblePatternSymptomAtlasLeft, NoblePatternSymptomAtlasRight, NoblePatternSymptomAtlasCurrent + 1)
                }
            }
        }
        guard let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasPairs.values.max(by: { $0.2 < $1.2 }), NoblePatternSymptomAtlasTop.2 >= 2 else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "cluster-\(NoblePatternSymptomAtlasTop.0.rawValue)-\(NoblePatternSymptomAtlasTop.1.rawValue)",
            NoblePatternSymptomAtlasTitle: "Symptom Cluster",
            NoblePatternSymptomAtlasText: "Possible pattern: \(NoblePatternSymptomAtlasTop.0.rawValue) and \(NoblePatternSymptomAtlasTop.1.rawValue) appear together.",
            NoblePatternSymptomAtlasCategory: "Symptoms",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTop.2,
            NoblePatternSymptomAtlasExplanation: "This pair appears together in \(NoblePatternSymptomAtlasTop.2) saved logs."
        )
    }

    private static func NoblePatternSymptomAtlasSameDayDirectionInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasLogs) { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }
        var NoblePatternSymptomAtlasLower = 0
        var NoblePatternSymptomAtlasHigher = 0
        for NoblePatternSymptomAtlasDayLogs in NoblePatternSymptomAtlasGrouped.values {
            let NoblePatternSymptomAtlasSorted = NoblePatternSymptomAtlasDayLogs.sorted { $0.NoblePatternSymptomAtlasDate < $1.NoblePatternSymptomAtlasDate }
            guard let NoblePatternSymptomAtlasFirst = NoblePatternSymptomAtlasSorted.first, let NoblePatternSymptomAtlasLast = NoblePatternSymptomAtlasSorted.last, NoblePatternSymptomAtlasSorted.count >= 2 else { continue }
            if NoblePatternSymptomAtlasLast.NoblePatternSymptomAtlasSeverity < NoblePatternSymptomAtlasFirst.NoblePatternSymptomAtlasSeverity {
                NoblePatternSymptomAtlasLower += 1
            } else if NoblePatternSymptomAtlasLast.NoblePatternSymptomAtlasSeverity > NoblePatternSymptomAtlasFirst.NoblePatternSymptomAtlasSeverity {
                NoblePatternSymptomAtlasHigher += 1
            }
        }
        let NoblePatternSymptomAtlasComparedDays = NoblePatternSymptomAtlasLower + NoblePatternSymptomAtlasHigher
        guard NoblePatternSymptomAtlasComparedDays >= 2 else { return nil }
        let NoblePatternSymptomAtlasDirection = NoblePatternSymptomAtlasLower >= NoblePatternSymptomAtlasHigher ? "lower" : "higher"
        return NoblePatternSymptomAtlasPatternInsight(
            id: "same-day-direction",
            NoblePatternSymptomAtlasTitle: "Same-Day Direction",
            NoblePatternSymptomAtlasText: "Possible pattern: Later same-day severity is often \(NoblePatternSymptomAtlasDirection).",
            NoblePatternSymptomAtlasCategory: "Severity",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasComparedDays,
            NoblePatternSymptomAtlasExplanation: "Compared first and last logs on \(NoblePatternSymptomAtlasComparedDays) days with multiple entries."
        )
    }

    private static func NoblePatternSymptomAtlasRepeatSymptomInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> NoblePatternSymptomAtlasPatternInsight? {
        var NoblePatternSymptomAtlasBestSymptom: NoblePatternSymptomAtlasSymptom?
        var NoblePatternSymptomAtlasBestStreak = 0
        for NoblePatternSymptomAtlasSymptom in NoblePatternSymptomAtlasSymptom.allCases {
            let NoblePatternSymptomAtlasDays = Set(NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasSymptom) }.map { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }).sorted()
            var NoblePatternSymptomAtlasCurrent = 0
            var NoblePatternSymptomAtlasPrevious: Date?
            for NoblePatternSymptomAtlasDay in NoblePatternSymptomAtlasDays {
                if let NoblePatternSymptomAtlasPrevious = NoblePatternSymptomAtlasPrevious,
                   NoblePatternSymptomAtlasCalendar.dateComponents([.day], from: NoblePatternSymptomAtlasPrevious, to: NoblePatternSymptomAtlasDay).day == 1 {
                    NoblePatternSymptomAtlasCurrent += 1
                } else {
                    NoblePatternSymptomAtlasCurrent = 1
                }
                NoblePatternSymptomAtlasPrevious = NoblePatternSymptomAtlasDay
                if NoblePatternSymptomAtlasCurrent > NoblePatternSymptomAtlasBestStreak {
                    NoblePatternSymptomAtlasBestStreak = NoblePatternSymptomAtlasCurrent
                    NoblePatternSymptomAtlasBestSymptom = NoblePatternSymptomAtlasSymptom
                }
            }
        }
        guard let NoblePatternSymptomAtlasSymptom = NoblePatternSymptomAtlasBestSymptom, NoblePatternSymptomAtlasBestStreak >= 2 else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "repeat-\(NoblePatternSymptomAtlasSymptom.rawValue)",
            NoblePatternSymptomAtlasTitle: "Repeat Symptoms",
            NoblePatternSymptomAtlasText: "Possible pattern: \(NoblePatternSymptomAtlasSymptom.rawValue) appears across consecutive days.",
            NoblePatternSymptomAtlasCategory: "Symptoms",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasBestStreak,
            NoblePatternSymptomAtlasExplanation: "Longest local streak: \(NoblePatternSymptomAtlasBestStreak) consecutive days."
        )
    }

    private static func NoblePatternSymptomAtlasQuietDaysInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> NoblePatternSymptomAtlasPatternInsight? {
        guard let NoblePatternSymptomAtlasFirst = NoblePatternSymptomAtlasLogs.map(\.NoblePatternSymptomAtlasDate).min(), let NoblePatternSymptomAtlasLast = NoblePatternSymptomAtlasLogs.map(\.NoblePatternSymptomAtlasDate).max() else { return nil }
        let NoblePatternSymptomAtlasStart = NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasFirst)
        let NoblePatternSymptomAtlasEnd = NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasLast)
        let NoblePatternSymptomAtlasTotalDays = (NoblePatternSymptomAtlasCalendar.dateComponents([.day], from: NoblePatternSymptomAtlasStart, to: NoblePatternSymptomAtlasEnd).day ?? 0) + 1
        let NoblePatternSymptomAtlasLoggedDays = Set(NoblePatternSymptomAtlasLogs.map { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }).count
        let NoblePatternSymptomAtlasQuietDays = max(0, NoblePatternSymptomAtlasTotalDays - NoblePatternSymptomAtlasLoggedDays)
        guard NoblePatternSymptomAtlasTotalDays >= 5, NoblePatternSymptomAtlasQuietDays > 0 else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "quiet-days",
            NoblePatternSymptomAtlasTitle: "Quiet Days",
            NoblePatternSymptomAtlasText: "Possible pattern: \(NoblePatternSymptomAtlasQuietDays) days in this range have no symptom logs.",
            NoblePatternSymptomAtlasCategory: "Calendar",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTotalDays,
            NoblePatternSymptomAtlasExplanation: "Checked \(NoblePatternSymptomAtlasTotalDays) calendar days between the first and latest saved log."
        )
    }

    private static func NoblePatternSymptomAtlasActivityInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasLogs) { $0.NoblePatternSymptomAtlasActivity }
        let NoblePatternSymptomAtlasAverages = NoblePatternSymptomAtlasGrouped.compactMap { NoblePatternSymptomAtlasActivity, NoblePatternSymptomAtlasActivityLogs -> (NoblePatternSymptomAtlasActivity, Double, Int)? in
            guard NoblePatternSymptomAtlasActivityLogs.count >= 2 else { return nil }
            let NoblePatternSymptomAtlasAverage = Double(NoblePatternSymptomAtlasActivityLogs.flatMap(\.NoblePatternSymptomAtlasSymptoms).count) / Double(NoblePatternSymptomAtlasActivityLogs.count)
            return (NoblePatternSymptomAtlasActivity, NoblePatternSymptomAtlasAverage, NoblePatternSymptomAtlasActivityLogs.count)
        }
        guard let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasAverages.max(by: { $0.1 < $1.1 }) else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "activity-\(NoblePatternSymptomAtlasTop.0.rawValue)",
            NoblePatternSymptomAtlasTitle: "Activity Association",
            NoblePatternSymptomAtlasText: "Possible correlation: More symptoms are logged during \(NoblePatternSymptomAtlasTop.0.rawValue).",
            NoblePatternSymptomAtlasCategory: "Activity",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTop.2,
            NoblePatternSymptomAtlasExplanation: "\(NoblePatternSymptomAtlasTop.2) \(NoblePatternSymptomAtlasTop.0.rawValue) logs average \(NoblePatternSymptomAtlasFormat(NoblePatternSymptomAtlasTop.1)) symptoms per log."
        )
    }

    private static func NoblePatternSymptomAtlasSleepRangeInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasRanges: [(String, (Int) -> Bool)] = [
            ("under 6h", { $0 < 6 }),
            ("6-7h", { $0 >= 6 && $0 < 8 }),
            ("8h+", { $0 >= 8 })
        ]
        let NoblePatternSymptomAtlasAverages = NoblePatternSymptomAtlasRanges.compactMap { NoblePatternSymptomAtlasLabel, NoblePatternSymptomAtlasMatches -> (String, Double, Int)? in
            let NoblePatternSymptomAtlasRangeLogs = NoblePatternSymptomAtlasLogs.filter { NoblePatternSymptomAtlasMatches($0.NoblePatternSymptomAtlasSleepHours) }
            guard NoblePatternSymptomAtlasRangeLogs.count >= 2 else { return nil }
            let NoblePatternSymptomAtlasAverage = Double(NoblePatternSymptomAtlasRangeLogs.flatMap(\.NoblePatternSymptomAtlasSymptoms).count) / Double(NoblePatternSymptomAtlasRangeLogs.count)
            return (NoblePatternSymptomAtlasLabel, NoblePatternSymptomAtlasAverage, NoblePatternSymptomAtlasRangeLogs.count)
        }
        guard let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasAverages.max(by: { $0.1 < $1.1 }) else { return nil }
        return NoblePatternSymptomAtlasPatternInsight(
            id: "sleep-range-\(NoblePatternSymptomAtlasTop.0)",
            NoblePatternSymptomAtlasTitle: "Sleep Range",
            NoblePatternSymptomAtlasText: "Possible correlation: Symptoms appear more often after \(NoblePatternSymptomAtlasTop.0) sleep.",
            NoblePatternSymptomAtlasCategory: "Sleep",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTop.2,
            NoblePatternSymptomAtlasExplanation: "\(NoblePatternSymptomAtlasTop.2) logs in this sleep range average \(NoblePatternSymptomAtlasFormat(NoblePatternSymptomAtlasTop.1)) symptoms per log."
        )
    }

    private static func NoblePatternSymptomAtlasLowMoodInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasLowMoodLogs = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasIsLow }
        guard NoblePatternSymptomAtlasLowMoodLogs.count >= 2, let NoblePatternSymptomAtlasTop = NoblePatternSymptomAtlasMostCommonSymptom(in: NoblePatternSymptomAtlasLowMoodLogs) else { return nil }
        let NoblePatternSymptomAtlasCount = NoblePatternSymptomAtlasLowMoodLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasTop) }.count
        return NoblePatternSymptomAtlasPatternInsight(
            id: "low-mood-\(NoblePatternSymptomAtlasTop.rawValue)",
            NoblePatternSymptomAtlasTitle: "Mood Distribution",
            NoblePatternSymptomAtlasText: "Possible correlation: \(NoblePatternSymptomAtlasTop.rawValue) appears most often with Low mood logs.",
            NoblePatternSymptomAtlasCategory: "Mood",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasLowMoodLogs.count,
            NoblePatternSymptomAtlasExplanation: "\(NoblePatternSymptomAtlasCount) of \(NoblePatternSymptomAtlasLowMoodLogs.count) Low or Very Low mood logs include \(NoblePatternSymptomAtlasTop.rawValue)."
        )
    }

    private static func NoblePatternSymptomAtlasMedicationInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        let NoblePatternSymptomAtlasMedicationGroups = Dictionary(grouping: NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasMedication != nil }) { $0.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName ?? "" }
        guard let NoblePatternSymptomAtlasTopGroup = NoblePatternSymptomAtlasMedicationGroups.filter({ !$0.key.isEmpty && $0.value.count >= 2 }).max(by: { $0.value.count < $1.value.count }) else { return nil }
        let NoblePatternSymptomAtlasMedicationAverage = NoblePatternSymptomAtlasTopGroup.value.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasTopGroup.value.count)
        let NoblePatternSymptomAtlasAllAverage = NoblePatternSymptomAtlasLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasLogs.count)
        let NoblePatternSymptomAtlasDirection = NoblePatternSymptomAtlasMedicationAverage <= NoblePatternSymptomAtlasAllAverage ? "lower" : "different"
        return NoblePatternSymptomAtlasPatternInsight(
            id: "medication-\(NoblePatternSymptomAtlasTopGroup.key)",
            NoblePatternSymptomAtlasTitle: "Medication Trend",
            NoblePatternSymptomAtlasText: "Possible correlation: Severity is \(NoblePatternSymptomAtlasDirection) in logs with \(NoblePatternSymptomAtlasTopGroup.key).",
            NoblePatternSymptomAtlasCategory: "Medication",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasTopGroup.value.count,
            NoblePatternSymptomAtlasExplanation: "\(NoblePatternSymptomAtlasTopGroup.value.count) logs with \(NoblePatternSymptomAtlasTopGroup.key) average severity \(NoblePatternSymptomAtlasFormat(NoblePatternSymptomAtlasMedicationAverage)); all logs average \(NoblePatternSymptomAtlasFormat(NoblePatternSymptomAtlasAllAverage))."
        )
    }

    private static func NoblePatternSymptomAtlasRecentChangeInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], calendar NoblePatternSymptomAtlasCalendar: Calendar) -> NoblePatternSymptomAtlasPatternInsight? {
        guard let NoblePatternSymptomAtlasLatest = NoblePatternSymptomAtlasLogs.map(\.NoblePatternSymptomAtlasDate).max(),
              let NoblePatternSymptomAtlasCurrentStart = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -6, to: NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasLatest)),
              let NoblePatternSymptomAtlasPreviousStart = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -7, to: NoblePatternSymptomAtlasCurrentStart) else { return nil }
        let NoblePatternSymptomAtlasCurrent = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasCurrentStart }
        let NoblePatternSymptomAtlasPrevious = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasPreviousStart && $0.NoblePatternSymptomAtlasDate < NoblePatternSymptomAtlasCurrentStart }
        guard !NoblePatternSymptomAtlasCurrent.isEmpty, !NoblePatternSymptomAtlasPrevious.isEmpty else { return nil }
        let NoblePatternSymptomAtlasCurrentCount = NoblePatternSymptomAtlasCurrent.flatMap(\.NoblePatternSymptomAtlasSymptoms).count
        let NoblePatternSymptomAtlasPreviousCount = NoblePatternSymptomAtlasPrevious.flatMap(\.NoblePatternSymptomAtlasSymptoms).count
        let NoblePatternSymptomAtlasDirection = NoblePatternSymptomAtlasCurrentCount >= NoblePatternSymptomAtlasPreviousCount ? "more" : "fewer"
        return NoblePatternSymptomAtlasPatternInsight(
            id: "recent-change",
            NoblePatternSymptomAtlasTitle: "Recent Change",
            NoblePatternSymptomAtlasText: "Possible pattern: This week has \(NoblePatternSymptomAtlasDirection) symptom logs than the previous week.",
            NoblePatternSymptomAtlasCategory: "Week",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasCurrent.count + NoblePatternSymptomAtlasPrevious.count,
            NoblePatternSymptomAtlasExplanation: "Current 7-day symptoms: \(NoblePatternSymptomAtlasCurrentCount). Previous 7-day symptoms: \(NoblePatternSymptomAtlasPreviousCount)."
        )
    }

    private static func NoblePatternSymptomAtlasConsistencyInsight(_ NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]) -> NoblePatternSymptomAtlasPatternInsight? {
        guard NoblePatternSymptomAtlasLogs.count >= 3 else { return nil }
        let NoblePatternSymptomAtlasNotesCount = NoblePatternSymptomAtlasLogs.filter { !$0.NoblePatternSymptomAtlasNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count
        let NoblePatternSymptomAtlasMedicationCount = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasMedication != nil }.count
        let NoblePatternSymptomAtlasFocus = NoblePatternSymptomAtlasNotesCount < NoblePatternSymptomAtlasMedicationCount ? "notes" : "medication"
        let NoblePatternSymptomAtlasCount = min(NoblePatternSymptomAtlasNotesCount, NoblePatternSymptomAtlasMedicationCount)
        return NoblePatternSymptomAtlasPatternInsight(
            id: "consistency-\(NoblePatternSymptomAtlasFocus)",
            NoblePatternSymptomAtlasTitle: "Data Consistency",
            NoblePatternSymptomAtlasText: "Possible pattern: \(NoblePatternSymptomAtlasFocus.capitalized) appear in fewer saved logs.",
            NoblePatternSymptomAtlasCategory: "Data",
            NoblePatternSymptomAtlasDataCount: NoblePatternSymptomAtlasLogs.count,
            NoblePatternSymptomAtlasExplanation: "\(NoblePatternSymptomAtlasCount) of \(NoblePatternSymptomAtlasLogs.count) logs include \(NoblePatternSymptomAtlasFocus)."
        )
    }

    private static func NoblePatternSymptomAtlasFormat(_ NoblePatternSymptomAtlasValue: Double) -> String {
        String(format: "%.1f", NoblePatternSymptomAtlasValue)
    }

    static func NoblePatternSymptomAtlasMakeSymptomDetail(
        for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom,
        logs NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry],
        calendar NoblePatternSymptomAtlasCalendar: Calendar = .current
    ) -> NoblePatternSymptomAtlasSymptomDetailSummary {
        let NoblePatternSymptomAtlasSymptomLogs = NoblePatternSymptomAtlasLogs
            .filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasSymptom) }
            .sorted { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        let NoblePatternSymptomAtlasAverageSeverity = NoblePatternSymptomAtlasSymptomLogs.isEmpty ? nil : NoblePatternSymptomAtlasSymptomLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasSymptomLogs.count)
        let NoblePatternSymptomAtlasBuckets = Dictionary(grouping: NoblePatternSymptomAtlasSymptomLogs) {
            NoblePatternSymptomAtlasTimeBucket.NoblePatternSymptomAtlasBucket(for: $0.NoblePatternSymptomAtlasDate, calendar: NoblePatternSymptomAtlasCalendar)
        }
        let NoblePatternSymptomAtlasCommonTime = NoblePatternSymptomAtlasBuckets.max { $0.value.count < $1.value.count }?.key
        let NoblePatternSymptomAtlasLowSleepCount = NoblePatternSymptomAtlasSymptomLogs.filter { $0.NoblePatternSymptomAtlasSleepHours < 6 }.count
        let NoblePatternSymptomAtlasHighStressCount = NoblePatternSymptomAtlasSymptomLogs.filter { $0.NoblePatternSymptomAtlasStress == .high }.count
        let NoblePatternSymptomAtlasPatterns = [
            NoblePatternSymptomAtlasLowSleepCount > 0 ? "Possible correlation: \(NoblePatternSymptomAtlasSymptom.rawValue) appears in \(NoblePatternSymptomAtlasLowSleepCount) logs after sleep under 6h." : nil,
            NoblePatternSymptomAtlasHighStressCount > 0 ? "Possible correlation: \(NoblePatternSymptomAtlasSymptom.rawValue) appears in \(NoblePatternSymptomAtlasHighStressCount) high stress logs." : nil,
            NoblePatternSymptomAtlasCommonTime.map { "Possible pattern: \(NoblePatternSymptomAtlasSymptom.rawValue) appears most often in the \($0.rawValue.lowercased())." }
        ].compactMap { $0 }

        return NoblePatternSymptomAtlasSymptomDetailSummary(
            NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom,
            NoblePatternSymptomAtlasLoggedCount: NoblePatternSymptomAtlasSymptomLogs.count,
            NoblePatternSymptomAtlasAverageSeverity: NoblePatternSymptomAtlasAverageSeverity,
            NoblePatternSymptomAtlasCommonTime: NoblePatternSymptomAtlasCommonTime,
            NoblePatternSymptomAtlasRecentEntries: Array(NoblePatternSymptomAtlasSymptomLogs.prefix(5)),
            NoblePatternSymptomAtlasRelatedPatterns: NoblePatternSymptomAtlasPatterns.isEmpty ? ["Possible pattern: More logs needed for this symptom."] : NoblePatternSymptomAtlasPatterns
        )
    }

    static func NoblePatternSymptomAtlasMakeWeeklyReview(
        logs NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry],
        week NoblePatternSymptomAtlasWeek: Date = Date(),
        calendar NoblePatternSymptomAtlasCalendar: Calendar = .current
    ) -> NoblePatternSymptomAtlasWeeklyReview {
        let NoblePatternSymptomAtlasInterval = NoblePatternSymptomAtlasCalendar.dateInterval(of: .weekOfYear, for: NoblePatternSymptomAtlasWeek)
        let NoblePatternSymptomAtlasStart = NoblePatternSymptomAtlasInterval?.start ?? NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasWeek)
        let NoblePatternSymptomAtlasEnd = NoblePatternSymptomAtlasInterval?.end ?? (NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: 7, to: NoblePatternSymptomAtlasStart) ?? NoblePatternSymptomAtlasStart)
        let NoblePatternSymptomAtlasWeekLogs = NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasStart && $0.NoblePatternSymptomAtlasDate < NoblePatternSymptomAtlasEnd }
        let NoblePatternSymptomAtlasMostCommonSymptom = NoblePatternSymptomAtlasMostCommonSymptom(in: NoblePatternSymptomAtlasWeekLogs)
        let NoblePatternSymptomAtlasAverageSeverity = NoblePatternSymptomAtlasWeekLogs.isEmpty ? nil : NoblePatternSymptomAtlasWeekLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasWeekLogs.count)
        let NoblePatternSymptomAtlasLoggedDays = Set(NoblePatternSymptomAtlasWeekLogs.map { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) })
        let NoblePatternSymptomAtlasQuietDays = (0..<7).compactMap { NoblePatternSymptomAtlasOffset -> Date? in
            guard let NoblePatternSymptomAtlasDay = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: NoblePatternSymptomAtlasOffset, to: NoblePatternSymptomAtlasStart) else { return nil }
            return NoblePatternSymptomAtlasLoggedDays.contains(NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasDay)) ? nil : NoblePatternSymptomAtlasDay
        }
        let NoblePatternSymptomAtlasBucketCounts = Dictionary(grouping: NoblePatternSymptomAtlasWeekLogs) {
            NoblePatternSymptomAtlasTimeBucket.NoblePatternSymptomAtlasBucket(for: $0.NoblePatternSymptomAtlasDate, calendar: NoblePatternSymptomAtlasCalendar)
        }
        let NoblePatternSymptomAtlasMostActiveTime = NoblePatternSymptomAtlasBucketCounts.max { $0.value.count < $1.value.count }?.key
        let NoblePatternSymptomAtlasSummaryText: String
        if let NoblePatternSymptomAtlasMostCommonSymptom {
            NoblePatternSymptomAtlasSummaryText = "Possible pattern: \(NoblePatternSymptomAtlasMostCommonSymptom.rawValue) is the most common symptom this week."
        } else {
            NoblePatternSymptomAtlasSummaryText = "Possible pattern: This week needs more logs before a local pattern appears."
        }

        return NoblePatternSymptomAtlasWeeklyReview(
            NoblePatternSymptomAtlasWeekStart: NoblePatternSymptomAtlasStart,
            NoblePatternSymptomAtlasWeekEnd: NoblePatternSymptomAtlasCalendar.date(byAdding: .second, value: -1, to: NoblePatternSymptomAtlasEnd) ?? NoblePatternSymptomAtlasEnd,
            NoblePatternSymptomAtlasLogsThisWeek: NoblePatternSymptomAtlasWeekLogs.count,
            NoblePatternSymptomAtlasMostCommonSymptom: NoblePatternSymptomAtlasMostCommonSymptom,
            NoblePatternSymptomAtlasAverageSeverity: NoblePatternSymptomAtlasAverageSeverity,
            NoblePatternSymptomAtlasQuietDays: NoblePatternSymptomAtlasQuietDays,
            NoblePatternSymptomAtlasMostActiveTime: NoblePatternSymptomAtlasMostActiveTime,
            NoblePatternSymptomAtlasSummaryText: NoblePatternSymptomAtlasSummaryText
        )
    }

    static func NoblePatternSymptomAtlasMakeReportPreview(
        logs NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry],
        filter NoblePatternSymptomAtlasFilter: NoblePatternSymptomAtlasReportFilter,
        summary NoblePatternSymptomAtlasSummary: NoblePatternSymptomAtlasPatternSummary
    ) -> NoblePatternSymptomAtlasReportPreview {
        var NoblePatternSymptomAtlasSections: [String] = []
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeSymptoms { NoblePatternSymptomAtlasSections.append("Symptoms") }
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeMedication { NoblePatternSymptomAtlasSections.append("Medication") }
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeNotes { NoblePatternSymptomAtlasSections.append("Notes") }
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeSleep { NoblePatternSymptomAtlasSections.append("Sleep") }
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeStress { NoblePatternSymptomAtlasSections.append("Stress") }
        if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeCharts { NoblePatternSymptomAtlasSections.append("Charts") }

        return NoblePatternSymptomAtlasReportPreview(
            NoblePatternSymptomAtlasEntryCount: NoblePatternSymptomAtlasLogs.count,
            NoblePatternSymptomAtlasIncludedSections: NoblePatternSymptomAtlasSections,
            NoblePatternSymptomAtlasTopSymptoms: Array(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms.prefix(3)),
            NoblePatternSymptomAtlasRecentEntries: Array(NoblePatternSymptomAtlasLogs.prefix(4)),
            NoblePatternSymptomAtlasPatternSummary: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasRecentPattern
        )
    }

    static func NoblePatternSymptomAtlasMakeTrackedSymptomStats(
        for NoblePatternSymptomAtlasTrackedSymptom: NoblePatternSymptomAtlasTrackedSymptom,
        checkIns NoblePatternSymptomAtlasCheckIns: [NoblePatternSymptomAtlasTrackedSymptomCheckIn],
        calendar NoblePatternSymptomAtlasCalendar: Calendar = .current
    ) -> NoblePatternSymptomAtlasTrackedSymptomStats {
        let NoblePatternSymptomAtlasStart = NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasTrackedSymptom.NoblePatternSymptomAtlasStartDate)
        let NoblePatternSymptomAtlasToday = NoblePatternSymptomAtlasCalendar.startOfDay(for: Date())
        let NoblePatternSymptomAtlasSymptomCheckIns = NoblePatternSymptomAtlasCheckIns.filter { $0.NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasTrackedSymptom.NoblePatternSymptomAtlasSymptom }
        let NoblePatternSymptomAtlasUniqueDays = Set(NoblePatternSymptomAtlasSymptomCheckIns.map { NoblePatternSymptomAtlasCalendar.startOfDay(for: $0.NoblePatternSymptomAtlasDate) })
        let NoblePatternSymptomAtlasTotalDays = max(1, (NoblePatternSymptomAtlasCalendar.dateComponents([.day], from: NoblePatternSymptomAtlasStart, to: NoblePatternSymptomAtlasToday).day ?? 0) + 1)
        var NoblePatternSymptomAtlasStreak = 0
        var NoblePatternSymptomAtlasCursor = NoblePatternSymptomAtlasToday
        while NoblePatternSymptomAtlasUniqueDays.contains(NoblePatternSymptomAtlasCursor) {
            NoblePatternSymptomAtlasStreak += 1
            NoblePatternSymptomAtlasCursor = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -1, to: NoblePatternSymptomAtlasCursor) ?? NoblePatternSymptomAtlasCursor
        }

        return NoblePatternSymptomAtlasTrackedSymptomStats(
            NoblePatternSymptomAtlasDaysAnswered: NoblePatternSymptomAtlasUniqueDays.count,
            NoblePatternSymptomAtlasYesCount: NoblePatternSymptomAtlasSymptomCheckIns.filter(\.NoblePatternSymptomAtlasHadSymptom).count,
            NoblePatternSymptomAtlasNoCount: NoblePatternSymptomAtlasSymptomCheckIns.filter { !$0.NoblePatternSymptomAtlasHadSymptom }.count,
            NoblePatternSymptomAtlasCurrentStreak: NoblePatternSymptomAtlasStreak,
            NoblePatternSymptomAtlasMissedDays: max(0, NoblePatternSymptomAtlasTotalDays - NoblePatternSymptomAtlasUniqueDays.count)
        )
    }
}

enum NoblePatternSymptomAtlasExportService {
    static func NoblePatternSymptomAtlasCSV(logs NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], filter NoblePatternSymptomAtlasFilter: NoblePatternSymptomAtlasReportFilter) -> String {
        var NoblePatternSymptomAtlasRows = ["Date,Time,Symptoms,Severity,Mood,Sleep,Stress,Activity,Medication,Dose,Notes"]
        let NoblePatternSymptomAtlasFormatter = DateFormatter()
        NoblePatternSymptomAtlasFormatter.dateStyle = .medium
        let NoblePatternSymptomAtlasTimeFormatter = DateFormatter()
        NoblePatternSymptomAtlasTimeFormatter.timeStyle = .short
        for NoblePatternSymptomAtlasLog in NoblePatternSymptomAtlasLogs {
            let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication
            let NoblePatternSymptomAtlasValues = [
                NoblePatternSymptomAtlasFormatter.string(from: NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate),
                NoblePatternSymptomAtlasTimeFormatter.string(from: NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate),
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeSymptoms ? NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.map(\.rawValue).joined(separator: " | ") : "",
                String(format: "%.0f", NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSeverity),
                NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMood.rawValue,
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeSleep ? "\(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSleepHours)h" : "",
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeStress ? NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasStress.rawValue : "",
                NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasActivity.rawValue,
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeMedication ? (NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName ?? "") : "",
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeMedication ? (NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasDose ?? "") : "",
                NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeNotes ? NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes : ""
            ].map(NoblePatternSymptomAtlasEscapeCSV)
            NoblePatternSymptomAtlasRows.append(NoblePatternSymptomAtlasValues.joined(separator: ","))
        }
        return NoblePatternSymptomAtlasRows.joined(separator: "\n")
    }

    static func NoblePatternSymptomAtlasPDF(logs NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry], filter NoblePatternSymptomAtlasFilter: NoblePatternSymptomAtlasReportFilter, summary NoblePatternSymptomAtlasSummary: NoblePatternSymptomAtlasPatternSummary) -> Data {
        let NoblePatternSymptomAtlasFormat = UIGraphicsPDFRendererFormat()
        let NoblePatternSymptomAtlasRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792), format: NoblePatternSymptomAtlasFormat)
        return NoblePatternSymptomAtlasRenderer.pdfData { NoblePatternSymptomAtlasContext in
            NoblePatternSymptomAtlasContext.beginPage()
            var NoblePatternSymptomAtlasY: CGFloat = 48
            NoblePatternSymptomAtlasDraw("Noble Pattern: Symptom Atlas", x: 48, y: NoblePatternSymptomAtlasY, size: 22, weight: .semibold)
            NoblePatternSymptomAtlasY += 34
            NoblePatternSymptomAtlasDraw("Offline report. No diagnosis or medical recommendations.", x: 48, y: NoblePatternSymptomAtlasY, size: 11, color: .darkGray)
            NoblePatternSymptomAtlasY += 30
            NoblePatternSymptomAtlasDraw(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasRecentPattern, x: 48, y: NoblePatternSymptomAtlasY, size: 13, weight: .medium)
            NoblePatternSymptomAtlasY += 34
            for NoblePatternSymptomAtlasLog in NoblePatternSymptomAtlasLogs.prefix(22) {
                if NoblePatternSymptomAtlasY > 730 {
                    NoblePatternSymptomAtlasContext.beginPage()
                    NoblePatternSymptomAtlasY = 48
                }
                let NoblePatternSymptomAtlasLine = "\(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate.formatted(date: .abbreviated, time: .shortened))  Severity \(Int(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSeverity))"
                NoblePatternSymptomAtlasDraw(NoblePatternSymptomAtlasLine, x: 48, y: NoblePatternSymptomAtlasY, size: 12, weight: .semibold)
                NoblePatternSymptomAtlasY += 18
                if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeSymptoms {
                    NoblePatternSymptomAtlasDraw("Symptoms: \(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.map(\.rawValue).joined(separator: ", "))", x: 58, y: NoblePatternSymptomAtlasY, size: 10)
                    NoblePatternSymptomAtlasY += 15
                }
                if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeMedication, let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication {
                    NoblePatternSymptomAtlasDraw("Medication: \(NoblePatternSymptomAtlasMedication.NoblePatternSymptomAtlasName) \(NoblePatternSymptomAtlasMedication.NoblePatternSymptomAtlasDose)", x: 58, y: NoblePatternSymptomAtlasY, size: 10)
                    NoblePatternSymptomAtlasY += 15
                }
                if NoblePatternSymptomAtlasFilter.NoblePatternSymptomAtlasIncludeNotes, !NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes.isEmpty {
                    NoblePatternSymptomAtlasDraw("Notes: \(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes)", x: 58, y: NoblePatternSymptomAtlasY, size: 10)
                    NoblePatternSymptomAtlasY += 15
                }
                NoblePatternSymptomAtlasY += 8
            }
        }
    }

    nonisolated private static func NoblePatternSymptomAtlasEscapeCSV(_ NoblePatternSymptomAtlasValue: String) -> String {
        let NoblePatternSymptomAtlasEscaped = NoblePatternSymptomAtlasValue.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(NoblePatternSymptomAtlasEscaped)\""
    }

    private static func NoblePatternSymptomAtlasDraw(_ NoblePatternSymptomAtlasText: String, x NoblePatternSymptomAtlasX: CGFloat, y NoblePatternSymptomAtlasY: CGFloat, size NoblePatternSymptomAtlasSize: CGFloat, weight NoblePatternSymptomAtlasWeight: UIFont.Weight = .regular, color NoblePatternSymptomAtlasColor: UIColor = .black) {
        let NoblePatternSymptomAtlasAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: NoblePatternSymptomAtlasSize, weight: NoblePatternSymptomAtlasWeight),
            .foregroundColor: NoblePatternSymptomAtlasColor
        ]
        NoblePatternSymptomAtlasText.draw(at: CGPoint(x: NoblePatternSymptomAtlasX, y: NoblePatternSymptomAtlasY), withAttributes: NoblePatternSymptomAtlasAttributes)
    }
}
