import SwiftUI

struct NoblePatternSymptomAtlasScreen<Content: View>: View {
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasContent: Content

    init(_ NoblePatternSymptomAtlasTitle: String, @ViewBuilder content NoblePatternSymptomAtlasContent: () -> Content) {
        self.NoblePatternSymptomAtlasTitle = NoblePatternSymptomAtlasTitle
        self.NoblePatternSymptomAtlasContent = NoblePatternSymptomAtlasContent()
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(NoblePatternSymptomAtlasTitle)
                        .font(.largeTitle.bold())
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                    NoblePatternSymptomAtlasContent
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 130)
            }
        }
        .background(Color.clear)
        .navigationBarHidden(true)
    }
}

struct NoblePatternSymptomAtlasDashboardView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @State private var NoblePatternSymptomAtlasShowSettings = false

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    NoblePatternSymptomAtlasDashboardHeader(
                        NoblePatternSymptomAtlasShowSettings: $NoblePatternSymptomAtlasShowSettings
                    )

                    Text("Dashboard")
                        .font(.largeTitle.bold())
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                    NoblePatternSymptomAtlasStatusCard(
                        NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasLatestMood,
                        NoblePatternSymptomAtlasSleep: NoblePatternSymptomAtlasLatestSleep,
                        NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasLatestMedication,
                        NoblePatternSymptomAtlasActiveSymptoms: "\(NoblePatternSymptomAtlasTodaysSymptomCount)"
                    )

                    NoblePatternSymptomAtlasInfoCard(
                        NoblePatternSymptomAtlasTitle: "Quick Summary",
                        NoblePatternSymptomAtlasText: "\(NoblePatternSymptomAtlasTodaysSymptomCount) symptoms logged today"
                    )

                    NoblePatternSymptomAtlasInfoCard(
                        NoblePatternSymptomAtlasTitle: "Recent Pattern",
                        NoblePatternSymptomAtlasText: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasRecentPattern
                    )

                    NoblePatternSymptomAtlasQuickAddCard()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 130)
            }
        }
        .background(Color.clear)
        .navigationBarHidden(true)
        .sheet(isPresented: $NoblePatternSymptomAtlasShowSettings) {
            NoblePatternSymptomAtlasSettingsView()
                .environmentObject(NoblePatternSymptomAtlasViewModel)
        }
    }

    private var NoblePatternSymptomAtlasTodaysSymptomCount: Int {
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.flatMap(\.NoblePatternSymptomAtlasSymptoms).count
    }

    private var NoblePatternSymptomAtlasLatestMood: String {
        guard let NoblePatternSymptomAtlasMood = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.first?.NoblePatternSymptomAtlasMood else { return "🙂" }
        return "\(NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasEmoji) \(NoblePatternSymptomAtlasMood.rawValue)"
    }

    private var NoblePatternSymptomAtlasLatestSleep: String {
        guard let NoblePatternSymptomAtlasSleep = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.first?.NoblePatternSymptomAtlasSleepHours else { return "😴 -" }
        return "😴 \(NoblePatternSymptomAtlasSleep)h"
    }

    private var NoblePatternSymptomAtlasLatestMedication: String {
        guard let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.first(where: { $0.NoblePatternSymptomAtlasMedication != nil })?.NoblePatternSymptomAtlasMedication else { return "💊 -" }
        return "💊 \(NoblePatternSymptomAtlasMedication.NoblePatternSymptomAtlasName)"
    }
}

struct NoblePatternSymptomAtlasDashboardHeader: View {
    @Binding var NoblePatternSymptomAtlasShowSettings: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Noble Pattern")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                Text("Offline symptom tracking")
                    .font(.subheadline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }

            Spacer()

            Button {
                NoblePatternSymptomAtlasShowSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                    .frame(width: 52, height: 52)
                    .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasCard.opacity(0.92))
                    .cornerRadius(8)
            }
            .accessibilityLabel("Settings")
        }
    }
}

