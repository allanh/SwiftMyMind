//
//  UDISecretRepository.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/15.
//

import Foundation

protocol SecretDataStore {
    func readSecrets() throws -> [Secret]
    func saveSecrets(secrets: [Secret]) throws
    func deleteSecrets()
}

protocol SecretRepository {
    var secrets: [Secret] { get }
    func readSecrets() throws
    func saveSecrets() throws
    func update(newSecrets:Secret)
    func deleteSecret(at index: Int)
    func deleteSecrets()
    func filterSecrets(newSecret: Secret) -> [Secret]
}

extension SecretRepository {
    func filterSecrets(newSecret: Secret) -> [Secret] {
        var currentSecrets: [Secret] = self.secrets
        let sameUserSecrets: [Secret] = secrets.filter { $0.user == newSecret.user }
        var secretToAdd: Secret = newSecret

        guard
            sameUserSecrets.isEmpty == false,
            let newSecretRegisterDate: Date = newSecret.registerDate
        else {
            secretToAdd.isValid = true
            currentSecrets.append(secretToAdd)
            return currentSecrets
        }

        var finalSecrets: [Secret] = []
        for index in 0..<sameUserSecrets.count {
            var secret: Secret = sameUserSecrets[index]
            let result: ComparisonResult = secret.registerDate?.compare(newSecretRegisterDate) ?? .orderedSame
            switch result {
            case .orderedSame:
                secretToAdd.isValid = secret.isValid
            case .orderedDescending:
                secretToAdd.isValid = true
                secret.isValid = false
            case .orderedAscending:
                secretToAdd.isValid = false
                secret.isValid = true
            }
            finalSecrets.append(secret)
        }
        finalSecrets.append(secretToAdd)
        return finalSecrets
    }
}

class UDISecretRepository: SecretRepository {
    private(set) var secrets: [Secret] = []

    private let dataStore: SecretDataStore

    init(dataStore: SecretDataStore) {
        self.dataStore = dataStore
        try? readSecrets()
    }

    func readSecrets() throws {
        do {
            let secrets = try dataStore.readSecrets()
            self.secrets = secrets
        } catch let error {
            throw error
        }
    }

    func saveSecrets() throws {
        do {
            try dataStore.saveSecrets(secrets: self.secrets)
        } catch let error {
            throw error
        }
    }

    func update(newSecrets:Secret) {
        let secrets = filterSecrets(newSecret: newSecrets)
        self.secrets = secrets
    }

    func deleteSecret(at index: Int) {
        secrets.remove(at: index)
    }

    func deleteSecrets() {
        dataStore.deleteSecrets()
        do {
            try readSecrets()
        } catch {
            
        }
    }
    
    func secret(for user: String, storeID: String) -> Secret? {
        return secrets.last {
            $0.user == user && $0.id == storeID
        }
    }

}
