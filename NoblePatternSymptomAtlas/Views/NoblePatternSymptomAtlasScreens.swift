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
            NoblePatternSymptomAtlasBackgroundView(NoblePatternSymptomAtlasOverlayOpacity: 0.45)

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
    @State private var NoblePatternSymptomAtlasShowQuickLog = false
    @State private var NoblePatternSymptomAtlasQuickLogSaved = false

    var body: some View {
        ZStack {
            NoblePatternSymptomAtlasBackgroundView(NoblePatternSymptomAtlasOverlayOpacity: 0.45)

            VStack(spacing: 0) {
                NoblePatternSymptomAtlasDashboardNavigationBar(
                    NoblePatternSymptomAtlasShowSettings: $NoblePatternSymptomAtlasShowSettings
                )
                .padding(.horizontal, 22)
                .padding(.top, 8)
                .padding(.bottom, 6)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dashboard")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                        NoblePatternSymptomAtlasStatusCard(
                            NoblePatternSymptomAtlasMood: NoblePatternSymptomAtlasLatestMood,
                            NoblePatternSymptomAtlasSleep: NoblePatternSymptomAtlasLatestSleep,
                            NoblePatternSymptomAtlasMedication: NoblePatternSymptomAtlasLatestMedication,
                            NoblePatternSymptomAtlasActiveSymptoms: "\(NoblePatternSymptomAtlasTodaysSymptomCount)"
                        )

                        NoblePatternSymptomAtlasDashboardRow(
                            NoblePatternSymptomAtlasSystemImage: "waveform.path.ecg",
                            NoblePatternSymptomAtlasIconTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage,
                            NoblePatternSymptomAtlasTitle: "Quick Summary",
                            NoblePatternSymptomAtlasSubtitle: "\(NoblePatternSymptomAtlasTodaysSymptomCount) symptoms logged today",
                            NoblePatternSymptomAtlasAction: {
                                NotificationCenter.default.post(name: .NoblePatternSymptomAtlasShowTimelineTab, object: nil)
                            }
                        )

                        NoblePatternSymptomAtlasDashboardDivider()

                        NoblePatternSymptomAtlasDashboardRow(
                            NoblePatternSymptomAtlasSystemImage: "chart.bar.xaxis",
                            NoblePatternSymptomAtlasIconTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue,
                            NoblePatternSymptomAtlasTitle: "Recent Pattern",
                            NoblePatternSymptomAtlasSubtitle: NoblePatternSymptomAtlasRecentPatternSubtitle,
                            NoblePatternSymptomAtlasAction: {
                                NotificationCenter.default.post(name: .NoblePatternSymptomAtlasShowPatternsTab, object: nil)
                            }
                        )

                        NoblePatternSymptomAtlasDashboardDivider()

                        NoblePatternSymptomAtlasWeeklyOverviewView(
                            NoblePatternSymptomAtlasLogs: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs
                        )

                        NoblePatternSymptomAtlasLogSymptomButton(
                            NoblePatternSymptomAtlasTitle: "Quick Log",
                            NoblePatternSymptomAtlasAction: {
                                NoblePatternSymptomAtlasShowQuickLog = true
                            }
                        )
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 4)
                    .padding(.bottom, 104)
                }
            }
        }
        .background(Color.clear)
        .navigationBarHidden(true)
        .sheet(isPresented: $NoblePatternSymptomAtlasShowSettings) {
            NoblePatternSymptomAtlasSettingsView()
                .environmentObject(NoblePatternSymptomAtlasViewModel)
        }
        .sheet(isPresented: $NoblePatternSymptomAtlasShowQuickLog) {
            NoblePatternSymptomAtlasQuickLogView(
                NoblePatternSymptomAtlasIsPresented: $NoblePatternSymptomAtlasShowQuickLog,
                NoblePatternSymptomAtlasDidSave: $NoblePatternSymptomAtlasQuickLogSaved
            )
            .environmentObject(NoblePatternSymptomAtlasViewModel)
        }
        .alert("Saved", isPresented: $NoblePatternSymptomAtlasQuickLogSaved) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your quick log was saved locally.")
        }
    }

    private var NoblePatternSymptomAtlasTodaysSymptomCount: Int {
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.flatMap(\.NoblePatternSymptomAtlasSymptoms).count
    }

    private var NoblePatternSymptomAtlasLatestMood: String {
        guard let NoblePatternSymptomAtlasMood = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.first?.NoblePatternSymptomAtlasMood else { return "-" }
        return NoblePatternSymptomAtlasMood.rawValue
    }

    private var NoblePatternSymptomAtlasLatestSleep: String {
        guard let NoblePatternSymptomAtlasSleep = NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.first?.NoblePatternSymptomAtlasSleepHours else { return "-" }
        return "\(NoblePatternSymptomAtlasSleep)h"
    }

    private var NoblePatternSymptomAtlasLatestMedication: String {
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasTodaysLogs.contains { $0.NoblePatternSymptomAtlasMedication != nil } ? "Taken" : "-"
    }

    private var NoblePatternSymptomAtlasRecentPatternSubtitle: String {
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs.isEmpty ? "No patterns found yet.\nAdd more logs to start discovering patterns." : "Possible pattern found"
    }
}

