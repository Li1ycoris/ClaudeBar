import SwiftUI
import Domain
import Infrastructure

/// Root view of the standalone Settings window: a full-height sidebar plus
/// the selected pane, over the theme's background — seamless chrome (the
/// window's title bar is hidden; traffic lights overlay the sidebar top).
struct SettingsWindowView: View {
    let monitor: QuotaMonitor
    var onHookSettingsChanged: ((Bool) -> Void)?

    @Environment(\.appTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @State private var selection: SettingsSection = .general

    var body: some View {
        ZStack {
            theme.backgroundGradient
                .ignoresSafeArea()

            if theme.showBackgroundOrbs {
                backgroundOrbs
                    .ignoresSafeArea()
            }

            theme.overlayView

            HStack(spacing: 0) {
                SettingsSidebarView(monitor: monitor, selection: $selection)
                    .ignoresSafeArea(.container, edges: .top)

                activePane
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(minWidth: 760, minHeight: 520)
        // The hooks toggle posts this from HooksPane; the app's start/stop
        // closure must run even while the menu bar popover is closed.
        .onReceive(NotificationCenter.default.publisher(for: .hookSettingsChanged)) { notification in
            let enabled = notification.userInfo?["enabled"] as? Bool ?? false
            onHookSettingsChanged?(enabled)
        }
    }

    @ViewBuilder
    private var activePane: some View {
        switch selection {
        case .general:
            GeneralPane()
        case .appearance:
            AppearancePane()
        case .menuBar:
            MenuBarPane(monitor: monitor)
        case .providers:
            ProvidersPane(monitor: monitor)
        case .syncAlerts:
            SyncAlertsPane()
        case .hooks:
            HooksPane()
        case .updates:
            UpdatesPane()
        case .logs:
            LogsPane()
        case .about:
            AboutPane()
        }
    }

    /// Soft ambient orbs matching the popover's background treatment.
    private var backgroundOrbs: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.accentSecondary.opacity(colorScheme == .dark ? 0.35 : 0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 220
                        )
                    )
                    .frame(width: 440, height: 440)
                    .offset(x: -120, y: -140)
                    .blur(radius: 60)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.accentPrimary.opacity(colorScheme == .dark ? 0.28 : 0.10),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 400, height: 400)
                    .offset(x: geo.size.width - 200, y: geo.size.height - 240)
                    .blur(radius: 60)
            }
        }
    }
}
