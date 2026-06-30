import XCTest
@testable import NoblePatternSymptomAtlas

final class NoblePatternSymptomAtlasTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        UserDefaults(suiteName: "NoblePatternSymptomAtlasTests")?.removePersistentDomain(forName: "NoblePatternSymptomAtlasTests")
    }

    func testNoblePatternSymptomAtlasPersistenceRoundTripAndReset() {
        let NoblePatternSymptomAtlasLog = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache], severity: 6)
        let NoblePatternSymptomAtlasEncoder = JSONEncoder()
        let NoblePatternSymptomAtlasDecoder = JSONDecoder()

        let NoblePatternSymptomAtlasData = try! NoblePatternSymptomAtlasEncoder.encode([NoblePatternSymptomAtlasLog])
        let NoblePatternSymptomAtlasDecoded = try! NoblePatternSymptomAtlasDecoder.decode([NoblePatternSymptomAtlasLogEntry].self, from: NoblePatternSymptomAtlasData)

        XCTAssertEqual(NoblePatternSymptomAtlasDecoded.first?.NoblePatternSymptomAtlasSymptoms, [.headache])
        XCTAssertEqual(NoblePatternSymptomAtlasDecoded.first?.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName, NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication?.NoblePatternSymptomAtlasName)
    }

    func testNoblePatternSymptomAtlasDateFiltering() {
        let NoblePatternSymptomAtlasNow = Date(timeIntervalSince1970: 1_700_000_000)
        let NoblePatternSymptomAtlasFilter = NoblePatternSymptomAtlasReportFilter(
            NoblePatternSymptomAtlasDateFrom: NoblePatternSymptomAtlasNow,
            NoblePatternSymptomAtlasDateTo: NoblePatternSymptomAtlasNow
        )
        let NoblePatternSymptomAtlasInside = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(date: NoblePatternSymptomAtlasNow)
        let NoblePatternSymptomAtlasOutside = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(date: NoblePatternSymptomAtlasNow.addingTimeInterval(-86_400))

        let NoblePatternSymptomAtlasFiltered = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasFilteredLogs([NoblePatternSymptomAtlasInside, NoblePatternSymptomAtlasOutside], filter: NoblePatternSymptomAtlasFilter)
        XCTAssertEqual(NoblePatternSymptomAtlasFiltered.map(\.id), [NoblePatternSymptomAtlasInside.id])
    }

    func testNoblePatternSymptomAtlasTimeBucketClassification() {
        var NoblePatternSymptomAtlasComponents = DateComponents()
        NoblePatternSymptomAtlasComponents.year = 2026
        NoblePatternSymptomAtlasComponents.month = 6
        NoblePatternSymptomAtlasComponents.day = 26
        NoblePatternSymptomAtlasComponents.hour = 8
        let NoblePatternSymptomAtlasDate = Calendar(identifier: .gregorian).date(from: NoblePatternSymptomAtlasComponents)!

        XCTAssertEqual(NoblePatternSymptomAtlasTimeBucket.NoblePatternSymptomAtlasBucket(for: NoblePatternSymptomAtlasDate, calendar: Calendar(identifier: .gregorian)), .morning)
    }

    func testNoblePatternSymptomAtlasPatternSummariesAndCSV() {
        let NoblePatternSymptomAtlasLogs = [
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache], severity: 7, sleep: 5, stress: .high, medicationName: "Ibuprofen"),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.fatigue], severity: 4, sleep: 8, stress: .low),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache, .fatigue], severity: 6, sleep: 4, stress: .high)
        ]
        let NoblePatternSymptomAtlasSummary = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs)

        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms.contains { $0.0 == .headache && $0.1 == 2 })
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasSleepPattern.contains("Possible correlation"))
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasStressPattern.contains("Possible correlation"))
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasMedicationPattern.contains("Ibuprofen"))

        let NoblePatternSymptomAtlasFilter = NoblePatternSymptomAtlasReportFilter(NoblePatternSymptomAtlasDateFrom: .distantPast, NoblePatternSymptomAtlasDateTo: .distantFuture)
        let NoblePatternSymptomAtlasCSV = NoblePatternSymptomAtlasExportService.NoblePatternSymptomAtlasCSV(logs: NoblePatternSymptomAtlasLogs, filter: NoblePatternSymptomAtlasFilter)
        XCTAssertTrue(NoblePatternSymptomAtlasCSV.contains("Headache"))
        XCTAssertTrue(NoblePatternSymptomAtlasCSV.contains("Ibuprofen"))
    }

    func testNoblePatternSymptomAtlasSampleDataSeedsOnFirstEmptyLoad() {
        let NoblePatternSymptomAtlasDefaults = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasFreshDefaults()
        let NoblePatternSymptomAtlasPersistence = NoblePatternSymptomAtlasPersistenceService(defaults: NoblePatternSymptomAtlasDefaults)

        let NoblePatternSymptomAtlasViewModel = NoblePatternSymptomAtlasViewModel(persistence: NoblePatternSymptomAtlasPersistence)

        XCTAssertGreaterThanOrEqual(NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs.count, 20)
        XCTAssertTrue(NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasHasSeededSampleData())
        XCTAssertFalse(NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms.isEmpty)
        XCTAssertFalse(NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasDailySeverity.isEmpty)
        XCTAssertFalse(NoblePatternSymptomAtlasExportService.NoblePatternSymptomAtlasCSV(logs: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs, filter: NoblePatternSymptomAtlasReportFilter(NoblePatternSymptomAtlasDateFrom: .distantPast, NoblePatternSymptomAtlasDateTo: .distantFuture)).isEmpty)
    }

    func testNoblePatternSymptomAtlasSampleDataDoesNotDuplicateOnSecondLoad() {
        let NoblePatternSymptomAtlasDefaults = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasFreshDefaults()
        let NoblePatternSymptomAtlasPersistence = NoblePatternSymptomAtlasPersistenceService(defaults: NoblePatternSymptomAtlasDefaults)
        let NoblePatternSymptomAtlasFirstViewModel = NoblePatternSymptomAtlasViewModel(persistence: NoblePatternSymptomAtlasPersistence)
        let NoblePatternSymptomAtlasFirstCount = NoblePatternSymptomAtlasFirstViewModel.NoblePatternSymptomAtlasLogs.count

        let NoblePatternSymptomAtlasSecondViewModel = NoblePatternSymptomAtlasViewModel(persistence: NoblePatternSymptomAtlasPersistence)

        XCTAssertEqual(NoblePatternSymptomAtlasSecondViewModel.NoblePatternSymptomAtlasLogs.count, NoblePatternSymptomAtlasFirstCount)
    }

    func testNoblePatternSymptomAtlasResetPreventsSampleDataReseed() {
        let NoblePatternSymptomAtlasDefaults = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasFreshDefaults()
        let NoblePatternSymptomAtlasPersistence = NoblePatternSymptomAtlasPersistenceService(defaults: NoblePatternSymptomAtlasDefaults)
        let NoblePatternSymptomAtlasViewModel = NoblePatternSymptomAtlasViewModel(persistence: NoblePatternSymptomAtlasPersistence)
        XCTAssertFalse(NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs.isEmpty)

        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasResetData()
        let NoblePatternSymptomAtlasReloadedViewModel = NoblePatternSymptomAtlasViewModel(persistence: NoblePatternSymptomAtlasPersistence)

        XCTAssertTrue(NoblePatternSymptomAtlasReloadedViewModel.NoblePatternSymptomAtlasLogs.isEmpty)
        XCTAssertTrue(NoblePatternSymptomAtlasPersistence.NoblePatternSymptomAtlasHasSeededSampleData())
    }

    func testNoblePatternSymptomAtlasSampleDataAnalyticsArePopulated() {
        let NoblePatternSymptomAtlasLogs = NoblePatternSymptomAtlasSampleDataFactory.NoblePatternSymptomAtlasMakeLogs(now: Date(timeIntervalSince1970: 1_800_000_000), calendar: Calendar(identifier: .gregorian))
        let NoblePatternSymptomAtlasSummary = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs, calendar: Calendar(identifier: .gregorian))

        XCTAssertGreaterThanOrEqual(NoblePatternSymptomAtlasLogs.count, 20)
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms.contains { $0.0 == .headache })
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasSleepPattern.contains("Possible correlation"))
        XCTAssertTrue(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasStressPattern.contains("Possible correlation"))
        XCTAssertFalse(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasHeatmap.isEmpty)
        XCTAssertFalse(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTimeBuckets.allSatisfy { $0.1 == 0 })
    }

    func testNoblePatternSymptomAtlasInsightFeedIncludesSymptomClustersAndActivity() {
        let NoblePatternSymptomAtlasLogs = [
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache, .fatigue], activity: .work),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache, .fatigue], activity: .work),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.nausea], activity: .rest)
        ]

        let NoblePatternSymptomAtlasInsights = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs).NoblePatternSymptomAtlasInsights

        XCTAssertTrue(NoblePatternSymptomAtlasInsights.contains { $0.NoblePatternSymptomAtlasTitle == "Symptom Cluster" })
        XCTAssertTrue(NoblePatternSymptomAtlasInsights.contains { $0.NoblePatternSymptomAtlasTitle == "Activity Association" })
        XCTAssertTrue(NoblePatternSymptomAtlasInsights.allSatisfy { $0.NoblePatternSymptomAtlasText.contains("Possible pattern") || $0.NoblePatternSymptomAtlasText.contains("Possible correlation") })
    }

    func testNoblePatternSymptomAtlasInsightFeedIncludesSameDayDirectionAndMedicationTrend() {
        let NoblePatternSymptomAtlasCalendar = Calendar(identifier: .gregorian)
        let NoblePatternSymptomAtlasMorningOne = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 1, hour: 8)
        let NoblePatternSymptomAtlasAfternoonOne = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 1, hour: 15)
        let NoblePatternSymptomAtlasMorningTwo = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 2, hour: 8)
        let NoblePatternSymptomAtlasAfternoonTwo = NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 2, hour: 16)

        let NoblePatternSymptomAtlasLogs = [
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(severity: 7, date: NoblePatternSymptomAtlasMorningOne, medicationName: "Ibuprofen"),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(severity: 3, date: NoblePatternSymptomAtlasAfternoonOne, medicationName: "Ibuprofen"),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(severity: 6, date: NoblePatternSymptomAtlasMorningTwo),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(severity: 2, date: NoblePatternSymptomAtlasAfternoonTwo)
        ]

        let NoblePatternSymptomAtlasInsights = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).NoblePatternSymptomAtlasInsights

        XCTAssertTrue(NoblePatternSymptomAtlasInsights.contains { $0.NoblePatternSymptomAtlasTitle == "Same-Day Direction" && $0.NoblePatternSymptomAtlasText.contains("lower") })
        XCTAssertTrue(NoblePatternSymptomAtlasInsights.contains { $0.NoblePatternSymptomAtlasTitle == "Medication Trend" && $0.NoblePatternSymptomAtlasText.contains("Ibuprofen") })
    }

    func testNoblePatternSymptomAtlasInsightFeedIncludesRecentChangeAndLowDataFallback() {
        let NoblePatternSymptomAtlasCalendar = Calendar(identifier: .gregorian)
        let NoblePatternSymptomAtlasLogs = [
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache, .fatigue], date: NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 14, hour: 8)),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.headache], date: NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 13, hour: 8)),
            NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeLog(symptoms: [.nausea], date: NoblePatternSymptomAtlasTests.NoblePatternSymptomAtlasMakeDate(day: 4, hour: 8))
        ]

        let NoblePatternSymptomAtlasInsights = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: NoblePatternSymptomAtlasLogs, calendar: NoblePatternSymptomAtlasCalendar).NoblePatternSymptomAtlasInsights
        let NoblePatternSymptomAtlasEmptyInsights = NoblePatternSymptomAtlasAnalyticsService.NoblePatternSymptomAtlasSummary(for: []).NoblePatternSymptomAtlasInsights

        XCTAssertTrue(NoblePatternSymptomAtlasInsights.contains { $0.NoblePatternSymptomAtlasTitle == "Recent Change" })
        XCTAssertTrue(NoblePatternSymptomAtlasEmptyInsights.contains { $0.NoblePatternSymptomAtlasTitle == "More Logs Needed" })
    }

    private static func NoblePatternSymptomAtlasMakeLog(
        symptoms NoblePatternSymptomAtlasSymptoms: [NoblePatternSymptomAtlasSymptom] = [.headache],
        severity NoblePatternSymptomAtlasSeverity: Double = 5,
        date NoblePatternSymptomAtlasDate: Date = Date(timeIntervalSince1970: 1_700_000_000),
        sleep NoblePatternSymptomAtlasSleep: Int = 7,
        stress NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStressLevel = .medium,
        mood NoblePatternSymptomAtlasMoodValue: NoblePatternSymptomAtlasMood = .low,
        activity NoblePatternSymptomAtlasActivityValue: NoblePatternSymptomAtlasActivity = .rest,
        medicationName NoblePatternSymptomAtlasMedicationName: String? = nil,
        notes NoblePatternSymptomAtlasNotes: String = "Test note"
    ) -> NoblePatternSymptomAtlasLogEntry {
        let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasMedicationName.map {
            NoblePatternSymptomAtlasMedicationEntry(NoblePatternSymptomAtlasName: $0, NoblePatternSymptomAtlasDose: "200mg", NoblePatternSymptomAtlasTime: NoblePatternSymptomAtlasDate)
        }
        return NoblePatternSymptomAtlasLogEntry(
            NoblePatternSymptomAtlasSymptoms: NoblePatternSymptomAtlasSymptoms,
            NoblePatternSymptomAtlasSeverity: NoblePatternSymptomAtlasSeverity,
            NoblePatternSymptomAtlasDate: NoblePatternSymptomAtlasDate,
            NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasMoodValue,
            NoblePatternSymptomAtlasSleepHours: NoblePatternSymptomAtlasSleep,
            NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStress,
            NoblePatternSymptomAtlasActivity: NoblePatternSymptomAtlasActivityValue,
            NoblePatternSymptomAtlasMeals: "Tea",
            NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedication,
            NoblePatternSymptomAtlasNotes: NoblePatternSymptomAtlasNotes
        )
    }

    private static func NoblePatternSymptomAtlasMakeDate(day NoblePatternSymptomAtlasDay: Int, hour NoblePatternSymptomAtlasHour: Int) -> Date {
        var NoblePatternSymptomAtlasComponents = DateComponents()
        NoblePatternSymptomAtlasComponents.year = 2026
        NoblePatternSymptomAtlasComponents.month = 6
        NoblePatternSymptomAtlasComponents.day = NoblePatternSymptomAtlasDay
        NoblePatternSymptomAtlasComponents.hour = NoblePatternSymptomAtlasHour
        return Calendar(identifier: .gregorian).date(from: NoblePatternSymptomAtlasComponents)!
    }

    private static func NoblePatternSymptomAtlasFreshDefaults() -> UserDefaults {
        let NoblePatternSymptomAtlasSuiteName = "NoblePatternSymptomAtlasTests"
        let NoblePatternSymptomAtlasDefaults = UserDefaults(suiteName: NoblePatternSymptomAtlasSuiteName)!
        NoblePatternSymptomAtlasDefaults.removePersistentDomain(forName: NoblePatternSymptomAtlasSuiteName)
        return NoblePatternSymptomAtlasDefaults
    }
}
