import Foundation
import SwiftUI
import Combine

final class NoblePatternSymptomAtlasViewModel: ObservableObject {
    @Published var NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry] = []
    @Published var NoblePatternSymptomAtlasSettingsState = NoblePatternSymptomAtlasSettings()
    @Published var NoblePatternSymptomAtlasSelectedWeek = Date()
    @Published var NoblePatternSymptomAtlasReportFilterState: NoblePatternSymptomAtlasReportFilter

    private let NoblePatternSymptomAtlasPersistence: NoblePatternSymptomAtlasPersistenceService

    init(persistence NoblePatternSymptomAtlasPersistence: NoblePatternSymptomAtlasPersistenceService = NoblePatternSymptomAtlasPersistenceService()) {
        self.NoblePatternSymptomAtlasPersistence = NoblePatternSymptomAtlasPersistence
        let NoblePatternSymptomAtlasNow = Date()
        self.NoblePatternSymptomAtlasReportFilterState = NoblePatternSymptomAtlasReportFilter(
            NoblePatternSymptomAtlasDateFrom: Calendar.current.date(byAdding: .day, value: -30, to: NoblePatternSymptomAtlasNow) ?? NoblePatternSymptomAtlasNow,
            NoblePatternSymptomAtlasDateTo: NoblePatternSymptomAtlasNow
        )
        NoblePatternSymptomAtlasLoad()
    }

    var NoblePatternSymptomAtlasSummary: NoblePatternSymptomAtlasPatternSummary {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs)
    }

    var NoblePatternSymptomAtlasTodaysLogs: [NoblePatternSymptomAtlasLogEntry] {
        NoblePatternSymptomAtlasLogs.filter { Calendar.current.isDateInToday($0.NoblePatternSymptomAtlasDate) }
    }

    var NoblePatternSymptomAtlasFilteredReportLogs: [NoblePatternSymptomAtlasLogEntry] {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasFilteredLogs(NoblePatternSymptomAtlasLogs, filter: NoblePatternSymptomAtlasReportFilterState)
    }

    func NoblePatternSymptomAtlasLoad() {
        let NoblePatternSymptomAtlasSavedLogs = NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasLoadLogs()
        if NoblePatternSymptomAtlasSavedLogs.isEmpty && !NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasHasSeededSampleData() {
            let NoblePatternSymptomAtlasSampleLogs = NoblePatternSymptomAtlasSampleDataFactory.NoblePatternSymptomAtlasMakeLogs()
            NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasSampleLogs)
            NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasMarkSampleDataSeeded()
            NoblePatternSymptomAtlasLogs = NoblePatternSymptomAtlasSampleLogs
        } else {
            NoblePatternSymptomAtlasLogs = NoblePatternSymptomAtlasSavedLogs
        }
        NoblePatternSymptomAtlasSettingsState = NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasLoadSettings()
    }

    func NoblePatternSymptomAtlasAddLog(_ NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) {
        NoblePatternSymptomAtlasLogs.insert(NoblePatternSymptomAtlasLog, at: 0)
        NoblePatternSymptomAtlasLogs.sort { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
    }

    func NoblePatternSymptomAtlasSaveSettings() {
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveSettings(NoblePatternSymptomAtlasSettingsState)
    }

    func NoblePatternSymptomAtlasResetData() {
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasReset()
        NoblePatternSymptomAtlasLogs = []
        NoblePatternSymptomAtlasSettingsState = NoblePatternSymptomAtlasSettings()
    }

    func NoblePatternSymptomAtlasCSVURL() -> URL? {
        let NoblePatternSymptomAtlasCSV = NoblePatternSymptomAtlasExportService.NoblePatternSymptomAtlasCSV(logs: NoblePatternSymptomAtlasFilteredReportLogs, filter: NoblePatternSymptomAtlasReportFilterState)
        let NoblePatternSymptomAtlasURL = FileManager.default.temporaryDirectory.appendingPathComponent("NoblePatternSymptomAtlasReport.csv")
        do {
            try NoblePatternSymptomAtlasCSV.write(to: NoblePatternSymptomAtlasURL, atomically: true, encoding: .utf8)
            return NoblePatternSymptomAtlasURL
        } catch {
            return nil
        }
    }

    func NoblePatternSymptomAtlasPDFURL() -> URL? {
        let NoblePatternSymptomAtlasData = NoblePatternSymptomAtlasExportService.NoblePatternSymptomAtlasPDF(
            logs: NoblePatternSymptomAtlasFilteredReportLogs,
            filter: NoblePatternSymptomAtlasReportFilterState,
            summary: NoblePatternSymptomAtlasSummary
        )
        let NoblePatternSymptomAtlasURL = FileManager.default.temporaryDirectory.appendingPathComponent("NoblePatternSymptomAtlasReport.pdf")
        do {
            try NoblePatternSymptomAtlasData.write(to: NoblePatternSymptomAtlasURL)
            return NoblePatternSymptomAtlasURL
        } catch {
            return nil
        }
    }
}