struct NoblePatternSymptomAtlasDashboardNavigationBar: View {
    @Binding var NoblePatternSymptomAtlasShowSettings: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            NoblePatternSymptomAtlasMiniLogoView()

            VStack(alignment: .leading, spacing: 3) {
                Text("Noble Pattern")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                Text("Offline symptom tracking")
                    .font(.caption)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }

            Spacer()

            Button {
                NoblePatternSymptomAtlasShowSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.headline.weight(.medium))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.88))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
            .accessibilityLabel("Settings")
        }
        .frame(height: 46)
    }
}

struct NoblePatternSymptomAtlasMiniLogoView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.86))
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
        }
        .frame(width: 38, height: 38)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 5)
    }
}

struct NoblePatternSymptomAtlasStatusCard: View {
    let NoblePatternSymptomAtlasMood: String
    let NoblePatternSymptomAtlasSleep: String
    let NoblePatternSymptomAtlasMedication: String
    let NoblePatternSymptomAtlasActiveSymptoms: String

    var body: some View {
        NoblePatternSymptomAtlasCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Status")
                    .font(.headline.bold())
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    NoblePatternSymptomAtlasStatusTile(
                        NoblePatternSymptomAtlasTitle: "Mood",
                        NoblePatternSymptomAtlasValue: NoblePatternSymptomAtlasMood,
                        NoblePatternSymptomAtlasSystemImage: "face.smiling",
                        NoblePatternSymptomAtlasTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage
                    )
                    NoblePatternSymptomAtlasStatusTile(
                        NoblePatternSymptomAtlasTitle: "Sleep",
                        NoblePatternSymptomAtlasValue: NoblePatternSymptomAtlasSleep,
                        NoblePatternSymptomAtlasSystemImage: "moon.zzz.fill",
                        NoblePatternSymptomAtlasTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue
                    )
                    NoblePatternSymptomAtlasStatusTile(
                        NoblePatternSymptomAtlasTitle: "Medication",
                        NoblePatternSymptomAtlasValue: NoblePatternSymptomAtlasMedication,
                        NoblePatternSymptomAtlasSystemImage: "pills.fill",
                        NoblePatternSymptomAtlasTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasOrange
                    )
                    NoblePatternSymptomAtlasStatusTile(
                        NoblePatternSymptomAtlasTitle: "Active Symptoms",
                        NoblePatternSymptomAtlasValue: NoblePatternSymptomAtlasActiveSymptoms,
                        NoblePatternSymptomAtlasSystemImage: "list.clipboard.fill",
                        NoblePatternSymptomAtlasTint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal
                    )
                }
            }
        }
    }
}

struct NoblePatternSymptomAtlasDashboardRow: View {
    let NoblePatternSymptomAtlasSystemImage: String
    let NoblePatternSymptomAtlasIconTint: Color
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasSubtitle: String
    let NoblePatternSymptomAtlasAction: () -> Void

