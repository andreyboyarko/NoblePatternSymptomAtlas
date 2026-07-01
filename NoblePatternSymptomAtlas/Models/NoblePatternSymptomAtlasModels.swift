import Foundation
import UIKit

enum NoblePatternSymptomAtlasSymptom: String, CaseIterable, Codable, Identifiable {
    case headache = "Headache"
    case nausea = "Nausea"
    case fatigue = "Fatigue"
    case dizziness = "Dizziness"
    case anxiety = "Anxiety"
    case fever = "Fever"
    case stomachPain = "Stomach Pain"
    case soreThroat = "Sore Throat"
    case runnyNose = "Runny Nose"
    case backPain = "Back Pain"
    case chestTightness = "Chest Tightness"
    case shortnessOfBreath = "Shortness of Breath"

    var id: String { rawValue }

    var NoblePatternSymptomAtlasEmoji: String {
        switch self {
        case .headache: return "🤕"
        case .nausea: return "🤢"
        case .fatigue: return "😴"
        case .dizziness: return "💫"
        case .anxiety: return "😟"
        case .fever: return "🤒"
        case .stomachPain: return "🫃"
        case .soreThroat: return "😷"
        case .runnyNose: return "🤧"
        case .backPain: return "🧍"
        case .chestTightness: return "🫁"
        case .shortnessOfBreath: return "🌬"
        }
    }
}

enum NoblePatternSymptomAtlasMood: String, CaseIterable, Codable, Identifiable {
    case great = "Great"
    case good = "Good"
    case neutral = "Neutral"
    case low = "Low"
    case veryLow = "Very Low"

    var id: String { rawValue }

    var NoblePatternSymptomAtlasEmoji: String {
        switch self {
        case .great: return "😄"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .low: return "😔"
        case .veryLow: return "😢"
        }
    }

    var NoblePatternSymptomAtlasIsLow: Bool {
        self == .low || self == .veryLow
    }
}

enum NoblePatternSymptomAtlasStressLevel: String, CaseIterable, Codable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }
}

enum NoblePatternSymptomAtlasActivity: String, CaseIterable, Codable, Identifiable {
    case walking = "Walking"
    case running = "Running"
    case gym = "Gym"
    case rest = "Rest"
    case work = "Work"

    var id: String { rawValue }
}

enum NoblePatternSymptomAtlasTimeBucket: String, CaseIterable, Codable, Identifiable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"

    var id: String { rawValue }

    nonisolated static func NoblePatternSymptomAtlasBucket(for NoblePatternSymptomAtlasDate: Date, calendar NoblePatternSymptomAtlasCalendar: Calendar = .current) -> NoblePatternSymptomAtlasTimeBucket {
        let NoblePatternSymptomAtlasHour = NoblePatternSymptomAtlasCalendar.component(.hour, from: NoblePatternSymptomAtlasDate)
        switch NoblePatternSymptomAtlasHour {
        case 5..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<22: return .evening
        default: return .night
        }
    }
}

struct NoblePatternSymptomAtlasMedicationEntry: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var NoblePatternSymptomAtlasName: String
    var NoblePatternSymptomAtlasDose: String
    var NoblePatternSymptomAtlasTime: Date
}

struct NoblePatternSymptomAtlasLogEntry: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var NoblePatternSymptomAtlasSymptoms: [NoblePatternSymptomAtlasSymptom]
    var NoblePatternSymptomAtlasSeverity: Double
    var NoblePatternSymptomAtlasDate: Date
    var NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMood
    var NoblePatternSymptomAtlasSleepHours: Int
    var NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStressLevel
    var NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivity
    var NoblePatternSymptomAtlasMeals: String
    var NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedicationEntry?
    var NoblePatternSymptomAtlasNotes: String
}

struct NoblePatternSymptomAtlasTrackedSymptom: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom
    var NoblePatternSymptomAtlasStartDate: Date = Date()
    var NoblePatternSymptomAtlasIsActive: Bool = true
}

struct NoblePatternSymptomAtlasTrackedSymptomCheckIn: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom
    var NoblePatternSymptomAtlasDate: Date
    var NoblePatternSymptomAtlasHadSymptom: Bool
}

struct NoblePatternSymptomAtlasReportFilter: Codable, Equatable {
    var NoblePatternSymptomAtlasDateFrom: Date
    var NoblePatternSymptomAtlasDateTo: Date
    var NoblePatternSymptomAtlasIncludeSymptoms: Bool = true
    var NoblePatternSymptomAtlasIncludeMedication: Bool = true
    var NoblePatternSymptomAtlasIncludeNotes: Bool = true
    var NoblePatternSymptomAtlasIncludeSleep: Bool = true
    var NoblePatternSymptomAtlasIncludeStress: Bool = true
    var NoblePatternSymptomAtlasIncludeCharts: Bool = true
}

struct NoblePatternSymptomAtlasSettings: Codable, Equatable {
    var NoblePatternSymptomAtlasAppIcon: String = "Heart Nodes"
}

