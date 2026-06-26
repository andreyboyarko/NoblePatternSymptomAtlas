
import SwiftUI

@main
struct NoblePatternSymptomAtlasApp: App {
    @UIApplicationDelegateAdaptor(NoblePatternSymptomAtlasAppDelegate.self) private var NoblePatternSymptomAtlasAppDelegateInstance
    @StateObject private var NoblePatternSymptomAtlasViewModelInstance = NoblePatternSymptomAtlasViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                NoblePatternSymptomAtlasBackgroundView(NoblePatternSymptomAtlasOverlayOpacity: 0.45)
                NoblePatternSymptomAtlasRootView(NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModelInstance)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .preferredColorScheme(.light)
        }
    }
}