struct NoblePatternSymptomAtlasStatusCard: View {
    let NoblePatternSymptomAtlasMood: String
    let NoblePatternSymptomAtlasSleep: String
    let NoblePatternSymptomAtlasMedication: String
    let NoblePatternSymptomAtlasActiveSymptoms: String

    var body: some View {
        NoblePatternSymptomAtlasCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Today's Status")
                    .font(.headline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    NoblePatternSymptomAtlasStatusTile(title: "Mood", value: NoblePatternSymptomAtlasMood)
                    NoblePatternSymptomAtlasStatusTile(title: "Sleep", value: NoblePatternSymptomAtlasSleep)
                    NoblePatternSymptomAtlasStatusTile(title: "Medication", value: NoblePatternSymptomAtlasMedication)
                    NoblePatternSymptomAtlasStatusTile(title: "Active Symptoms", value: NoblePatternSymptomAtlasActiveSymptoms)
                }
            }
        }
    }
}

struct NoblePatternSymptomAtlasInfoCard: View {
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasText: String

    var body: some View {
        NoblePatternSymptomAtlasCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(NoblePatternSymptomAtlasTitle)
                    .font(.headline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                Text(NoblePatternSymptomAtlasText)
                    .font(.body)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }
        }
    }
}

struct NoblePatternSymptomAtlasQuickAddCard: View {
    var body: some View {
        NoblePatternSymptomAtlasCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                    Text("Quick Add")
                        .font(.headline)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    Spacer()
                }
                Text("Open the Log tab to add symptoms, medication, sleep, stress, and notes.")
                    .font(.subheadline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }
        }
    }
}

struct NoblePatternSymptomAtlasStatusTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 74, alignment: .leading)
        .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
        .cornerRadius(8)
    }
}