final class NoblePatternSymptomAtlasLogFormViewModel: ObservableObject {
    @Published var NoblePatternSymptomAtlasSelectedSymptoms: Set<NoblePatternSymptomAtlasSymptom> = []
    @Published var NoblePatternSymptomAtlasSeverity: Double = 5
    @Published var NoblePatternSymptomAtlasDate = Date()
    @Published var NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMood = .neutral
    @Published var NoblePatternSymptomAtlasSleepHours = 7
    @Published var NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStressLevel = .medium
    @Published var NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivity = .rest
    @Published var NoblePatternSymptomAtlasMeals = ""
    @Published var NoblePatternSymptomAtlasMedicationName = ""
    @Published var NoblePatternSymptomAtlasMedicationDose = ""
    @Published var NoblePatternSymptomAtlasMedicationTime = Date()
    @Published var NoblePatternSymptomAtlasNotes = ""

    var NoblePatternSymptomAtlasCanSave: Bool {
        !NoblePatternSymptomAtlasSelectedSymptoms.isEmpty || !NoblePatternSymptomAtlasMedicationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !NoblePatternSymptomAtlasNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func NoblePatternSymptomAtlasMakeLog() -> NoblePatternSymptomAtlasLogEntry {
        let NoblePatternSymptomAtlasTrimmedMedication = NoblePatternSymptomAtlasMedicationName.trimmingCharacters(in: .whitespacesAndNewlines)
        let NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedicationEntry?
        if NoblePatternSymptomAtlasTrimmedMedication.isEmpty {
            NoblePatternSymptomAtlasMedication = nil
        } else {
            NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasMedicationEntry(
                NoblePatternSymptomAtlasName: NoblePatternSymptomAtlasTrimmedMedication,
                NoblePatternSymptomAtlasDose: NoblePatternSymptomAtlasMedicationDose.trimmingCharacters(in: .whitespacesAndNewlines),
                NoblePatternSymptomAtlasTime: NoblePatternSymptomAtlasMedicationTime
            )
        }

        return NoblePatternSymptomAtlasLogEntry(
            NoblePatternSymptomAtlasSymptoms: Array(NoblePatternSymptomAtlasSelectedSymptoms).sorted { $0.rawValue < $1.rawValue },
            NoblePatternSymptomAtlasSeverity: NoblePatternSymptomAtlasSeverity,
            NoblePatternSymptomAtlasDate: NoblePatternSymptomAtlasDate,
            NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMood,
            NoblePatternSymptomAtlasSleepHours: NoblePatternSymptomAtlasSleepHours,
            NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStress,
            NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivity,
            NoblePatternSymptomAtlasMeals: NoblePatternSymptomAtlasMeals.trimmingCharacters(in: .whitespacesAndNewlines),
            NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedication,
            NoblePatternSymptomAtlasNotes: NoblePatternSymptomAtlasNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }

    func NoblePatternSymptomAtlasReset() {
        NoblePatternSymptomAtlasSelectedSymptoms = []
        NoblePatternSymptomAtlasSeverity = 5
        NoblePatternSymptomAtlasDate = Date()
        NoblePatternSymptomAtlasMood = .neutral
        NoblePatternSymptomAtlasSleepHours = 7
        NoblePatternSymptomAtlasStress = .medium
        NoblePatternSymptomAtlasActivity = .rest
        NoblePatternSymptomAtlasMeals = ""
        NoblePatternSymptomAtlasMedicationName = ""
        NoblePatternSymptomAtlasMedicationDose = ""
        NoblePatternSymptomAtlasMedicationTime = Date()
        NoblePatternSymptomAtlasNotes = ""
    }
}
