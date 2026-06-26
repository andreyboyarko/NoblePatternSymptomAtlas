import Foundation
import UIKit

final class NoblePatternSymptomAtlasPersistenceService {
    private let NoblePatternSymptomAtlasDefaults: UserDefaults
    private let NoblePatternSymptomAtlasLogsKey = "NoblePatternSymptomAtlas.logs"
    private let NoblePatternSymptomAtlasSettingsKey = "NoblePatternSymptomAtlas.settings"
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

    func NoblePatternSymptomAtlasReset() {
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasLogsKey)
        NoblePatternSymptomAtlasDefaults.removeObject(forKey: NoblePatternSymptomAtlasSettingsKey)
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

    private static func NoblePatternSymptomAtlasEscapeCSV(_ NoblePatternSymptomAtlasValue: String) -> String {
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
