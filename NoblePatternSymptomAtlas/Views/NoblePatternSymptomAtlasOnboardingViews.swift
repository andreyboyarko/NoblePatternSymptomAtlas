import SwiftUI

struct NoblePatternSymptomAtlasAppGateView: View {
    @ObservedObject var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel
    @AppStorage("NoblePatternSymptomAtlas.hasCompletedOnboarding") private var NoblePatternSymptomAtlasHasCompletedOnboarding = false
    @State private var NoblePatternSymptomAtlasIsLoading = true

    var body: some View {
        ZStack {
            NoblePatternSymptomAtlasBackgroundView(NoblePatternSymptomAtlasOverlayOpacity: 0.45)

            if NoblePatternSymptomAtlasIsLoading {
                NoblePatternSymptomAtlasLoadingView()
                    .transition(.opacity)
            } else if NoblePatternSymptomAtlasHasCompletedOnboarding {
                NoblePatternSymptomAtlasRootView(NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            } else {
                NoblePatternSymptomAtlasOnboardingView(
                    NoblePatternSymptomAtlasHasCompletedOnboarding: $NoblePatternSymptomAtlasHasCompletedOnboarding
                )
                .transition(.opacity)
            }
        }
        .background(Color.clear)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                withAnimation(.easeInOut(duration: 0.28)) {
                    NoblePatternSymptomAtlasIsLoading = false
                }
            }
        }
    }
}

struct NoblePatternSymptomAtlasLoadingView: View {
    @State private var NoblePatternSymptomAtlasAnimateMark = false
    @State private var NoblePatternSymptomAtlasRevealProgress: CGFloat = 0
    @State private var NoblePatternSymptomAtlasShowNodes = false
    @State private var NoblePatternSymptomAtlasShowTitle = false
    @State private var NoblePatternSymptomAtlasLoadingRingRotation: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 22) {
                NoblePatternSymptomAtlasPatternRevealMark(
                    NoblePatternSymptomAtlasProgress: NoblePatternSymptomAtlasRevealProgress,
                    NoblePatternSymptomAtlasShowNodes: NoblePatternSymptomAtlasShowNodes
                )
                .frame(width: 138, height: 138)
                .scaleEffect(NoblePatternSymptomAtlasAnimateMark ? 1.02 : 0.98)
                .opacity(NoblePatternSymptomAtlasShowTitle ? 1.0 : 0.9)

                VStack(spacing: 6) {
                    Text("Noble Pattern")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    Text("Symptom Atlas")
                        .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasHeadlineFont)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                }
                .opacity(NoblePatternSymptomAtlasShowTitle ? 1 : 0)
                .offset(y: NoblePatternSymptomAtlasShowTitle ? 0 : 8)
            }
            .padding(.horizontal, 28)

            Spacer()

            NoblePatternSymptomAtlasLoadingStatusView(NoblePatternSymptomAtlasRotation: NoblePatternSymptomAtlasLoadingRingRotation)
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
        }
        .onAppear {
            NoblePatternSymptomAtlasRunLoadingAnimation()
        }
    }

    private func NoblePatternSymptomAtlasRunLoadingAnimation() {
        withAnimation(.easeOut(duration: 0.35)) {
            NoblePatternSymptomAtlasShowNodes = true
        }
        withAnimation(.easeInOut(duration: 1.45).delay(0.35)) {
            NoblePatternSymptomAtlasRevealProgress = 1
        }
        withAnimation(.easeOut(duration: 0.45).delay(1.55)) {
            NoblePatternSymptomAtlasShowTitle = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.95) {
            withAnimation(.easeInOut(duration: 0.72).repeatForever(autoreverses: true)) {
                NoblePatternSymptomAtlasAnimateMark = true
            }
        }
        withAnimation(.linear(duration: 0.9).repeatForever(autoreverses: false)) {
            NoblePatternSymptomAtlasLoadingRingRotation = 360
        }
    }
}

struct NoblePatternSymptomAtlasLoadingStatusView: View {
    let NoblePatternSymptomAtlasRotation: Double

    var body: some View {
        HStack(spacing: 10) {
            Text("Loading")
                .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSubheadlineSemiboldFont)
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)

            Circle()
                .trim(from: 0.12, to: 0.86)
                .stroke(
                    NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage,
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(NoblePatternSymptomAtlasRotation))
        }
        .frame(maxWidth: .infinity, minHeight: 58)
        .background(Color.white.opacity(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSoftGlassOpacity))
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.46), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 14, x: 0, y: 8)
    }
}

struct NoblePatternSymptomAtlasPatternRevealMark: View {
    let NoblePatternSymptomAtlasProgress: CGFloat
    let NoblePatternSymptomAtlasShowNodes: Bool