    var body: some View {
        Button(action: NoblePatternSymptomAtlasAction) {
            HStack(spacing: 10) {
                Image(systemName: NoblePatternSymptomAtlasSystemImage)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(NoblePatternSymptomAtlasIconTint)
                    .frame(width: 36, height: 36)
                    .background(NoblePatternSymptomAtlasIconTint.opacity(0.12))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(NoblePatternSymptomAtlasTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    Text(NoblePatternSymptomAtlasSubtitle)
                        .font(.system(size: 13))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted.opacity(0.6))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct NoblePatternSymptomAtlasDashboardDivider: View {
    var body: some View {
        Divider()
            .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasLine.opacity(0.18))
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
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasValue: String
    let NoblePatternSymptomAtlasSystemImage: String
    let NoblePatternSymptomAtlasTint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: NoblePatternSymptomAtlasSystemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(NoblePatternSymptomAtlasTint)

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 4) {
                Text(NoblePatternSymptomAtlasTitle)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                Text(NoblePatternSymptomAtlasValue)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(NoblePatternSymptomAtlasTint)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
        .background(NoblePatternSymptomAtlasTint.opacity(0.10))
        .cornerRadius(14)
    }
}

struct NoblePatternSymptomAtlasWeeklyOverviewView: View {
    let NoblePatternSymptomAtlasLogs: [NoblePatternSymptomAtlasLogEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal)
                    .frame(width: 36, height: 36)
                    .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal.opacity(0.12))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Weekly Overview")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    Text("Symptom intensity")
                        .font(.system(size: 13))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                }
            }

            NoblePatternSymptomAtlasWeeklyChartView(
                NoblePatternSymptomAtlasValues: NoblePatternSymptomAtlasWeeklyValues,
                NoblePatternSymptomAtlasHasLogs: NoblePatternSymptomAtlasHasWeeklyLogs
            )
            .frame(height: 96)
        }
    }

    private var NoblePatternSymptomAtlasHasWeeklyLogs: Bool {
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        let NoblePatternSymptomAtlasToday = Date()
        let NoblePatternSymptomAtlasWeekday = NoblePatternSymptomAtlasCalendar.component(.weekday, from: NoblePatternSymptomAtlasToday)
        let NoblePatternSymptomAtlasDaysSinceMonday = (NoblePatternSymptomAtlasWeekday + 5) % 7
        let NoblePatternSymptomAtlasMonday = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -NoblePatternSymptomAtlasDaysSinceMonday, to: NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasToday)) ?? NoblePatternSymptomAtlasToday
        let NoblePatternSymptomAtlasNextMonday = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: 7, to: NoblePatternSymptomAtlasMonday) ?? NoblePatternSymptomAtlasToday
        return NoblePatternSymptomAtlasLogs.contains { NoblePatternSymptomAtlasLog in
            NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasMonday && NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate < NoblePatternSymptomAtlasNextMonday
        }
    }

    private var NoblePatternSymptomAtlasWeeklyValues: [Double] {
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        let NoblePatternSymptomAtlasToday = Date()
        let NoblePatternSymptomAtlasWeekday = NoblePatternSymptomAtlasCalendar.component(.weekday, from: NoblePatternSymptomAtlasToday)
        let NoblePatternSymptomAtlasDaysSinceMonday = (NoblePatternSymptomAtlasWeekday + 5) % 7
        let NoblePatternSymptomAtlasMonday = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -NoblePatternSymptomAtlasDaysSinceMonday, to: NoblePatternSymptomAtlasCalendar.startOfDay(for: NoblePatternSymptomAtlasToday)) ?? NoblePatternSymptomAtlasToday

        return (0..<7).map { NoblePatternSymptomAtlasIndex in
            guard let NoblePatternSymptomAtlasDay = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: NoblePatternSymptomAtlasIndex, to: NoblePatternSymptomAtlasMonday) else { return 0 }
            let NoblePatternSymptomAtlasNextDay = NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: 1, to: NoblePatternSymptomAtlasDay) ?? NoblePatternSymptomAtlasDay
            let NoblePatternSymptomAtlasDayLogs = NoblePatternSymptomAtlasLogs.filter { NoblePatternSymptomAtlasLog in
                NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate >= NoblePatternSymptomAtlasDay && NoblePatternSymptomAtlasLog.NoblePatternSymptomAtlasDate < NoblePatternSymptomAtlasNextDay
            }
            guard !NoblePatternSymptomAtlasDayLogs.isEmpty else { return 0 }
            let NoblePatternSymptomAtlasAverage = NoblePatternSymptomAtlasDayLogs.map(\.NoblePatternSymptomAtlasSeverity).reduce(0, +) / Double(NoblePatternSymptomAtlasDayLogs.count)
            return min(max(NoblePatternSymptomAtlasAverage / 10, 0), 1)
        }
    }
}

