import Foundation
import Domain

/// Bridges a legacy UserDefaults credential to its secure credential-store replacement.
///
/// Reads prefer secure storage. When only a legacy value exists, it is copied to
/// secure storage and removed from UserDefaults only after persistence succeeds.
struct SecureCredentialMigration {
    let secureStore: any CredentialRepository
    let legacyStore: UserDefaults
    let secureKey: String
    let legacyKey: String

    /// Saves a credential securely and removes its legacy copy after verification.
    func save(_ value: String) {
        secureStore.save(value, forKey: secureKey)
        if secureStore.exists(forKey: secureKey) {
            legacyStore.removeObject(forKey: legacyKey)
        }
    }

    /// Reads the secure value or migrates and returns the legacy value.
    func get() -> String? {
        if let value = secureStore.get(forKey: secureKey) {
            return value
        }

        guard let legacyValue = legacyStore.string(forKey: legacyKey) else {
            return nil
        }

        save(legacyValue)
        return legacyValue
    }

    /// Deletes both secure and legacy copies of the credential.
    func delete() {
        secureStore.delete(forKey: secureKey)
        legacyStore.removeObject(forKey: legacyKey)
    }

    /// Returns whether a secure or legacy credential is available.
    func exists() -> Bool {
        get() != nil
    }
}
