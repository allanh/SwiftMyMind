//
//  UserDefaultSecretDataStore.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/18.
//

import Foundation

class UserDefaultSecretDataStore: SecretDataStore {

    private let secretsKey: String

    init(with key: String = "Secrets") {
        self.secretsKey = key
    }

    func readSecrets() throws -> [Secret] {
        guard let data = UserDefaults.standard.data(forKey: secretsKey) else {
            print("Secrets data not found.")
            return []
        }
        do {
            let secrets = try JSONDecoder().decode([Secret].self, from: data)
            return secrets
        } catch let error {
            throw error
        }
    }

    func saveSecrets(secrets: [Secret]) throws {
        do {
            let data = try JSONEncoder().encode(secrets)
            UserDefaults.standard.set(data, forKey: secretsKey)
        } catch let error {
            throw error
        }
    }

    func deleteSecrets() {
        UserDefaults.standard.removeObject(forKey: secretsKey)
    }
}
