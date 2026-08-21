import SwiftUI
import Domain
import Infrastructure

/// Sync & Alerts pane: background refresh cadence.
struct SyncAlertsPane: View {
    @Environment(\.appTheme) private var theme
    @State private var settings = AppSettings.shared

    var body: some View {
        SettingsPane(
            title: "Sync & Alerts",
            subtitle: "Background refresh cadence for quota data."
        ) {
            SettingsCard {
                SettingsRow(
                    title: "Background Sync",
                    subtitle: "Keep the menu-bar number fresh in the background. \"Off\" updates only when you open the menu. Never refreshes faster than once a minute."
                ) {
                    Text(settings.refreshInterval.label)
                        .font(.system(size: 11, weight: .semibold, design: theme.fontDesign))
                        .foregroundStyle(theme.textSecondary)
                }

                SettingsRowDivider()

                VStack(alignment: .leading, spacing: 6) {
                    SettingsFieldLabel(text: "REFRESH INTERVAL")

                    Picker("", selection: $settings.refreshInterval) {
                        ForEach(RefreshInterval.allCases, id: \.self) { interval in
                            Text(interval.label).tag(interval)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
            }
        }
    }
}