    var body: some View {
        GeometryReader { NoblePatternSymptomAtlasGeometry in
            let NoblePatternSymptomAtlasSize = min(NoblePatternSymptomAtlasGeometry.size.width, NoblePatternSymptomAtlasGeometry.size.height)
            let NoblePatternSymptomAtlasNodes = NoblePatternSymptomAtlasNodePositions(size: NoblePatternSymptomAtlasSize)

            ZStack {
                Circle()
                    .fill(Color.white.opacity(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasStrongGlassOpacity))
                    .shadow(color: Color.black.opacity(0.07), radius: 18, x: 0, y: 10)

                Circle()
                    .stroke(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage.opacity(0.2), lineWidth: 12)
                    .padding(10)

                NoblePatternSymptomAtlasRevealLines(NoblePatternSymptomAtlasNodes: NoblePatternSymptomAtlasNodes)
                    .trim(from: 0, to: NoblePatternSymptomAtlasProgress)
                    .stroke(
                        NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                    )

                ForEach(NoblePatternSymptomAtlasNodes.indices, id: \.self) { NoblePatternSymptomAtlasIndex in
                    Circle()
                        .fill(NoblePatternSymptomAtlasIndex == 0 ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal : NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBlue.opacity(0.78))
                        .frame(
                            width: NoblePatternSymptomAtlasIndex == 0 ? NoblePatternSymptomAtlasSize * 0.20 : NoblePatternSymptomAtlasSize * 0.12,
                            height: NoblePatternSymptomAtlasIndex == 0 ? NoblePatternSymptomAtlasSize * 0.20 : NoblePatternSymptomAtlasSize * 0.12
                        )
                        .position(NoblePatternSymptomAtlasNodes[NoblePatternSymptomAtlasIndex])
                        .scaleEffect(NoblePatternSymptomAtlasShowNodes ? 1 : 0.15)
                        .opacity(NoblePatternSymptomAtlasShowNodes ? 1 : 0)
                        .animation(.spring(response: 0.38, dampingFraction: 0.72).delay(Double(NoblePatternSymptomAtlasIndex) * 0.08), value: NoblePatternSymptomAtlasShowNodes)
                }
            }
            .frame(width: NoblePatternSymptomAtlasSize, height: NoblePatternSymptomAtlasSize)
        }
    }

    private func NoblePatternSymptomAtlasNodePositions(size NoblePatternSymptomAtlasSize: CGFloat) -> [CGPoint] {
        [
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.50, y: NoblePatternSymptomAtlasSize * 0.50),
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.50, y: NoblePatternSymptomAtlasSize * 0.20),
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.22, y: NoblePatternSymptomAtlasSize * 0.36),
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.78, y: NoblePatternSymptomAtlasSize * 0.36),
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.34, y: NoblePatternSymptomAtlasSize * 0.76),
            CGPoint(x: NoblePatternSymptomAtlasSize * 0.66, y: NoblePatternSymptomAtlasSize * 0.76)
        ]
    }
}

struct NoblePatternSymptomAtlasRevealLines: Shape {
    let NoblePatternSymptomAtlasNodes: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var NoblePatternSymptomAtlasPath = Path()
        guard NoblePatternSymptomAtlasNodes.count >= 6 else { return NoblePatternSymptomAtlasPath }

        NoblePatternSymptomAtlasPath.move(to: NoblePatternSymptomAtlasNodes[0])
        NoblePatternSymptomAtlasPath.addLine(to: NoblePatternSymptomAtlasNodes[1])
        NoblePatternSymptomAtlasPath.move(to: NoblePatternSymptomAtlasNodes[0])
        NoblePatternSymptomAtlasPath.addLine(to: NoblePatternSymptomAtlasNodes[2])
        NoblePatternSymptomAtlasPath.move(to: NoblePatternSymptomAtlasNodes[0])
        NoblePatternSymptomAtlasPath.addLine(to: NoblePatternSymptomAtlasNodes[3])
        NoblePatternSymptomAtlasPath.move(to: NoblePatternSymptomAtlasNodes[0])
        NoblePatternSymptomAtlasPath.addLine(to: NoblePatternSymptomAtlasNodes[4])
        NoblePatternSymptomAtlasPath.move(to: NoblePatternSymptomAtlasNodes[0])
        NoblePatternSymptomAtlasPath.addLine(to: NoblePatternSymptomAtlasNodes[5])

        return NoblePatternSymptomAtlasPath
    }
}

struct NoblePatternSymptomAtlasOnboardingView: View {
    @Binding var NoblePatternSymptomAtlasHasCompletedOnboarding: Bool
    @State private var NoblePatternSymptomAtlasPage = 0

