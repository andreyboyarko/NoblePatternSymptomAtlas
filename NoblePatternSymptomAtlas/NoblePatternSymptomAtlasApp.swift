
import SwiftUI

@main
struct NoblePatternSymptomAtlasApp: App {
    @UIApplicationDelegateAdaptor(NoblePatternSymptomAtlasAppDelegate.self) private var NoblePatternSymptomAtlasAppDelegateInstance
    @StateObject private var NoblePatternSymptomAtlasViewModelInstance = NoblePatternSymptomAtlasViewModel()

    var body: some Scene {
        WindowGroup {
            NoblePatternSymptomAtlasAppGateView(NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModelInstance)
            .preferredColorScheme(.light)
        }
    }
}