struct NoblePatternSymptomAtlasWeeklyChartView: View {
    let NoblePatternSymptomAtlasValues: [Double]
    let NoblePatternSymptomAtlasHasLogs: Bool

    private let NoblePatternSymptomAtlasDayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let NoblePatternSymptomAtlasLevelLabels = ["High", "Medium", "Low", "None"]

    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasGeometry in
            let NoblePatternSymptomAtlasLabelWidth: CGFloat = 48
            let NoblePatternSymptomAtlasBottomHeight: CGFloat = 18
            let NoblePatternSymptomAtlasPlotWidth = max(1, NoblePatternSymptomAtlasGeometry.size.width - NoblePatternSymptomAtlasLabelWidth)
            let NoblePatternSymptomAtlasPlotHeight = max(1, NoblePatternSymptomAtlasGeometry.size.height - NoblePatternSymptomAtlasBottomHeight)

            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { NoblePatternSymptomAtlasIndex in
                        HStack(spacing: 10) {
                            Text(NoblePatternSymptomAtlasLevelLabels[NoblePatternSymptomAtlasIndex])
                                .font(.caption2.weight(.medium))
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                                .frame(width: NoblePatternSymptomAtlasLabelWidth - 10, alignment: .leading)

                            NoblePatternSymptomAtlasDottedLine()
                                .frame(height: 1)
                        }
                        .frame(height: NoblePatternSymptomAtlasPlotHeight / 4, alignment: .top)
                    }
                }

                ForEach(0..<7, id: \.self) { NoblePatternSymptomAtlasIndex in
                    let NoblePatternSymptomAtlasX = NoblePatternSymptomAtlasLabelWidth + NoblePatternSymptomAtlasPlotWidth * (CGFloat(NoblePatternSymptomAtlasIndex) + 0.5) / 7
                    let NoblePatternSymptomAtlasValue = NoblePatternSymptomAtlasValues.indices.contains(NoblePatternSymptomAtlasIndex) ? NoblePatternSymptomAtlasValues[NoblePatternSymptomAtlasIndex] : 0
                    let NoblePatternSymptomAtlasY = NoblePatternSymptomAtlasPlotHeight - CGFloat(NoblePatternSymptomAtlasValue) * (NoblePatternSymptomAtlasPlotHeight - 10)

                    Circle()
                        .fill(NoblePatternSymptomAtlasHasLogs ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal : NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted.opacity(0.45))
                        .frame(width: NoblePatternSymptomAtlasHasLogs ? 10 : 7, height: NoblePatternSymptomAtlasHasLogs ? 10 : 7)
                        .position(x: NoblePatternSymptomAtlasX, y: NoblePatternSymptomAtlasY)
                }

                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: NoblePatternSymptomAtlasLabelWidth)
                    ForEach(0..<7, id: \.self) { NoblePatternSymptomAtlasIndex in
                        Text(NoblePatternSymptomAtlasDayLabels[NoblePatternSymptomAtlasIndex])
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(width: NoblePatternSymptomAtlasGeometry.size.width, height: NoblePatternSymptomAtlasBottomHeight)
                .position(x: NoblePatternSymptomAtlasGeometry.size.width / 2, y: NoblePatternSymptomAtlasPlotHeight + NoblePatternSymptomAtlasBottomHeight / 2)

                if !NoblePatternSymptomAtlasHasLogs {
                    Text("Your trends will appear here")
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.76))
                        .cornerRadius(16)
                        .position(x: NoblePatternSymptomAtlasLabelWidth + NoblePatternSymptomAtlasPlotWidth / 2, y: NoblePatternSymptomAtlasPlotHeight * 0.48)
                }
            }
        }
    }
}

