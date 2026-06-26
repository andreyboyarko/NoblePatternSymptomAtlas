import XCTest
@testable import NoblePatternSymptomAtlas

final class NoblePatternSymptomAtlasTests: XCTestCase {
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

    private static func NoblePatternSymptomAtlasMakeLog(
        symptoms NoblePatternSymptomAtlasSymptoms: [NoblePatternSymptomAtlasSymptom] = [.headache],
        severity NoblePatternSymptomAtlasSeverity: Double = 5,
        date NoblePatternSymptomAtlasDate: Date = Date(timeIntervalSince1970: 1_700_000_000),
        sleep NoblePatternSymptomAtlasSleep: Int = 7,
        stress NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStressLevel = .medium,
        medicationName NoblePatternSymptomAtlasMedicationName: String? = nil
    ) -> NoblePatternSymptomAtlasLogEntry {
        let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasMedicationName.map {
            NoblePatternSymptomAtlasMedicationEntry(NoblePatternSymptomAtlasName: $0, NoblePatternSymptomAtlasDose: "200mg", NoblePatternSymptomAtlasTime: NoblePatternSymptomAtlasDate)
        }
        return NoblePatternSymptomAtlasLogEntry(
            NoblePatternSymptomAtlasSymptoms: NoblePatternSymptomAtlasSymptoms,
            NoblePatternSymptomAtlasSeverity: NoblePatternSymptomAtlasSeverity,
            NoblePatternSymptomAtlasDate: NoblePatternSymptomAtlasDate,
            NoblePatternSymptomAtlasMood: .low,
            NoblePatternSymptomAtlasSleepHours: NoblePatternSymptomAtlasSleep,
            NoblePatternSymptomAtlasStress: NoblePatternSymptomAtlasStress,
            NoblePatternSymptomAtlasActivity: .rest,
            NoblePatternSymptomAtlasMeals: "Tea",
            NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasMedication,
            NoblePatternSymptomAtlasNotes: "Test note"
        )
    }
}
