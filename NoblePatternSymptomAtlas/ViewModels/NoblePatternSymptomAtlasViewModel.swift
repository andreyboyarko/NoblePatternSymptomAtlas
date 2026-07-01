import Foundation
import SwiftUI
import Combine

final class NoblePatternSymptomAtlasViewModel: ObservableObject {
    @Published var NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry] = []
    @Published var NoblePatternSymptomAtlasSettingsState = NoblePatternSymptomAtlasSettings()
    @Published var NoblePatternSymptomAtlasSelectedWeek = Date()
    @Published var NoblePatternSymptomAtlasReportFilterState: NoblePatternSymptomAtlasReportFilter
    @Published var NoblePatternSymptomAtlasTrackedSymptoms: [NoblePatternSymptomAtlasTrackedSymptom] = []
    @Published var NoblePatternSymptomAtlasTrackedSymptomCheckIns: [NoblePatternSymptomAtlasTrackedSymptomCheckIn] = []

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
        NoblePatternSymptomAtlasTrackedSymptoms = NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasLoadTrackedSymptoms()
        NoblePatternSymptomAtlasTrackedSymptomCheckIns = NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasLoadTrackedSymptomCheckIns()
    }

    func NoblePatternSymptomAtlasAddLog(_ NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) {
        NoblePatternSymptomAtlasLogs.insert(NoblePatternSymptomAtlasLog, at: 0)
        NoblePatternSymptomAtlasLogs.sort { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
    }

    func NoblePatternSymptomAtlasUpdateLog(_ NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) {
        guard let NoblePatternSymptomAtlasIndex = NoblePatternSymptomAtlasLogs.firstIndex(where: { $0.id == NoblePatternSymptomAtlasLog.id }) else { return }
        NoblePatternSymptomAtlasLogs[NoblePatternSymptomAtlasIndex] = NoblePatternSymptomAtlasLog
        NoblePatternSymptomAtlasLogs.sort { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
    }

    func NoblePatternSymptomAtlasDeleteLog(id NoblePatternSymptomAtlasID: UUID) {
        NoblePatternSymptomAtlasLogs.removeAll { $0.id == NoblePatternSymptomAtlasID }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
    }

    func NoblePatternSymptomAtlasSaveSettings() {
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveSettings(NoblePatternSymptomAtlasSettingsState)
    }

    func NoblePatternSymptomAtlasResetData() {
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasReset()
        NoblePatternSymptomAtlasLogs = []
        NoblePatternSymptomAtlasSettingsState = NoblePatternSymptomAtlasSettings()
        NoblePatternSymptomAtlasTrackedSymptoms = []
        NoblePatternSymptomAtlasTrackedSymptomCheckIns = []
    }

    func NoblePatternSymptomAtlasRemoveSampleData() {
        NoblePatternSymptomAtlasLogs.removeAll { NoblePatternSymptomAtlasSampleDataFactory.NoblePatternSymptomAtlasIsSampleLog($0) }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasMarkSampleDataSeeded()
    }

    func NoblePatternSymptomAtlasRestoreSampleData() {
        NoblePatternSymptomAtlasRemoveSampleData()
        let NoblePatternSymptomAtlasSampleLogs = NoblePatternSymptomAtlasSampleDataFactory.NoblePatternSymptomAtlasMakeLogs()
        NoblePatternSymptomAtlasLogs.append(contentsOf: NoblePatternSymptomAtlasSampleLogs)
        NoblePatternSymptomAtlasLogs.sort { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs(NoblePatternSymptomAtlasLogs)
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasMarkSampleDataSeeded()
    }

    func NoblePatternSymptomAtlasStartEmpty() {
        NoblePatternSymptomAtlasLogs = []
        NoblePatternSymptomAtlasTrackedSymptoms = []
        NoblePatternSymptomAtlasTrackedSymptomCheckIns = []
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveLogs([])
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveTrackedSymptoms([])
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveTrackedSymptomCheckIns([])
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasMarkSampleDataSeeded()
    }

    func NoblePatternSymptomAtlasMakeSymptomDetail(for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> NoblePatternSymptomAtlasSymptomDetailSummary {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasMakeSymptomDetail(for: NoblePatternSymptomAtlasSymptom, logs: NoblePatternSymptomAtlasLogs)
    }

    func NoblePatternSymptomAtlasMakeWeeklyReview(week NoblePatternSymptomAtlasWeek: Date = Date()) -> NoblePatternSymptomAtlasWeeklyReview {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasMakeWeeklyReview(logs: NoblePatternSymptomAtlasLogs, week: NoblePatternSymptomAtlasWeek)
    }

    func NoblePatternSymptomAtlasMakeReportPreview() -> NoblePatternSymptomAtlasReportPreview {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasMakeReportPreview(
            logs: NoblePatternSymptomAtlasFilteredReportLogs,
            filter: NoblePatternSymptomAtlasReportFilterState,
            summary: NoblePatternSymptomAtlasSummary
        )
    }

    func NoblePatternSymptomAtlasIsTracking(_ NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> Bool {
        NoblePatternSymptomAtlasTrackedSymptoms.contains {
            $0.NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasSymptom && $0.NoblePatternSymptomAtlasIsActive
        }
    }

    func NoblePatternSymptomAtlasActiveTrackedSymptom(for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> NoblePatternSymptomAtlasTrackedSymptom? {
        NoblePatternSymptomAtlasTrackedSymptoms.first {
            $0.NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasSymptom && $0.NoblePatternSymptomAtlasIsActive
        }
    }

    func NoblePatternSymptomAtlasEnableTracking(_ NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) {
        guard !NoblePatternSymptomAtlasIsTracking(NoblePatternSymptomAtlasSymptom) else { return }
        NoblePatternSymptomAtlasTrackedSymptoms.append(
            NoblePatternSymptomAtlasTrackedSymptom(NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom)
        )
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveTrackedSymptoms(NoblePatternSymptomAtlasTrackedSymptoms)
    }

    func NoblePatternSymptomAtlasStopTracking(_ NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) {
        for NoblePatternSymptomAtlasIndex in NoblePatternSymptomAtlasTrackedSymptoms.indices where NoblePatternSymptomAtlasTrackedSymptoms[NoblePatternSymptomAtlasIndex].NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasSymptom {
            NoblePatternSymptomAtlasTrackedSymptoms[NoblePatternSymptomAtlasIndex].NoblePatternSymptomAtlasIsActive = false
        }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveTrackedSymptoms(NoblePatternSymptomAtlasTrackedSymptoms)
    }

    func NoblePatternSymptomAtlasTrackedCheckIn(for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom, on NoblePatternSymptomAtlasDate: Date = Date()) -> NoblePatternSymptomAtlasTrackedSymptomCheckIn? {
        let NoblePatternSymptomAtlasDay = Calendar.current.startOfDay(for: NoblePatternSymptomAtlasDate)
        return NoblePatternSymptomAtlasTrackedSymptomCheckIns.first {
            $0.NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasSymptom &&
            Calendar.current.isDate($0.NoblePatternSymptomAtlasDate, inSameDayAs: NoblePatternSymptomAtlasDay)
        }
    }

    func NoblePatternSymptomAtlasAnswerTrackedSymptom(_ NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom, hadSymptom NoblePatternSymptomAtlasHadSymptom: Bool, date NoblePatternSymptomAtlasDate: Date = Date()) {
        let NoblePatternSymptomAtlasDay = Calendar.current.startOfDay(for: NoblePatternSymptomAtlasDate)
        if let NoblePatternSymptomAtlasIndex = NoblePatternSymptomAtlasTrackedSymptomCheckIns.firstIndex(where: {
            $0.NoblePatternSymptomAtlasSymptom == NoblePatternSymptomAtlasSymptom &&
            Calendar.current.isDate($0.NoblePatternSymptomAtlasDate, inSameDayAs: NoblePatternSymptomAtlasDay)
        }) {
            NoblePatternSymptomAtlasTrackedSymptomCheckIns[NoblePatternSymptomAtlasIndex].NoblePatternSymptomAtlasHadSymptom = NoblePatternSymptomAtlasHadSymptom
            NoblePatternSymptomAtlasTrackedSymptomCheckIns[NoblePatternSymptomAtlasIndex].NoblePatternSymptomAtlasDate = NoblePatternSymptomAtlasDay
        } else {
            NoblePatternSymptomAtlasTrackedSymptomCheckIns.insert(
                NoblePatternSymptomAtlasTrackedSymptomCheckIn(
                    NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom,
                    NoblePatternSymptomAtlasDate: NoblePatternSymptomAtlasDay,
                    NoblePatternSymptomAtlasHadSymptom: NoblePatternSymptomAtlasHadSymptom
                ),
                at: 0
            )
        }
        NoblePatternSymptomAtlasTrackedSymptomCheckIns.sort { $0.NoblePatternSymptomAtlasDate > $1.NoblePatternSymptomAtlasDate }
        NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasSaveTrackedSymptomCheckIns(NoblePatternSymptomAtlasTrackedSymptomCheckIns)
    }

    func NoblePatternSymptomAtlasStats(for NoblePatternSymptomAtlasTrackedSymptom: NoblePatternSymptomAtlasTrackedSymptom) -> NoblePatternSymptomAtlasTrackedSymptomStats {
        NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasMakeTrackedSymptomStats(
            for: NoblePatternSymptomAtlasTrackedSymptom,
            checkIns: NoblePatternSymptomAtlasTrackedSymptomCheckIns
        )
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

    convenience init(log NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) {
        self.init()
        NoblePatternSymptomAtlasApply(log: NoblePatternSymptomAtlasLog)
    }

    var NoblePatternSymptomAtlasCanSave: Bool {
        !NoblePatternSymptomAtlasSelectedSymptoms.isEmpty || !NoblePatternSymptomAtlasMedicationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !NoblePatternSymptomAtlasNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func NoblePatternSymptomAtlasMakeLog(id NoblePatternSymptomAtlasID: UUID = UUID()) -> NoblePatternSymptomAtlasLogEntry {
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
            id: NoblePatternSymptomAtlasID,
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

    func NoblePatternSymptomAtlasApply(log NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) {
        NoblePatternSymptomAtlasSelectedSymptoms = Set(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms)
        NoblePatternSymptomAtlasSeverity = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSeverity
        NoblePatternSymptomAtlasDate = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate
        NoblePatternSymptomAtlasMood = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMood
        NoblePatternSymptomAtlasSleepHours = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSleepHours
        NoblePatternSymptomAtlasStress = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasStress
        NoblePatternSymptomAtlasActivity = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasActivity
        NoblePatternSymptomAtlasMeals = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMeals
        NoblePatternSymptomAtlasMedicationName = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName ?? ""
        NoblePatternSymptomAtlasMedicationDose = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasDose ?? ""
        NoblePatternSymptomAtlasMedicationTime = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasTime ?? NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate
        NoblePatternSymptomAtlasNotes = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasNotes
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
