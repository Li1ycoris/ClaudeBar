import Foundation

/// Navigation model for the standalone Settings window sidebar.
/// Sections are grouped the way the sidebar renders them:
/// App → Monitoring → System.
enum SettingsSection: String, CaseIterable, Identifiable {
    case general
    case appearance
    case menuBar
    case providers
    case syncAlerts
    case hooks
    case updates
    case logs
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: "General"
        case .appearance: "Appearance"
        case .menuBar: "Menu Bar"
        case .providers: "Providers"
        case .syncAlerts: "Sync & Alerts"
        case .hooks: "Hooks"
        case .updates: "Updates"
        case .logs: "Logs"
        case .about: "About"
        }
    }

    var symbolName: String {
        switch self {
        case .general: "gearshape.fill"
        case .appearance: "circle.lefthalf.filled"
        case .menuBar: "menubar.rectangle"
        case .providers: "cpu"
        case .syncAlerts: "arrow.triangle.2.circlepath"
        case .hooks: "antenna.radiowaves.left.and.right"
        case .updates: "arrow.down.circle.fill"
        case .logs: "doc.text.fill"
        case .about: "info.circle.fill"
        }
    }
}

/// Sidebar groups, in display order.
enum SettingsSectionGroup: String, CaseIterable, Identifiable {
    case app
    case monitoring
    case system

    var id: String { rawValue }

    var title: String {
        switch self {
        case .app: "App"
        case .monitoring: "Monitoring"
        case .system: "System"
        }
    }

    var sections: [SettingsSection] {
        switch self {
        case .app: [.general, .appearance, .menuBar]
        case .monitoring: [.providers, .syncAlerts, .hooks]
        case .system: [.updates, .logs, .about]
        }
    }
}