struct NoblePatternSymptomAtlasPatternInsight: Identifiable, Equatable {
    var id: String
    var NoblePatternSymptomAtlasTitle: String
    var NoblePatternSymptomAtlasText: String
    var NoblePatternSymptomAtlasCategory: String
    var NoblePatternSymptomAtlasDataCount: Int
    var NoblePatternSymptomAtlasExplanation: String?
}

struct NoblePatternSymptomAtlasPatternSummary {
    var NoblePatternSymptomAtlasTopSymptoms: [(NoblePatternSymptomAtlasSymptom, Int)]
    var NoblePatternSymptomAtlasMostActiveTime: NoblePatternSymptomAtlasTimeBucket?
    var NoblePatternSymptomAtlasSleepPattern: String
    var NoblePatternSymptomAtlasStressPattern: String
    var NoblePatternSymptomAtlasWeekdayPattern: String
    var NoblePatternSymptomAtlasMoodPattern: String
    var NoblePatternSymptomAtlasMedicationPattern: String
    var NoblePatternSymptomAtlasRecentPattern: String
    var NoblePatternSymptomAtlasInsights: [NoblePatternSymptomAtlasPatternInsight]
    var NoblePatternSymptomAtlasDailySeverity: [(Date, Double)]
    var NoblePatternSymptomAtlasTimeBuckets: [(NoblePatternSymptomAtlasTimeBucket, Int)]
    var NoblePatternSymptomAtlasHeatmap: [(Date, Int)]

    static let NoblePatternSymptomAtlasEmpty = NoblePatternSymptomAtlasPatternSummary(
        NoblePatternSymptomAtlasTopSymptoms: [],
        NoblePatternSymptomAtlasMostActiveTime: nil,
        NoblePatternSymptomAtlasSleepPattern: "Possible pattern: Add a few logs to discover sleep-related patterns.",
        NoblePatternSymptomAtlasStressPattern: "Possible pattern: Stress patterns will appear after more logs.",
        NoblePatternSymptomAtlasWeekdayPattern: "Possible pattern: Weekday patterns will appear after more logs.",
        NoblePatternSymptomAtlasMoodPattern: "Possible pattern: Mood patterns will appear after more logs.",
        NoblePatternSymptomAtlasMedicationPattern: "Possible pattern: Medication patterns will appear after more logs.",
        NoblePatternSymptomAtlasRecentPattern: "Possible pattern: Add your first log to begin discovering patterns.",
        NoblePatternSymptomAtlasInsights: [
            NoblePatternSymptomAtlasPatternInsight(
                id: "more-logs-needed",
                NoblePatternSymptomAtlasTitle: "More Logs Needed",
                NoblePatternSymptomAtlasText: "Possible pattern: Add more logs to unlock local insights.",
                NoblePatternSymptomAtlasCategory: "Data",
                NoblePatternSymptomAtlasDataCount: 0,
                NoblePatternSymptomAtlasExplanation: "Insights are based only on logs saved on this device."
            )
        ],
        NoblePatternSymptomAtlasDailySeverity: [],
        NoblePatternSymptomAtlasTimeBuckets: NoblePatternSymptomAtlasTimeBucket.allCases.map { ($0, 0) },
        NoblePatternSymptomAtlasHeatmap: []
    )
}

struct NoblePatternSymptomAtlasSymptomDetailSummary {
    var NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom
    var NoblePatternSymptomAtlasLoggedCount: Int
    var NoblePatternSymptomAtlasAverageSeverity: Double?
    var NoblePatternSymptomAtlasCommonTime: NoblePatternSymptomAtlasTimeBucket?
    var NoblePatternSymptomAtlasRecentEntries: [NoblePatternSymptomAtlasLogEntry]
    var NoblePatternSymptomAtlasRelatedPatterns: [String]
}

struct NoblePatternSymptomAtlasWeeklyReview {
    var NoblePatternSymptomAtlasWeekStart: Date
    var NoblePatternSymptomAtlasWeekEnd: Date
    var NoblePatternSymptomAtlasLogsThisWeek: Int
    var NoblePatternSymptomAtlasMostCommonSymptom: NoblePatternSymptomAtlasSymptom?
    var NoblePatternSymptomAtlasAverageSeverity: Double?
    var NoblePatternSymptomAtlasQuietDays: [Date]
    var NoblePatternSymptomAtlasMostActiveTime: NoblePatternSymptomAtlasTimeBucket?
    var NoblePatternSymptomAtlasSummaryText: String
}

struct NoblePatternSymptomAtlasReportPreview {
    var NoblePatternSymptomAtlasEntryCount: Int
    var NoblePatternSymptomAtlasIncludedSections: [String]
    var NoblePatternSymptomAtlasTopSymptoms: [(NoblePatternSymptomAtlasSymptom, Int)]
    var NoblePatternSymptomAtlasRecentEntries: [NoblePatternSymptomAtlasLogEntry]
    var NoblePatternSymptomAtlasPatternSummary: String
}

struct NoblePatternSymptomAtlasTrackedSymptomStats {
    var NoblePatternSymptomAtlasDaysAnswered: Int
    var NoblePatternSymptomAtlasYesCount: Int
    var NoblePatternSymptomAtlasNoCount: Int
    var NoblePatternSymptomAtlasCurrentStreak: Int
    var NoblePatternSymptomAtlasMissedDays: Int
}