struct NoblePatternSymptomAtlasDottedLine: View {
    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasGeometry in
            Path { NoblePatternSymptomAtlasPath in
                NoblePatternSymptomAtlasPath.move(to: CGPoint(x: 0, y: 0.5))
                NoblePatternSymptomAtlasPath.addLine(to: CGPoint(x: NoblePatternSymptomAtlasGeometry.size.width, y: 0.5))
            }
            .stroke(
                NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasLine.opacity(0.8),
                style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [2, 6])
            )
        }
    }
}

struct NoblePatternSymptomAtlasLogSymptomButton: View {
    var NoblePatternSymptomAtlasTitle = "Log Symptom"
    var NoblePatternSymptomAtlasAction: () -> Void = {
        NotificationCenter.default.post(name: .NoblePatternSymptomAtlasShowLogTab, object: nil)
    }

    var body: some View {
        Button {
            NoblePatternSymptomAtlasAction()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle")
                    .font(.subheadline.weight(.semibold))
                Text(NoblePatternSymptomAtlasTitle)
                    .font(.subheadline.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                LinearGradient(
                    colors: [
                        NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal,
                        NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .shadow(color: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal.opacity(0.18), radius: 12, x: 0, y: 7)
        }
        .buttonStyle(.plain)
    }
}

struct NoblePatternSymptomAtlasQuickLogView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @StateObject private var NoblePatternSymptomAtlasForm = NoblePatternSymptomAtlasLogFormViewModel()
    @Binding var NoblePatternSymptomAtlasIsPresented: Bool
    @Binding var NoblePatternSymptomAtlasDidSave: Bool

    private let NoblePatternSymptomAtlasColumns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        ZStack {
            NoblePatternSymptomAtlasBackgroundView(NoblePatternSymptomAtlasOverlayOpacity: 0.58)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 14) {
                    NoblePatternSymptomAtlasQuickLogHeader

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Symptoms")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                        LazyVGrid(columns: NoblePatternSymptomAtlasColumns, spacing: 8) {
                            ForEach(NoblePatternSymptomAtlasQuickSymptoms) { NoblePatternSymptomAtlasSymptom in
                                NoblePatternSymptomAtlasQuickSymptomButton(NoblePatternSymptomAtlasSymptom)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Severity")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text("\(Int(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSeverity))")
                                .font(.headline.weight(.bold))
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal)
                                .frame(width: 30)
                        }
                        Slider(value: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSeverity, in: 0...10, step: 1)
                    }
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mood")
                            .font(.subheadline.weight(.semibold))
                        Picker("Mood", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMood) {
                            ForEach(NoblePatternSymptomAtlasMood.allCases) { NoblePatternSymptomAtlasMood in
                                Text(NoblePatternSymptomAtlasMood.NoblePatternSymptomAtlasEmoji).tag(NoblePatternSymptomAtlasMood)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    HStack(spacing: 10) {
                        NoblePatternSymptomAtlasQuickValueStepper(
                            NoblePatternSymptomAtlasTitle: "Sleep",
                            NoblePatternSymptomAtlasValue: "\(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours)h",
                            NoblePatternSymptomAtlasMinusAction: {
                                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours = max(0, NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours - 1)
                            },
                            NoblePatternSymptomAtlasPlusAction: {
                                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours = min(12, NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours + 1)
                            }
                        )

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stress")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                            Picker("Stress", selection: $NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasStress) {
                                ForEach(NoblePatternSymptomAtlasStressLevel.allCases) {
                                    Text($0.rawValue).tag($0)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, minHeight: 86)
                        .background(Color.white.opacity(0.78))
                        .cornerRadius(16)
                    }

                    Button {
                        NoblePatternSymptomAtlasSaveQuickLog()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Quick Log")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                colors: NoblePatternSymptomAtlasQuickCanSave ? [
                                    NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal,
                                    NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage
                                ] : [
                                    Color.gray.opacity(0.34),
                                    Color.gray.opacity(0.26)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(17)
                    }
                    .buttonStyle(.plain)
                    .disabled(!NoblePatternSymptomAtlasQuickCanSave)

                    Button {
                        NoblePatternSymptomAtlasIsPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            NotificationCenter.default.post(name: .NoblePatternSymptomAtlasShowLogTab, object: nil)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Detailed Log")
                                .font(.subheadline.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                        .background(Color.white.opacity(0.76))
                        .cornerRadius(15)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)
                .padding(.bottom, 26)
            }
        }
        .background(Color.clear)
    }

    private var NoblePatternSymptomAtlasQuickLogHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quick Log")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                Text("Capture how you feel right now.")
                    .font(.subheadline)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
            }

