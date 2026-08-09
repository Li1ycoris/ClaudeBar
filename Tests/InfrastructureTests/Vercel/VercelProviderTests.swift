import Testing
import Foundation
import Mockable
@testable import Infrastructure
@testable import Domain

@Suite
@MainActor
struct VercelProviderTests {
    private func makeSettingsRepository() -> UserDefaultsProviderSettingsRepository {
        let defaults = UserDefaults(suiteName: "VercelProviderTests.\(UUID().uuidString)")!
        return UserDefaultsProviderSettingsRepository(userDefaults: defaults)
    }

    @Test
    func `provider has correct identity and defaults to disabled`() {
        let provider = VercelProvider(
            probe: MockUsageProbe(),
            settingsRepository: makeSettingsRepository()
        )

        #expect(provider.id == "vercel-gateway")
        #expect(provider.name == "Vercel Gateway")
        #expect(provider.cliCommand.isEmpty)
        #expect(provider.dashboardURL != nil)
        #expect(provider.isEnabled == false)
        #expect(provider.snapshot == nil)
        #expect(provider.lastError == nil)
        #expect(provider.isSyncing == false)
    }

    @Test
    func `provider reflects and persists enabled state`() {
        let repository = makeSettingsRepository()
        repository.setEnabled(true, forProvider: "vercel-gateway")
        let provider = VercelProvider(probe: MockUsageProbe(), settingsRepository: repository)

        #expect(provider.isEnabled == true)

        provider.isEnabled = false
        #expect(repository.isEnabled(forProvider: "vercel-gateway") == false)
    }

    @Test
    func `isAvailable delegates to probe`() async {
        let probe = MockUsageProbe()
        given(probe).isAvailable().willReturn(true)
        let provider = VercelProvider(probe: probe, settingsRepository: makeSettingsRepository())

        #expect(await provider.isAvailable() == true)
    }

    @Test
    func `refresh stores snapshot on success`() async throws {
        let probe = MockUsageProbe()
        let snapshot = UsageSnapshot(
            providerId: "vercel-gateway",
            quotas: [UsageQuota(
                percentRemaining: 100,
                quotaType: .timeLimit("AI Gateway Credits"),
                providerId: "vercel-gateway",
                dollarRemaining: Decimal(string: "10.50")
            )],
            capturedAt: Date()
        )
        given(probe).probe().willReturn(snapshot)
        let provider = VercelProvider(probe: probe, settingsRepository: makeSettingsRepository())

        let result = try await provider.refresh()

        #expect(result.quotas.first?.dollarRemaining == Decimal(string: "10.50"))
        #expect(provider.snapshot != nil)
        #expect(provider.lastError == nil)
        #expect(provider.isSyncing == false)
    }

    @Test
    func `refresh stores error on failure`() async {
        let probe = MockUsageProbe()
        given(probe).probe().willThrow(ProbeError.authenticationRequired)
        let provider = VercelProvider(probe: probe, settingsRepository: makeSettingsRepository())

        await #expect(throws: ProbeError.authenticationRequired) {
            try await provider.refresh()
        }

        #expect(provider.lastError != nil)
        #expect(provider.snapshot == nil)
        #expect(provider.isSyncing == false)
    }
}
