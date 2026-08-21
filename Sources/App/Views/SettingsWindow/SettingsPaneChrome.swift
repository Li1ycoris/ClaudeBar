import SwiftUI

/// Shared layout primitives for Settings window panes: pane scaffold,
/// glass cards, and title/description rows — all themed via AppThemeProvider.

/// Scrollable pane scaffold with a large title and subtitle.
struct SettingsPane<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: Content

    @Environment(\.appTheme) private var theme

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 21, weight: .bold, design: theme.fontDesign))
                        .foregroundStyle(theme.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium, design: theme.fontDesign))
                        .foregroundStyle(theme.textSecondary)
                }
                .padding(.bottom, 8)

                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.top, 18)
            .padding(.bottom, 32)
        }
    }
}

/// Glass card container matching the app's card language.
struct SettingsCard<Content: View>: View {
    @ViewBuilder let content: Content

    @Environment(\.appTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                .fill(theme.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cardCornerRadius)
                        .stroke(theme.glassBorder, lineWidth: 1)
                )
        )
    }
}

/// A settings row: title + optional description on the left, a trailing
/// control on the right. Stack multiple rows inside a SettingsCard with
/// SettingsRowDivider between them.
struct SettingsRow<Trailing: View>: View {
    let title: String
    var subtitle: String? = nil
    @ViewBuilder let trailing: Trailing

    @Environment(\.appTheme) private var theme

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: theme.fontDesign))
                    .foregroundStyle(theme.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .medium, design: theme.fontDesign))
                        .foregroundStyle(theme.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 12)

            trailing
        }
    }
}

/// Divider between rows inside a SettingsCard.
struct SettingsRowDivider: View {
    @Environment(\.appTheme) private var theme

    var body: some View {
        Divider()
            .background(theme.glassBorder.opacity(0.5))
            .padding(.vertical, 12)
    }
}

/// Standard switch toggle used across the Settings window.
struct SettingsSwitch: View {
    @Binding var isOn: Bool

    @Environment(\.appTheme) private var theme

    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(.switch)
            .tint(theme.accentPrimary)
            .scaleEffect(0.8)
            .labelsHidden()
    }
}

/// Small uppercase field label (e.g. "PROVIDER", "QUOTA").
struct SettingsFieldLabel: View {
    let text: String

    @Environment(\.appTheme) private var theme

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .semibold, design: theme.fontDesign))
            .foregroundStyle(theme.textSecondary)
            .tracking(0.5)
    }
}
