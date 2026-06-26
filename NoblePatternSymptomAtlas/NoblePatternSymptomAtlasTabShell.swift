import SwiftUI
import UIKit

final class NoblePatternSymptomAtlasAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let NoblePatternSymptomAtlasNavigationAppearance = UINavigationBarAppearance()
        NoblePatternSymptomAtlasNavigationAppearance.configureWithTransparentBackground()
        NoblePatternSymptomAtlasNavigationAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 1)]
        NoblePatternSymptomAtlasNavigationAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 1)]

        let NoblePatternSymptomAtlasTabBarAppearance = UITabBarAppearance()
        NoblePatternSymptomAtlasTabBarAppearance.configureWithTransparentBackground()

        UITabBar.appearance().tintColor = UIColor(red: 0.36, green: 0.55, blue: 0.48, alpha: 1)
        UITabBar.appearance().standardAppearance = NoblePatternSymptomAtlasTabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = NoblePatternSymptomAtlasTabBarAppearance
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().standardAppearance = NoblePatternSymptomAtlasNavigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = NoblePatternSymptomAtlasNavigationAppearance
        UINavigationBar.appearance().compactAppearance = NoblePatternSymptomAtlasNavigationAppearance
        return true
    }
}

struct NoblePatternSymptomAtlasRootView: UIViewControllerRepresentable {
    @ObservedObject var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel

    func makeUIViewController(context: Context) -> UITabBarController {
        let NoblePatternSymptomAtlasTabBarController = UITabBarController()
        NoblePatternSymptomAtlasTabBarController.view.backgroundColor = .clear
        NoblePatternSymptomAtlasTabBarController.view.isOpaque = false
        NoblePatternSymptomAtlasTabBarController.tabBar.isTranslucent = true
        NoblePatternSymptomAtlasTabBarController.viewControllers = [
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasDashboardView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Dashboard", systemImage: "house"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasLogView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Log", systemImage: "plus.circle"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasTimelineView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Timeline", systemImage: "calendar"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasPatternsView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Patterns", systemImage: "chart.xyaxis.line"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasReportsView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Reports", systemImage: "square.and.arrow.up")
        ]
        return NoblePatternSymptomAtlasTabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}

private func NoblePatternSymptomAtlasHostingController<Content: View>(rootView NoblePatternSymptomAtlasRootView: Content, title NoblePatternSymptomAtlasTitle: String, systemImage NoblePatternSymptomAtlasSystemImage: String) -> UIViewController {
    let NoblePatternSymptomAtlasController = UIHostingController(rootView: NoblePatternSymptomAtlasRootView)
    NoblePatternSymptomAtlasController.view.backgroundColor = .clear
    NoblePatternSymptomAtlasController.view.isOpaque = false
    NoblePatternSymptomAtlasController.tabBarItem = UITabBarItem(title: NoblePatternSymptomAtlasTitle, image: UIImage(systemName: NoblePatternSymptomAtlasSystemImage), selectedImage: UIImage(systemName: NoblePatternSymptomAtlasSystemImage + ".fill"))
    return NoblePatternSymptomAtlasController
}