            Spacer()

            Button {
                NoblePatternSymptomAtlasIsPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.caption.weight(.bold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                    .frame(width: 36, height: 36)
                    .background(Color.white.opacity(0.82))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var NoblePatternSymptomAtlasQuickSymptoms: [NoblePatternSymptomAtlasSymptom] {
        let NoblePatternSymptomAtlasCounts = Dictionary(grouping: NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasLogs.flatMap(\.NoblePatternSymptomAtlasSymptoms)) { $0 }
            .mapValues(\.count)

        return NoblePatternSymptomAtlasSymptom.allCases.sorted {
            let NoblePatternSymptomAtlasLeftCount = NoblePatternSymptomAtlasCounts[$0, default: 0]
            let NoblePatternSymptomAtlasRightCount = NoblePatternSymptomAtlasCounts[$1, default: 0]
            if NoblePatternSymptomAtlasLeftCount == NoblePatternSymptomAtlasRightCount {
                return $0.rawValue < $1.rawValue
            }
            return NoblePatternSymptomAtlasLeftCount > NoblePatternSymptomAtlasRightCount
        }
    }

    private var NoblePatternSymptomAtlasQuickCanSave: Bool {
        !NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.isEmpty ||
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSeverity != 5 ||
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMood != .neutral ||
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSleepHours != 7 ||
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasStress != .medium
    }

    private func NoblePatternSymptomAtlasQuickSymptomButton(_ NoblePatternSymptomAtlasSymptom: NoblePatternSymptomAtlasSymptom) -> some View {
        let NoblePatternSymptomAtlasIsSelected = NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.contains(NoblePatternSymptomAtlasSymptom)

        return Button {
            if NoblePatternSymptomAtlasIsSelected {
                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.remove(NoblePatternSymptomAtlasSymptom)
            } else {
                NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasSelectedSymptoms.insert(NoblePatternSymptomAtlasSymptom)
            }
        } label: {
            VStack(spacing: 5) {
                Text(NoblePatternSymptomAtlasSymptom.NoblePatternSymptomAtlasEmoji)
                    .font(.title3)
                Text(NoblePatternSymptomAtlasSymptom.rawValue)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.78)
            }
            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
            .frame(maxWidth: .infinity, minHeight: 60)
            .padding(.vertical, 4)
            .background(NoblePatternSymptomAtlasIsSelected ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.24) : Color.white.opacity(0.72))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(NoblePatternSymptomAtlasIsSelected ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.75) : Color.white.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
    }

    private func NoblePatternSymptomAtlasSaveQuickLog() {
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasDate = Date()
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasActivity = .rest
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMeals = ""
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMedicationName = ""
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMedicationDose = ""
        NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasNotes = ""
        NoblePatternSymptomAtlasViewModel.NoblePatternSymptomAtlasAddLog(NoblePatternSymptomAtlasForm.NoblePatternSymptomAtlasMakeLog())
        NoblePatternSymptomAtlasDidSave = true
        NoblePatternSymptomAtlasIsPresented = false
    }
}

struct NoblePatternSymptomAtlasQuickValueStepper: View {
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasValue: String
    let NoblePatternSymptomAtlasMinusAction: () -> Void
    let NoblePatternSymptomAtlasPlusAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NoblePatternSymptomAtlasTitle)
                .font(.caption.weight(.semibold))
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)

            HStack(spacing: 10) {
                Button(action: NoblePatternSymptomAtlasMinusAction) {
                    Image(systemName: "minus")
                        .font(.caption.weight(.bold))
                        .frame(width: 28, height: 28)
                        .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Text(NoblePatternSymptomAtlasValue)
                    .font(.headline.weight(.bold))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    .frame(maxWidth: .infinity)

                Button(action: NoblePatternSymptomAtlasPlusAction) {
                    Image(systemName: "plus")
                        .font(.caption.weight(.bold))
                        .frame(width: 28, height: 28)
                        .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 86)
        .background(Color.white.opacity(0.78))
        .cornerRadius(16)
    }
}