struct NoblePatternSymptomAtlasLogView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @StateObject private var NoblePatternSymptomAtlasForm = NoblePatternSymptomAtlasLogFormViewModel()
    @State private var NoblePatternSymptomAtlasSaved = false

    var body: some View {
        NoblePatternSymptomAtlasScreen("Log") {
            NoblePatternSymptomAtlasCard {
                Text("Symptoms")
                    .font(.headline)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(NoblePatternSymptomAtlasSymptom.allCases) { NoblePatternSymptomAtlasSymptom in
                        Button {
                            if NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.contains(NoblePatternSymptomAtlasSymptom) {
                                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.remove(NoblePatternSymptomAtlasSymptom)
                            } else {
                                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.insert(NoblePatternSymptomAtlasSymptom)
                            }
                        } label: {
                            HStack {
                                Text(NoblePatternSymptomAtlasSymptom.NoblePatternSymptomAtlasEmoji)
                                Text(NoblePatternSymptomAtlasSymptom.rawValue)
                                    .font(.caption.weight(.medium))
                                Spacer()
                            }
                            .padding(10)
                            .frame(minHeight: 44)
                            .background(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.contains(NoblePatternSymptomAtlasSymptom) ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.18) : NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            NoblePatternSymptomAtlasCard {
                Text("Severity")
                    .font(.headline)
                HStack {
                    Slider(value: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSeverity, in: 0...10, step: 1)
                    Text("\(Int(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSeverity))")
                        .font(.title3.weight(.semibold))
                        .frame(width: 34)
                }
                DatePicker("Time", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasDate, displayedComponents: [.date, .hourAndMinute])
                Stepper("Sleep: \(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours) hours", value: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours, in: 0...12)
            }

            NoblePatternSymptomAtlasCard {
                Text("Mood")
                    .font(.headline)
                Picker("Mood", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMood) {
                    ForEach(NoblePatternSymptomAtlasMood.allCases) { NoblePatternSymptomAtlasMood in
                        Text("\(NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasEmoji) \(NoblePatternSymptomAtlasMood.rawValue)").tag(NoblePatternSymptomAtlasMood)
                    }
                }
                .pickerStyle(.segmented)
                Picker("Stress", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasStress) {
                    ForEach(NoblePatternSymptomAtlasStressLevel.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                Picker("Activity", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasActivity) {
                    ForEach(NoblePatternSymptomAtlasActivity.allCases) { Text($0.rawValue).tag($0) }
                }
            }

            NoblePatternSymptomAtlasCard {
                Text("Meals")
                    .font(.headline)
                TextField("Short note", text: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMeals)
                    .textFieldStyle(.roundedBorder)
                Text("Medication")
                    .font(.headline)
                    .padding(.top, 8)
                TextField("Name", text: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMedicationName)
                    .textFieldStyle(.roundedBorder)
                TextField("Dose", text: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMedicationDose)
                    .textFieldStyle(.roundedBorder)
                DatePicker("Medication Time", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMedicationTime, displayedComponents: .hourAndMinute)
            }

            NoblePatternSymptomAtlasCard {
                Text("Notes")
                    .font(.headline)
                TextEditor(text: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasNotes)
                    .frame(minHeight: 100)
                    .padding(6)
                    .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
                    .cornerRadius(8)
            }

            Button {
                NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasAddLog(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMakeLog())
                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasReset()
                NoblePatternSymptomAtlasSaved = true
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Save")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasCanSave ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(!NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasCanSave)
        }
        .alert("Saved", isPresented: $NoblePatternSymptomAtlasSaved) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your log was saved locally.")
        }
    }
}

struct NoblePatternSymptomAtlasTimelineView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel

    var body: some View {
        NoblePatternSymptomAtlasScreen("Timeline") {
            HStack {
                Button { NoblePatternSymptomAtlasMoveWeek(-1) } label: { Image(systemName: "chevron.left") }
                Spacer()
                Text(NoblePatternSymptomAtlasWeekLabel)
                    .font(.headline)
                Spacer()
                Button { NoblePatternSymptomAtlasMoveWeek(1) } label: { Image(systemName: "chevron.right") }
            }
            .padding(.horizontal, 8)

            ForEach(NoblePatternSymptomAtlasGroupedDays, id: \.0) { NoblePatternSymptomAtlasDay, NoblePatternSymptomAtlasLogs in
                NoblePatternSymptomAtlasCard {
                    Text(NoblePatternSymptomAtlasDayLabel(NoblePatternSymptomAtlasDay))
                        .font(.headline)
                    VStack(spacing: 12) {
                        ForEach(NoblePatternSymptomAtlasLogs) { NoblePatternSymptomAtlasLog in
                            HStack(alignment: .top, spacing: 12) {
                                Text(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate, style: .time)
                                    .font(.caption.weight(.semibold))
                                    .frame(width: 54, alignment: .leading)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(NoblePatternSymptomAtlasTimelineTitle(NoblePatternSymptomAtlasLog))
                                        .font(.subheadline.weight(.semibold))
                                    Text("Severity \(Int(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSeverity))")
                                        .font(.caption)
                                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                                    if let NoblePatternSymptomAtlasMedication = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication {
                                        Text("💊 \(NoblePatternSymptomAtlasMedication.NoblePatternSymptomAtlasName)")
                                            .font(.caption)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }

            if NoblePatternSymptomAtlasGroupedDays.isEmpty {
                NoblePatternSymptomAtlasCard {
                    Text("No logs this week")
                        .font(.headline)
                    Text("Saved entries will appear here by day and time.")
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                }
            }
        }
    }

    private var NoblePatternSymptomAtlasWeekLogs: [NoblePatternSymptomAtlasLogEntry] {
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        guard let NoblePatternSymptomAtlasInterval = NoblePatternSymptomAtlasCalendar.dateInterval(of: .weekOfYear, for: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSelectedWeek) else { return [] }
        return NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs.filter { NoblePatternSymptomAtlasInterval.contains($0.NoblePatternSymptomAtlasDate) }
    }

    private var NoblePatternSymptomAtlasGroupedDays: [(Date, [NoblePatternSymptomAtlasLogEntry])] {
        let NoblePatternSymptomAtlasGrouped = Dictionary(grouping: NoblePatternSymptomAtlasWeekLogs) { Calendar.current.startOfDay(for: $0.NoblePatternSymptomAtlasDate) }
        return NoblePatternSymptomAtlasGrouped.map { ($0.key, $0.value.sorted { $0.NoblePatternSymptomAtlasDate < $1.NoblePatternSymptomAtlasDate }) }.sorted { $0.0 > $1.0 }
    }

    private var NoblePatternSymptomAtlasWeekLabel: String {
        let NoblePatternSymptomAtlasFormatter = DateFormatter()
        NoblePatternSymptomAtlasFormatter.dateFormat = "MMM d"
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        guard let NoblePatternSymptomAtlasInterval = NoblePatternSymptomAtlasCalendar.dateInterval(of: .weekOfYear, for: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSelectedWeek) else { return "This week" }
        let NoblePatternSymptomAtlasEnd = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -1, to: NoblePatternSymptomAtlasInterval.end) ?? NoblePatternSymptomAtlasInterval.end
        return "\(NoblePatternSymptomAtlasFormatter.string(from: NoblePatternSymptomAtlasInterval.start)) - \(NoblePatternSymptomAtlasFormatter.string(from: NoblePatternSymptomAtlasEnd))"
    }

    private func NoblePatternSymptomAtlasMoveWeek(_ NoblePatternSymptomAtlasValue: Int) {
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSelectedWeek = Calendar.current.date(byAdding: .weekOfYear, value: NoblePatternSymptomAtlasValue, to: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSelectedWeek) ?? Date()
    }

    private func NoblePatternSymptomAtlasDayLabel(_ NoblePatternSymptomAtlasDate: Date) -> String {
        Calendar.current.isDateInToday(NoblePatternSymptomAtlasDate) ? "Today" : NoblePatternSymptomAtlasDate.formatted(date: .complete, time: .omitted)
    }

    private func NoblePatternSymptomAtlasTimelineTitle(_ NoblePatternSymptomAtlasLog: NoblePatternSymptomAtlasLogEntry) -> String {
        if let NoblePatternSymptomAtlasFirst = NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.first {
            return "\(NoblePatternSymptomAtlasFirst.NoblePatternSymptomAtlasEmoji) \(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasSymptoms.map(\.rawValue).joined(separator: ", "))"
        }
        if NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMedication != nil { return "💊 Medication" }
        return "\(NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasEmoji) Feeling logged"
    }
}

struct NoblePatternSymptomAtlasPatternsView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @State private var NoblePatternSymptomAtlasMode = 0

    var body: some View {
        NoblePatternSymptomAtlasScreen("Patterns") {
            Picker("View", selection: $NoblePatternSymptomAtlasMode) {
                Text("Patterns").tag(0)
                Text("Atlas").tag(1)
            }
            .pickerStyle(.segmented)

            if NoblePatternSymptomAtlasMode == 0 {
                NoblePatternSymptomAtlasPatternsContent(NoblePatternSymptomAtlasSummary: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSummary)
            } else {
                NoblePatternSymptomAtlasAtlasView(NoblePatternSymptomAtlasLogs: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs)
            }
        }
    }
}

struct NoblePatternSymptomAtlasPatternsContent: View {
    let NoblePatternSymptomAtlasSummary: NoblePatternSymptomAtlasPatternSummary

    var body: some View {
        NoblePatternSymptomAtlasCard {
            Text("Most Common Symptoms")
                .font(.headline)
            if NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms.isEmpty {
                Text("Top symptoms will appear after logs are saved.")
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            } else {
                ForEach(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTopSymptoms, id: \.0) { NoblePatternSymptomAtlasSymptom, NoblePatternSymptomAtlasCount in
                    HStack {
                        Text("\(NoblePatternSymptomAtlasSymptom.NoblePatternSymptomAtlasEmoji) \(NoblePatternSymptomAtlasSymptom.rawValue)")
                        Spacer()
                        Text("\(NoblePatternSymptomAtlasCount)")
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                    }
                    .padding(.vertical, 4)
                }
            }
        }

        NoblePatternSymptomAtlasCard {
            Text("Most Active Time")
                .font(.headline)
            Text(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasMostActiveTime?.rawValue ?? "More logs needed")
                .font(.title3.weight(.semibold))
            NoblePatternSymptomAtlasBarChart(NoblePatternSymptomAtlasValues: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasTimeBuckets.map { ($0.0.rawValue, $0.1) })
        }

        NoblePatternSymptomAtlasPatternCard(title: "Sleep", text: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasSleepPattern)
        NoblePatternSymptomAtlasPatternCard(title: "Stress", text: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasStressPattern)
        NoblePatternSymptomAtlasPatternCard(title: "Weekdays", text: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasWeekdayPattern)
        NoblePatternSymptomAtlasPatternCard(title: "Mood", text: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasMoodPattern)
        NoblePatternSymptomAtlasPatternCard(title: "Medication", text: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasMedicationPattern)

        NoblePatternSymptomAtlasCard {
            Text("Severity Trend")
                .font(.headline)
            NoblePatternSymptomAtlasLineChart(NoblePatternSymptomAtlasValues: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasDailySeverity)
        }

        NoblePatternSymptomAtlasCard {
            Text("Calendar Heatmap")
                .font(.headline)
            NoblePatternSymptomAtlasHeatmap(NoblePatternSymptomAtlasValues: NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasHeatmap)
        }
    }
}

struct NoblePatternSymptomAtlasPatternCard: View {
    let title: String
    let text: String

    var body: some View {
        NoblePatternSymptomAtlasCard {
            Text(title)
                .font(.headline)
            Text(text)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
        }
    }
}

struct NoblePatternSymptomAtlasAtlasView: View {
    let NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]

    var body: some View {
        NoblePatternSymptomAtlasCard {
            Text("Symptom Atlas")
                .font(.headline)
            ForEach(NoblePatternSymptomAtlasSymptom.allCases) { NoblePatternSymptomAtlasSymptom in
                HStack {
                    Text(NoblePatternSymptomAtlasSymptom.NoblePatternSymptomAtlasEmoji)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NoblePatternSymptomAtlasSymptom.rawValue)
                            .font(.subheadline.weight(.semibold))
                        Text(NoblePatternSymptomAtlasCountText(for: NoblePatternSymptomAtlasSymptom))
                            .font(.caption)
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                    }
                    Spacer()
                    if NoblePatternSymptomAtlasCount(for: NoblePatternSymptomAtlasSymptom) > 0 {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }

    private func NoblePatternSymptomAtlasCount(for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> Int {
        NoblePatternSymptomAtlasLogs.filter { $0.NoblePatternSymptomAtlasSymptoms.contains(NoblePatternSymptomAtlasSymptom) }.count
    }

    private func NoblePatternSymptomAtlasCountText(for NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> String {
        let NoblePatternSymptomAtlasCount = NoblePatternSymptomAtlasCount(for: NoblePatternSymptomAtlasSymptom)
        return NoblePatternSymptomAtlasCount == 0 ? "Never logged" : "Logged \(NoblePatternSymptomAtlasCount) times"
    }
}

struct NoblePatternSymptomAtlasReportsView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @State private var NoblePatternSymptomAtlasShareItems: [Any] = []
    @State private var NoblePatternSymptomAtlasShowShare = false

    var body: some View {
        NoblePatternSymptomAtlasScreen("Reports") {
            NoblePatternSymptomAtlasCard {
                Text("Filter")
                    .font(.headline)
                DatePicker("Date From", selection: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasDateFrom, displayedComponents: .date)
                DatePicker("Date To", selection: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasDateTo, displayedComponents: .date)
            }

            NoblePatternSymptomAtlasCard {
                Text("Include")
                    .font(.headline)
                Toggle("Symptoms", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeSymptoms)
                Toggle("Medication", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeMedication)
                Toggle("Notes", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeNotes)
                Toggle("Sleep", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeSleep)
                Toggle("Stress", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeStress)
                Toggle("Charts", isOn: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasReportFilterState.NoblePatternSymptomAtlasIncludeCharts)
            }

            NoblePatternSymptomAtlasCard {
                Text("\(NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasFilteredReportLogs.count) entries in range")
                    .font(.headline)
                Text("Exports are generated locally on this device.")
                    .font(.subheadline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }

            NoblePatternSymptomAtlasExportButton(title: "Export PDF", systemImage: "doc.richtext") {
                if let NoblePatternSymptomAtlasURL = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasPDFURL() {
                    NoblePatternSymptomAtlasShareItems = [NoblePatternSymptomAtlasURL]
                    NoblePatternSymptomAtlasShowShare = true
                }
            }

            NoblePatternSymptomAtlasExportButton(title: "Export CSV", systemImage: "tablecells") {
                if let NoblePatternSymptomAtlasURL = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasCSVURL() {
                    NoblePatternSymptomAtlasShareItems = [NoblePatternSymptomAtlasURL]
                    NoblePatternSymptomAtlasShowShare = true
                }
            }

            NoblePatternSymptomAtlasExportButton(title: "Share", systemImage: "square.and.arrow.up") {
                NoblePatternSymptomAtlasShareItems = ["Noble Pattern: Symptom Atlas report", NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasRecentPattern]
                NoblePatternSymptomAtlasShowShare = true
            }
        }
        .sheet(isPresented: $NoblePatternSymptomAtlasShowShare) {
            NoblePatternSymptomAtlasShareSheet(NoblePatternSymptomAtlasItems: NoblePatternSymptomAtlasShareItems)
        }
    }
}

struct NoblePatternSymptomAtlasExportButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasCard)
            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
            .cornerRadius(8)
        }
    }
}

struct NoblePatternSymptomAtlasSettingsView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @Environment(\.dismiss) private var NoblePatternSymptomAtlasDismiss
    @State private var NoblePatternSymptomAtlasShowPrivacy = false
    @State private var NoblePatternSymptomAtlasShowReset = false
    @State private var NoblePatternSymptomAtlasShowShare = false

    var body: some View {
        ZStack {
            NoblePatternSymptomAtlasBackgroundView(
                NoblePatternSymptomAtlasOverlayOpacity: 0.50
            )

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Settings")
                                .font(.largeTitle.bold())
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                            Text("Privacy, sharing, and app preferences")
                                .font(.subheadline)
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                        }

                        Spacer()

                        Button {
                            NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSaveSettings()
                            NoblePatternSymptomAtlasDismiss()
                        } label: {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                                .padding(.horizontal, 20)
                                .frame(height: 52)
                                .background(Color.white.opacity(0.90))
                                .cornerRadius(26)
                                .shadow(color: Color.black.opacity(0.06), radius: 14, x: 0, y: 8)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        NoblePatternSymptomAtlasSettingsSectionTitle("Appearance")
                        NoblePatternSymptomAtlasSettingsCard {
                            HStack(spacing: 14) {
                                NoblePatternSymptomAtlasSettingsIcon(systemImage: "heart.text.square", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                                Text("App Icon")
                                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                                Spacer()
                                Picker("App Icon", selection: $NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasSettingsState.NoblePatternSymptomAtlasAppIcon) {
                                    Text("Heart Nodes").tag("Heart Nodes")
                                }
                                .pickerStyle(.menu)
                                .accentColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        NoblePatternSymptomAtlasSettingsSectionTitle("App")
                        NoblePatternSymptomAtlasSettingsCard {
                            VStack(spacing: 0) {
                                NoblePatternSymptomAtlasSettingsButtonRow(title: "Privacy Policy", systemImage: "lock.shield", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage) {
                                    NoblePatternSymptomAtlasShowPrivacy = true
                                }

                                NoblePatternSymptomAtlasSettingsDivider()

                                NoblePatternSymptomAtlasSettingsButtonRow(title: "Rate App", systemImage: "star", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue) {
                                    if let NoblePatternSymptomAtlasURL = URL(string: "itms-apps://itunes.apple.com/app/id0000000000") {
                                        UIApplication.shared.open(NoblePatternSymptomAtlasURL)
                                    }
                                }

                                NoblePatternSymptomAtlasSettingsDivider()

                                NoblePatternSymptomAtlasSettingsButtonRow(title: "Share App", systemImage: "square.and.arrow.up", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage) {
                                    NoblePatternSymptomAtlasShowShare = true
                                }

                                NoblePatternSymptomAtlasSettingsDivider()

                                NoblePatternSymptomAtlasSettingsValueRow(title: "Version", value: "1.0", systemImage: "info.circle", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                            }
                        }
                    }

                    NoblePatternSymptomAtlasSettingsCard {
                        Button {
                            NoblePatternSymptomAtlasShowReset = true
                        } label: {
                            HStack(spacing: 14) {
                                NoblePatternSymptomAtlasSettingsIcon(systemImage: "trash", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasRose)
                                Text("Reset Data")
                                    .font(.body.weight(.semibold))
                                Spacer()
                            }
                            .foregroundColor(Color(red: 0.94, green: 0.20, blue: 0.24))
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 48)
            }
        }
        .background(Color.clear)
        .alert("Reset Data?", isPresented: $NoblePatternSymptomAtlasShowReset) {
            Button("Reset", role: .destructive) { NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasResetData() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears saved logs and settings from this device.")
        }
        .sheet(isPresented: $NoblePatternSymptomAtlasShowPrivacy) {
            NoblePatternSymptomAtlasSafariView(NoblePatternSymptomAtlasURL: URL(string: "https://www.apple.com/legal/privacy/")!)
        }
        .sheet(isPresented: $NoblePatternSymptomAtlasShowShare) {
            NoblePatternSymptomAtlasShareSheet(NoblePatternSymptomAtlasItems: ["Noble Pattern: Symptom Atlas"])
        }
    }
}

struct NoblePatternSymptomAtlasSettingsSectionTitle: View {
    let NoblePatternSymptomAtlasTitle: String

    init(_ NoblePatternSymptomAtlasTitle: String) {
        self.NoblePatternSymptomAtlasTitle = NoblePatternSymptomAtlasTitle
    }

    var body: some View {
        Text(NoblePatternSymptomAtlasTitle)
            .font(.headline)
            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            .padding(.horizontal, 4)
    }
}

struct NoblePatternSymptomAtlasSettingsCard<Content: View>: View {
    let NoblePatternSymptomAtlasContent: Content

    init(@ViewBuilder content NoblePatternSymptomAtlasContent: () -> Content) {
        self.NoblePatternSymptomAtlasContent = NoblePatternSymptomAtlasContent()
    }

    var body: some View {
        NoblePatternSymptomAtlasContent
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.90))
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.07), radius: 20, x: 0, y: 10)
    }
}

struct NoblePatternSymptomAtlasSettingsIcon: View {
    let systemImage: String
    let tint: Color

    var body: some View {
        Image(systemName: systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(tint)
            .frame(width: 34, height: 34)
            .background(tint.opacity(0.14))
            .cornerRadius(12)
    }
}

struct NoblePatternSymptomAtlasSettingsButtonRow: View {
    let title: String
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                NoblePatternSymptomAtlasSettingsIcon(systemImage: systemImage, tint: tint)
                Text(title)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted.opacity(0.6))
            }
            .frame(minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct NoblePatternSymptomAtlasSettingsValueRow: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 14) {
            NoblePatternSymptomAtlasSettingsIcon(systemImage: systemImage, tint: tint)
            Text(title)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
            Spacer()
            Text(value)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
        }
        .frame(minHeight: 48)
    }
}

struct NoblePatternSymptomAtlasSettingsDivider: View {
    var body: some View {
        Rectangle()
            .fill(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasLine.opacity(0.85))
            .frame(height: 1)
            .padding(.leading, 48)
            .padding(.vertical, 8)
    }
}
