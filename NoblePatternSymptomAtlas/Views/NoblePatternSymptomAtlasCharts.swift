import SwiftUI

struct NoblePatternSymptomAtlasLineChart: View {
    let NoblePatternSymptomAtlasValues: [(Date, Double)]

    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasProxy in
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground)
                if NoblePatternSymptomAtlasValues.count < 2 {
                    Text("More logs needed")
                        .font(.caption)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    NoblePatternSymptomAtlasLine(values: NoblePatternSymptomAtlasValues.map(\.1))
                        .stroke(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .padding(12)
                    NoblePatternSymptomAtlasLine(values: NoblePatternSymptomAtlasValues.map(\.1))
                        .fill(LinearGradient(colors: [NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue.opacity(0.18), .clear], startPoint: .top, endPoint: .bottom))
                        .padding(12)
                }
            }
            .frame(width: NoblePatternSymptomAtlasProxy.size.width, height: NoblePatternSymptomAtlasProxy.size.height)
        }
        .frame(height: 150)
    }
}

struct NoblePatternSymptomAtlasLine: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        guard values.count > 1 else { return Path() }
        let maxValue = max(values.max() ?? 10, 10)
        let minValue = min(values.min() ?? 0, 0)
        let range = max(1, maxValue - minValue)
        var path = Path()
        for index in values.indices {
            let x = rect.minX + CGFloat(index) / CGFloat(values.count - 1) * rect.width
            let normalized = (values[index] - minValue) / range
            let y = rect.maxY - CGFloat(normalized) * rect.height
            if index == values.startIndex {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

struct NoblePatternSymptomAtlasBarChart: View {
    let NoblePatternSymptomAtlasValues: [(String, Int)]

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(NoblePatternSymptomAtlasValues, id: \.0) { NoblePatternSymptomAtlasLabel, NoblePatternSymptomAtlasValue in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                        .frame(height: NoblePatternSymptomAtlasHeight(for: NoblePatternSymptomAtlasValue))
                    Text(NoblePatternSymptomAtlasLabel.prefix(3))
                        .font(.caption2)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 150)
        .padding(.top, 8)
    }

    private func NoblePatternSymptomAtlasHeight(for NoblePatternSymptomAtlasValue: Int) -> CGFloat {
        let NoblePatternSymptomAtlasMax = max(NoblePatternSymptomAtlasValues.map(\.1).max() ?? 1, 1)
        return max(10, CGFloat(NoblePatternSymptomAtlasValue) / CGFloat(NoblePatternSymptomAtlasMax) * 110)
    }
}

struct NoblePatternSymptomAtlasHeatmap: View {
    let NoblePatternSymptomAtlasValues: [(Date, Int)]
    private let NoblePatternSymptomAtlasColumns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        LazyVGrid(columns: NoblePatternSymptomAtlasColumns, spacing: 6) {
            ForEach(NoblePatternSymptomAtlasLastDays(), id: \.self) { NoblePatternSymptomAtlasDay in
                RoundedRectangle(cornerRadius: 4)
                    .fill(NoblePatternSymptomAtlasColor(for: NoblePatternSymptomAtlasDay))
                    .frame(height: 24)
                    .accessibilityLabel(Text("\(NoblePatternSymptomAtlasCount(for: NoblePatternSymptomAtlasDay)) symptoms"))
            }
        }
    }

    private func NoblePatternSymptomAtlasLastDays() -> [Date] {
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        let NoblePatternSymptomAtlasToday = NoblePatternSymptomAtlasCalendar.startOfDay(for: Date())
        return (0..<35).compactMap { NoblePatternSymptomAtlasCalendar.date(byAdding: .day, value: -34 + $0, to: NoblePatternSymptomAtlasToday) }
    }

    private func NoblePatternSymptomAtlasCount(for NoblePatternSymptomAtlasDay: Date) -> Int {
        let NoblePatternSymptomAtlasCalendar = Calendar.current
        return NoblePatternSymptomAtlasValues.first { NoblePatternSymptomAtlasCalendar.isDate($0.0, inSameDayAs: NoblePatternSymptomAtlasDay) }?.1 ?? 0
    }

    private func NoblePatternSymptomAtlasColor(for NoblePatternSymptomAtlasDay: Date) -> Color {
        let NoblePatternSymptomAtlasCount = NoblePatternSymptomAtlasCount(for: NoblePatternSymptomAtlasDay)
        switch NoblePatternSymptomAtlasCount {
        case 0: return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBackground
        case 1: return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.35)
        case 2...3: return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.65)
        default: return NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage
        }
    }
}
