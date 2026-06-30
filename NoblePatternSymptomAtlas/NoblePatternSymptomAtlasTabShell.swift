import SwiftUI
import UIKit

extension Notification.Name {
    static let NoblePatternSymptomAtlasShowLogTab = Notification.Name("NoblePatternSymptomAtlasShowLogTab")
    static let NoblePatternSymptomAtlasShowTimelineTab = Notification.Name("NoblePatternSymptomAtlasShowTimelineTab")
    static let NoblePatternSymptomAtlasShowPatternsTab = Notification.Name("NoblePatternSymptomAtlasShowPatternsTab")
}

final class NoblePatternSymptomAtlasAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let NoblePatternSymptomAtlasNavigationAppearance = UINavigationBarAppearance()
        NoblePatternSymptomAtlasNavigationAppearance.configureWithTransparentBackground()
        NoblePatternSymptomAtlasNavigationAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 1)]
        NoblePatternSymptomAtlasNavigationAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 1)]

        let NoblePatternSymptomAtlasTabBarAppearance = UITabBarAppearance()
        NoblePatternSymptomAtlasTabBarAppearance.configureWithTransparentBackground()
        let NoblePatternSymptomAtlasTabFont = NoblePatternSymptomAtlasRoundedFont(size: 11, weight: .semibold)
        NoblePatternSymptomAtlasTabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: NoblePatternSymptomAtlasTabFont,
            .foregroundColor: UIColor(red: 0.16, green: 0.18, blue: 0.20, alpha: 0.82)
        ]
        NoblePatternSymptomAtlasTabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: NoblePatternSymptomAtlasTabFont,
            .foregroundColor: UIColor(red: 0.36, green: 0.55, blue: 0.48, alpha: 1)
        ]

        UITabBar.appearance().tintColor = UIColor(red: 0.36, green: 0.55, blue: 0.48, alpha: 1)
        UITabBar.appearance().standardAppearance = NoblePatternSymptomAtlasTabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = NoblePatternSymptomAtlasTabBarAppearance
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().standardAppearance = NoblePatternSymptomAtlasNavigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = NoblePatternSymptomAtlasNavigationAppearance
        UINavigationBar.appearance().compactAppearance = NoblePatternSymptomAtlasNavigationAppearance
        return true
    }

    private func NoblePatternSymptomAtlasRoundedFont(size NoblePatternSymptomAtlasSize: CGFloat, weight NoblePatternSymptomAtlasWeight: UIFont.Weight) -> UIFont {
        let NoblePatternSymptomAtlasFont = UIFont.systemFont(ofSize: NoblePatternSymptomAtlasSize, weight: NoblePatternSymptomAtlasWeight)
        guard let NoblePatternSymptomAtlasDescriptor = NoblePatternSymptomAtlasFont.fontDescriptor.withDesign(.rounded) else {
            return NoblePatternSymptomAtlasFont
        }
        return UIFont(descriptor: NoblePatternSymptomAtlasDescriptor, size: NoblePatternSymptomAtlasSize)
    }
}

struct NoblePatternSymptomAtlasRootView: UIViewControllerRepresentable {
    @ObservedObject var NoblePatternSymptomAtlasViewModel: NoblePatternSymptomAtlasViewModel

    func makeCoordinator() -> NoblePatternSymptomAtlasTabCoordinator {
        NoblePatternSymptomAtlasTabCoordinator()
    }

    func makeUIViewController(context: Context) -> UITabBarController {
        let NoblePatternSymptomAtlasTabBarController = UITabBarController()
        NoblePatternSymptomAtlasTabBarController.view.backgroundColor = .clear
        NoblePatternSymptomAtlasTabBarController.view.isOpaque = false
        NoblePatternSymptomAtlasTabBarController.tabBar.isTranslucent = true
        NoblePatternSymptomAtlasTabBarController.viewControllers = [
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasDashboardView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Dashboard", systemImage: "house"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasLogView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Log", systemImage: "plus.circle"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasTimelineView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Timeline", systemImage: "calendar"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasPatternsView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Patterns", systemImage: "point.3.connected.trianglepath.dotted"),
            NoblePatternSymptomAtlasHostingController(rootView: NoblePatternSymptomAtlasReportsView().environmentObject(NoblePatternSymptomAtlasViewModel), title: "Reports", systemImage: "square.and.arrow.up")
        ]
        context.coordinator.NoblePatternSymptomAtlasTabBarController = NoblePatternSymptomAtlasTabBarController
        return NoblePatternSymptomAtlasTabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}

final class NoblePatternSymptomAtlasTabCoordinator: NSObject {
    weak var NoblePatternSymptomAtlasTabBarController: UITabBarController?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NoblePatternSymptomAtlasSelectLogTab),
            name: .NoblePatternSymptomAtlasShowLogTab,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NoblePatternSymptomAtlasSelectTimelineTab),
            name: .NoblePatternSymptomAtlasShowTimelineTab,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NoblePatternSymptomAtlasSelectPatternsTab),
            name: .NoblePatternSymptomAtlasShowPatternsTab,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func NoblePatternSymptomAtlasSelectLogTab() {
        NoblePatternSymptomAtlasTabBarController?.selectedIndex = 1
    }

    @objc private func NoblePatternSymptomAtlasSelectTimelineTab() {
        NoblePatternSymptomAtlasTabBarController?.selectedIndex = 2
    }

    @objc private func NoblePatternSymptomAtlasSelectPatternsTab() {
        NoblePatternSymptomAtlasTabBarController?.selectedIndex = 3
    }
}

private func NoblePatternSymptomAtlasHostingController<Content: View>(rootView NoblePatternSymptomAtlasRootView: Content, title NoblePatternSymptomAtlasTitle: String, systemImage NoblePatternSymptomAtlasSystemImage: String) -> UIViewController {
    let NoblePatternSymptomAtlasController = UIHostingController(rootView: NoblePatternSymptomAtlasRootView)
    NoblePatternSymptomAtlasController.view.backgroundColor = .clear
    NoblePatternSymptomAtlasController.view.isOpaque = false
    NoblePatternSymptomAtlasController.tabBarItem = UITabBarItem(
        title: NoblePatternSymptomAtlasTitle,
        image: UIImage(systemName: NoblePatternSymptomAtlasSystemImage),
        selectedImage: UIImage(systemName: NoblePatternSymptomAtlasSystemImage)
    )
    return NoblePatternSymptomAtlasController
}
