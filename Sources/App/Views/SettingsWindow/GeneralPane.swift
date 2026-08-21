import SwiftUI
import Domain
import Infrastructure

/// General pane: startup behavior, popover overview, and burn-rate warnings.
struct GeneralPane: View {
    @Environment(\.appTheme) private var theme
    @State private var settings = AppSettings.shared

    var body: some View {
        SettingsPane(
            title: "General",
            subtitle: "Startup behavior and core app preferences."
        ) {
            SettingsCard {
                SettingsRow(
                    title: "Launch at Login",
                    subtitle: "Start ClaudeBar automatically when you sign in to your Mac."
                ) {
                    SettingsSwitch(isOn: $settings.launchAtLogin)
                }

                SettingsRowDivider()

                SettingsRow(
                    title: "Overview Mode",
                    subtitle: "Show all providers at once in the menu bar popover."
                ) {
                    SettingsSwitch(isOn: Binding(
                        get: { settings.overviewModeEnabled },
                        set: { newValue in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                settings.overviewModeEnabled = newValue
                            }
                        }
                    ))
                }

                SettingsRowDivider()

                SettingsRow(
                    title: "Daily Usage Cards",
                    subtitle: "Show per-day usage summaries in the popover."
                ) {
                    SettingsSwitch(isOn: $settings.showDailyUsageCards)
                }
            }

            SettingsCard {
                SettingsRow(
                    title: "Burn Rate Warnings",
                    subtitle: "Warn based on consumption pace, not fixed thresholds."
                ) {
                    SettingsSwitch(isOn: $settings.burnRateWarningEnabled)
                }

                if settings.burnRateWarningEnabled {
                    SettingsRowDivider()

                    SettingsRow(
                        title: "Threshold",
                        subtitle: "How far above the sustainable pace triggers a warning."
                    ) {
                        Picker("", selection: $settings.burnRateThreshold) {
                            Text("1.2x (Sensitive)").tag(1.2)
                            Text("1.5x (Default)").tag(1.5)
                            Text("2.0x (Relaxed)").tag(2.0)
                            Text("3.0x (Very relaxed)").tag(3.0)
                        }
                        .pickerStyle(.menu)
                        .tint(theme.accentPrimary)
                        .fixedSize()
                    }
                }
            }
        }
    }
}