struct NoblePatternSymptomAtlasLogView: View {
    @EnvironmentObject private var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @StateObject private var NoblePatternSymptomAtlasForm = NoblePatternSymptomAtlasLogFormViewModel()
    @State private var NoblePatternSymptomAtlasSaved = false

    var body: some View {
        NoblePatternSymptomAtlasScreen("Detailed Log") {
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

        VStack(alignment: .leading, spacing: 10) {
            Text("Insight Feed")
                .font(.headline)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

            Text("Based only on logs saved on this device.")
                .font(.caption)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)

            ForEach(NoblePatternSymptomAtlasSummary.NoblePatternSymptomAtlasInsights) { NoblePatternSymptomAtlasInsight in
                NoblePatternSymptomAtlasInsightCard(NoblePatternSymptomAtlasInsight: NoblePatternSymptomAtlasInsight)
            }
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

struct NoblePatternSymptomAtlasInsightCard: View {
    let NoblePatternSymptomAtlasInsight: NoblePatternSymptomAtlasPatternInsight
    @State private var NoblePatternSymptomAtlasShowExplanation = false

    var body: some View {
        Button {
            if NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasExplanation != nil {
                withAnimation(.easeInOut(duration: 0.2)) {
                    NoblePatternSymptomAtlasShowExplanation.toggle()
                }
            }
        } label: {
            NoblePatternSymptomAtlasCard {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: NoblePatternSymptomAtlasIcon)
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(NoblePatternSymptomAtlasTint)
                            .frame(width: 34, height: 34)
                            .background(NoblePatternSymptomAtlasTint.opacity(0.13))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text(NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasTitle)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)

                                Spacer(minLength: 6)

                                Text(NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasCategory)
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(NoblePatternSymptomAtlasTint)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(NoblePatternSymptomAtlasTint.opacity(0.12))
                                    .cornerRadius(9)
                            }

                            Text(NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasText)
                                .font(.caption)
                                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    HStack {
                        Text("\(NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasDataCount) local data points")
                            .font(.caption2)
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)

                        Spacer()

                        if NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasExplanation != nil {
                            HStack(spacing: 4) {
                                Text("Why this appears")
                                Image(systemName: NoblePatternSymptomAtlasShowExplanation ? "chevron.up" : "chevron.down")
                            }
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                        }
                    }

                    if NoblePatternSymptomAtlasShowExplanation, let NoblePatternSymptomAtlasExplanation = NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasExplanation {
                        Text(NoblePatternSymptomAtlasExplanation)
                            .font(.caption)
                            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground.opacity(0.75))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var NoblePatternSymptomAtlasIcon: String {
        switch NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasCategory {
        case "Sleep": return "moon.zzz.fill"
        case "Stress": return "bolt.heart"
        case "Medication": return "pills.fill"
        case "Activity": return "figure.walk"
        case "Mood": return "face.smiling"
        case "Calendar", "Week": return "calendar"
        case "Severity": return "waveform.path.ecg"
        default: return "point.3.connected.trianglepath.dotted"
        }
    }

    private var NoblePatternSymptomAtlasTint: Color {
        switch NoblePatternSymptomAtlasInsight.NoblePatternSymptomAtlasCategory {
        case "Sleep": return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue
        case "Medication", "Activity": return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasOrange
        case "Mood", "Severity": return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal
        default: return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage
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
                        NoblePatternSymptomAtlasSettingsSectionTitle("App")
                        NoblePatternSymptomAtlasSettingsCard {
                            VStack(spacing: 0) {
                                NoblePatternSymptomAtlasSettingsButtonRow(title: "Privacy Policy", systemImage: "lock.shield", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage) {
                                    NoblePatternSymptomAtlasShowPrivacy = true
                                }

                                NoblePatternSymptomAtlasSettingsDivider()

                                NoblePatternSymptomAtlasSettingsButtonRow(title: "Share App", systemImage: "square.and.arrow.up", tint: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage) {
                                    NoblePatternSymptomAtlasShowShare = true
                                }
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