    private let NoblePatternSymptomAtlasPages: [NoblePatternSymptomAtlasOnboardingPage] = [
        NoblePatternSymptomAtlasOnboardingPage(
            NoblePatternSymptomAtlasSystemImage: "square.and.pencil",
            NoblePatternSymptomAtlasTitle: "Log how you feel",
            NoblePatternSymptomAtlasText: "Track symptoms, mood, sleep, stress, medication, and notes in a private local diary."
        ),
        NoblePatternSymptomAtlasOnboardingPage(
            NoblePatternSymptomAtlasSystemImage: "chart.bar.xaxis",
            NoblePatternSymptomAtlasTitle: "Notice possible patterns",
            NoblePatternSymptomAtlasText: "Patterns are simple local statistics from your saved logs, not medical diagnoses."
        ),
        NoblePatternSymptomAtlasOnboardingPage(
            NoblePatternSymptomAtlasSystemImage: "lock.shield",
            NoblePatternSymptomAtlasTitle: "Private by design",
            NoblePatternSymptomAtlasText: "Everything stays on this device. No accounts, cloud sync, or diagnosis logic."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                NoblePatternSymptomAtlasBrandMark(NoblePatternSymptomAtlasSize: 44)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Noble Pattern")
                        .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasHeadlineFont)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    Text("Offline symptom tracking")
                        .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasCaptionFont)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)

            TabView(selection: $NoblePatternSymptomAtlasPage) {
                ForEach(Array(NoblePatternSymptomAtlasPages.enumerated()), id: \.offset) { NoblePatternSymptomAtlasIndex, NoblePatternSymptomAtlasPageContent in
                    NoblePatternSymptomAtlasOnboardingPageView(NoblePatternSymptomAtlasPage: NoblePatternSymptomAtlasPageContent)
                        .tag(NoblePatternSymptomAtlasIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(NoblePatternSymptomAtlasPages.indices, id: \.self) { NoblePatternSymptomAtlasIndex in
                    Capsule()
                        .fill(NoblePatternSymptomAtlasIndex == NoblePatternSymptomAtlasPage ? NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage : NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasLine)
                        .frame(width: NoblePatternSymptomAtlasIndex == NoblePatternSymptomAtlasPage ? 24 : 8, height: 8)
                }
            }
            .padding(.bottom, 18)

            VStack(spacing: 10) {
                Button {
                    if NoblePatternSymptomAtlasPage == NoblePatternSymptomAtlasPages.count - 1 {
                        NoblePatternSymptomAtlasComplete()
                    } else {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            NoblePatternSymptomAtlasPage += 1
                        }
                    }
                } label: {
                    Text(NoblePatternSymptomAtlasPage == NoblePatternSymptomAtlasPages.count - 1 ? "Start Tracking" : "Continue")
                        .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasHeadlineFont)
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
                        .shadow(color: NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasTeal.opacity(0.16), radius: 12, x: 0, y: 7)
                }
                .buttonStyle(.plain)

                Button {
                    NoblePatternSymptomAtlasComplete()
                } label: {
                    Text("Skip")
                        .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSubheadlineSemiboldFont)
                        .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                        .frame(maxWidth: .infinity, minHeight: 42)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }

    private func NoblePatternSymptomAtlasComplete() {
        withAnimation(.easeInOut(duration: 0.25)) {
            NoblePatternSymptomAtlasHasCompletedOnboarding = true
        }
    }
}

struct NoblePatternSymptomAtlasOnboardingPage: Equatable {
    let NoblePatternSymptomAtlasSystemImage: String
    let NoblePatternSymptomAtlasTitle: String
    let NoblePatternSymptomAtlasText: String
}

struct NoblePatternSymptomAtlasOnboardingPageView: View {
    let NoblePatternSymptomAtlasPage: NoblePatternSymptomAtlasOnboardingPage

    var body: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 20)

            Image(systemName: NoblePatternSymptomAtlasPage.NoblePatternSymptomAtlasSystemImage)
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasSage)
                .frame(width: 108, height: 108)
                .background(Color.white.opacity(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasStrongGlassOpacity))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 9)

            VStack(spacing: 10) {
                Text(NoblePatternSymptomAtlasPage.NoblePatternSymptomAtlasTitle)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(NoblePatternSymptomAtlasPage.NoblePatternSymptomAtlasText)
                    .font(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasBodyFont)
                    .foregroundColor(NoblePatternSymptomAtlasDesignSystem.NoblePatternSymptomAtlasMuted)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 26)

            Spacer(minLength: 20)
        }
    }
}
