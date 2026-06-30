import SwiftUI
import SafariServices

enum NoblePatternSymptomAtlasDesignSystem {
    static let NoblePatternSymptomAtlasBackground = Color(red: 0.96, green: 0.97, blue: 0.96)
    static let NoblePatternSymptomAtlasCard = Color.white
    static let NoblePatternSymptomAtlasText = Color(red: 0.16, green: 0.18, blue: 0.20)
    static let NoblePatternSymptomAtlasMuted = Color(red: 0.43, green: 0.47, blue: 0.50)
    static let NoblePatternSymptomAtlasSage = Color(red: 0.50, green: 0.65, blue: 0.58)
    static let NoblePatternSymptomAtlasBlue = Color(red: 0.39, green: 0.55, blue: 0.70)
    static let NoblePatternSymptomAtlasRose = Color(red: 0.78, green: 0.54, blue: 0.55)
    static let NoblePatternSymptomAtlasOrange = Color(red: 0.90, green: 0.58, blue: 0.28)
    static let NoblePatternSymptomAtlasTeal = Color(red: 0.35, green: 0.70, blue: 0.68)
    static let NoblePatternSymptomAtlasLine = Color(red: 0.88, green: 0.90, blue: 0.89)
}

struct NoblePatternSymptomAtlasBackgroundView: View {
    let NoblePatternSymptomAtlasOverlayOpacity: Double

    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasGeometry in
            ZStack {
                Image("NoblePatternSymptomAtlasBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: NoblePatternSymptomAtlasGeometry.size.width,
                        height: NoblePatternSymptomAtlasGeometry.size.height
                    )
                    .clipped()

                LinearGradient(
                    colors: [
                        Color.white.opacity(NoblePatternSymptomAtlasOverlayOpacity),
                        Color.white.opacity(NoblePatternSymptomAtlasOverlayOpacity + 0.12)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(
                width: NoblePatternSymptomAtlasGeometry.size.width,
                height: NoblePatternSymptomAtlasGeometry.size.height
            )
        }
        .ignoresSafeArea()
    }
}

struct NoblePatternSymptomAtlasCard<Content: View>: View {
    let NoblePatternSymptomAtlasContent: Content

    init(@ViewBuilder content NoblePatternSymptomAtlasContent: () -> Content) {
        self.NoblePatternSymptomAtlasContent = NoblePatternSymptomAtlasContent()
    }

    var body: some View {
        NoblePatternSymptomAtlasContent
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasCard.opacity(0.88))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.55), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 14, x: 0, y: 7)
    }
}

struct NoblePatternSymptomAtlasSectionTitle: View {
    let NoblePatternSymptomAtlasTitle: String

    var body: some View {
        Text(NoblePatternSymptomAtlasTitle)
            .font(.headline)
            .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
    }
}

struct NoblePatternSymptomAtlasBrandMark: View {
    var NoblePatternSymptomAtlasSize: CGFloat = 52

    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasProxy in
            let NoblePatternSymptomAtlasSide = min(NoblePatternSymptomAtlasProxy.size.width, NoblePatternSymptomAtlasProxy.size.height)
            ZStack {
                Circle()
                    .fill(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.18))
                NoblePatternSymptomAtlasHeartNetworkShape()
                    .stroke(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage, style: StrokeStyle(lineWidth: 2.4, lineCap: .round, lineJoin: .round))
                    .padding(NoblePatternSymptomAtlasSide * 0.20)
                ForEach(0..<6, id: \.self) { NoblePatternSymptomAtlasIndex in
                    Circle()
                        .fill(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue)
                        .frame(width: NoblePatternSymptomAtlasSide * 0.10, height: NoblePatternSymptomAtlasSide * 0.10)
                        .position(NoblePatternSymptomAtlasNodePosition(index: NoblePatternSymptomAtlasIndex, size: NoblePatternSymptomAtlasSide))
                }
            }
            .frame(width: NoblePatternSymptomAtlasSide, height: NoblePatternSymptomAtlasSide)
        }
        .frame(width: NoblePatternSymptomAtlasSize, height: NoblePatternSymptomAtlasSize)
    }

    private func NoblePatternSymptomAtlasNodePosition(index NoblePatternSymptomAtlasIndex: Int, size NoblePatternSymptomAtlasSize: CGFloat) -> CGPoint {
        let NoblePatternSymptomAtlasPoints = [
            CGSize(width: -0.15, height: -0.20),
            CGSize(width: 0.15, height: -0.20),
            CGSize(width: -0.27, height: 0.03),
            CGSize(width: 0.27, height: 0.03),
            CGSize(width: -0.09, height: 0.23),
            CGSize(width: 0.09, height: 0.23)
        ]
        let NoblePatternSymptomAtlasPoint = NoblePatternSymptomAtlasPoints[NoblePatternSymptomAtlasIndex]
        return CGPoint(
            x: NoblePatternSymptomAtlasSize / 2 + NoblePatternSymptomAtlasPoint.width * NoblePatternSymptomAtlasSize,
            y: NoblePatternSymptomAtlasSize / 2 + NoblePatternSymptomAtlasPoint.height * NoblePatternSymptomAtlasSize
        )
    }
}

struct NoblePatternSymptomAtlasHeartNetworkShape: Shape {
    func path(in NoblePatternSymptomAtlasRect: CGRect) -> Path {
        var NoblePatternSymptomAtlasPath = Path()
        let NoblePatternSymptomAtlasW = NoblePatternSymptomAtlasRect.width
        let NoblePatternSymptomAtlasH = NoblePatternSymptomAtlasRect.height
        let NoblePatternSymptomAtlasOrigin = NoblePatternSymptomAtlasRect.origin
        NoblePatternSymptomAtlasPath.move(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.50, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.84))
        NoblePatternSymptomAtlasPath.addCurve(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.08, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.30), control1: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.25, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.66), control2: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.02, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.54))
        NoblePatternSymptomAtlasPath.addCurve(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.50, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.22), control1: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.10, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.06), control2: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.38, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.06))
        NoblePatternSymptomAtlasPath.addCurve(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.92, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.30), control1: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.62, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.06), control2: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.90, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.06))
        NoblePatternSymptomAtlasPath.addCurve(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.50, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.84), control1: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.98, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.54), control2: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.75, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.66))
        NoblePatternSymptomAtlasPath.move(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.25, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.30))
        NoblePatternSymptomAtlasPath.addLine(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.75, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.30))
        NoblePatternSymptomAtlasPath.addLine(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.60, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.62))
        NoblePatternSymptomAtlasPath.addLine(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.40, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.62))
        NoblePatternSymptomAtlasPath.addLine(to: CGPoint(x: NoblePatternSymptomAtlasOrigin.x + NoblePatternSymptomAtlasW * 0.25, y: NoblePatternSymptomAtlasOrigin.y + NoblePatternSymptomAtlasH * 0.30))
        return NoblePatternSymptomAtlasPath
    }
}

struct NoblePatternSymptomAtlasShareSheet: UIViewControllerRepresentable {
    let NoblePatternSymptomAtlasItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: NoblePatternSymptomAtlasItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct NoblePatternSymptomAtlasSafariView: UIViewControllerRepresentable {
    let NoblePatternSymptomAtlasURL: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: NoblePatternSymptomAtlasURL)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
