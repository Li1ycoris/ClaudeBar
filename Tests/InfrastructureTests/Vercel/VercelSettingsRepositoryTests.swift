import Testing
import Foundation
@testable import Infrastructure

@Suite
struct VercelSettingsRepositoryTests {
    @Test
    func `user defaults repository persists and removes Vercel settings`() {
        let suiteName = "VercelSettingsRepositoryTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let repository = UserDefaultsProviderSettingsRepository(userDefaults: defaults)

        #expect(repository.vercelAuthEnvVar().isEmpty)
        #expect(repository.hasVercelApiKey() == false)

        repository.setVercelAuthEnvVar("CUSTOM_VERCEL_KEY")
        repository.saveVercelApiKey("vck_test")

        #expect(repository.vercelAuthEnvVar() == "CUSTOM_VERCEL_KEY")
        #expect(repository.getVercelApiKey() == "vck_test")
        #expect(repository.hasVercelApiKey() == true)

        repository.deleteVercelApiKey()
        #expect(repository.getVercelApiKey() == nil)
        #expect(repository.hasVercelApiKey() == false)
    }

    @Test
    func `JSON repository persists and removes Vercel settings`() {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("VercelJSONSettingsTests.\(UUID().uuidString)")
        let settingsURL = tempDirectory.appendingPathComponent("settings.json")
        let suiteName = "VercelJSONCredentialsTests.\(UUID().uuidString)"
        let credentials = UserDefaults(suiteName: suiteName)!
        defer {
            try? FileManager.default.removeItem(at: tempDirectory)
            credentials.removePersistentDomain(forName: suiteName)
        }
        let repository = JSONSettingsRepository(
            store: JSONSettingsStore(fileURL: settingsURL),
            credentials: credentials
        )

        #expect(repository.vercelAuthEnvVar().isEmpty)
        #expect(repository.hasVercelApiKey() == false)

        repository.setVercelAuthEnvVar("CUSTOM_VERCEL_KEY")
        repository.saveVercelApiKey("vck_test")

        #expect(repository.vercelAuthEnvVar() == "CUSTOM_VERCEL_KEY")
        #expect(repository.getVercelApiKey() == "vck_test")
        #expect(repository.hasVercelApiKey() == true)

        repository.deleteVercelApiKey()
        #expect(repository.getVercelApiKey() == nil)
        #expect(repository.hasVercelApiKey() == false)
    }
}
