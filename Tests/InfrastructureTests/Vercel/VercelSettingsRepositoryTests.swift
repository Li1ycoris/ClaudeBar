import Testing
import Foundation
@testable import Infrastructure
@testable import Domain

@Suite
struct VercelSettingsRepositoryTests {
    @Test
    func `user defaults repository persists and removes Vercel settings`() {
        let suiteName = "VercelSettingsRepositoryTests.\(UUID().uuidString)"
        let secureSuiteName = "VercelSecureCredentialsTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        let secureDefaults = UserDefaults(suiteName: secureSuiteName)!
        let secureCredentials = UserDefaultsCredentialRepository(defaults: secureDefaults)
        defer {
            defaults.removePersistentDomain(forName: suiteName)
            secureDefaults.removePersistentDomain(forName: secureSuiteName)
        }
        let repository = UserDefaultsProviderSettingsRepository(
            userDefaults: defaults,
            secureCredentials: secureCredentials
        )

        #expect(repository.vercelAuthEnvVar().isEmpty)
        #expect(repository.hasVercelApiKey() == false)

        repository.setVercelAuthEnvVar("CUSTOM_VERCEL_KEY")
        repository.saveVercelApiKey("vck_test")

        #expect(repository.vercelAuthEnvVar() == "CUSTOM_VERCEL_KEY")
        #expect(repository.getVercelApiKey() == "vck_test")
        #expect(repository.hasVercelApiKey() == true)
        #expect(secureCredentials.get(forKey: CredentialKey.vercelApiKey) == "vck_test")
        #expect(defaults.object(forKey: "com.claudebar.credentials.vercel-api-key") == nil)

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
        let secureSuiteName = "VercelJSONSecureCredentialsTests.\(UUID().uuidString)"
        let credentials = UserDefaults(suiteName: suiteName)!
        let secureDefaults = UserDefaults(suiteName: secureSuiteName)!
        let secureCredentials = UserDefaultsCredentialRepository(defaults: secureDefaults)
        defer {
            try? FileManager.default.removeItem(at: tempDirectory)
            credentials.removePersistentDomain(forName: suiteName)
            secureDefaults.removePersistentDomain(forName: secureSuiteName)
        }
        let repository = JSONSettingsRepository(
            store: JSONSettingsStore(fileURL: settingsURL),
            credentials: credentials,
            secureCredentials: secureCredentials
        )

        #expect(repository.vercelAuthEnvVar().isEmpty)
        #expect(repository.hasVercelApiKey() == false)

        repository.setVercelAuthEnvVar("CUSTOM_VERCEL_KEY")
        repository.saveVercelApiKey("vck_test")

        #expect(repository.vercelAuthEnvVar() == "CUSTOM_VERCEL_KEY")
        #expect(repository.getVercelApiKey() == "vck_test")
        #expect(repository.hasVercelApiKey() == true)
        #expect(secureCredentials.get(forKey: CredentialKey.vercelApiKey) == "vck_test")
        #expect(credentials.object(forKey: "com.claudebar.credentials.vercel-api-key") == nil)

        repository.deleteVercelApiKey()
        #expect(repository.getVercelApiKey() == nil)
        #expect(repository.hasVercelApiKey() == false)
    }

    @Test
    func `user defaults repository migrates legacy Vercel API key`() {
        let suiteName = "VercelLegacySettingsTests.\(UUID().uuidString)"
        let secureSuiteName = "VercelLegacySecureTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        let secureDefaults = UserDefaults(suiteName: secureSuiteName)!
        let secureCredentials = UserDefaultsCredentialRepository(defaults: secureDefaults)
        defer {
            defaults.removePersistentDomain(forName: suiteName)
            secureDefaults.removePersistentDomain(forName: secureSuiteName)
        }
        defaults.set("legacy-key", forKey: "com.claudebar.credentials.vercel-api-key")
        let repository = UserDefaultsProviderSettingsRepository(
            userDefaults: defaults,
            secureCredentials: secureCredentials
        )

        #expect(repository.getVercelApiKey() == "legacy-key")
        #expect(secureCredentials.get(forKey: CredentialKey.vercelApiKey) == "legacy-key")
        #expect(defaults.object(forKey: "com.claudebar.credentials.vercel-api-key") == nil)
    }

    @Test
    func `JSON repository migrates legacy Vercel API key`() {
        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("VercelLegacyJSONTests.\(UUID().uuidString)")
        let suiteName = "VercelLegacyJSONCredentialsTests.\(UUID().uuidString)"
        let secureSuiteName = "VercelLegacyJSONSecureTests.\(UUID().uuidString)"
        let credentials = UserDefaults(suiteName: suiteName)!
        let secureDefaults = UserDefaults(suiteName: secureSuiteName)!
        let secureCredentials = UserDefaultsCredentialRepository(defaults: secureDefaults)
        defer {
            try? FileManager.default.removeItem(at: tempDirectory)
            credentials.removePersistentDomain(forName: suiteName)
            secureDefaults.removePersistentDomain(forName: secureSuiteName)
        }
        credentials.set("legacy-key", forKey: "com.claudebar.credentials.vercel-api-key")
        let repository = JSONSettingsRepository(
            store: JSONSettingsStore(fileURL: tempDirectory.appendingPathComponent("settings.json")),
            credentials: credentials,
            secureCredentials: secureCredentials
        )

        #expect(repository.getVercelApiKey() == "legacy-key")
        #expect(secureCredentials.get(forKey: CredentialKey.vercelApiKey) == "legacy-key")
        #expect(credentials.object(forKey: "com.claudebar.credentials.vercel-api-key") == nil)
    }
}
