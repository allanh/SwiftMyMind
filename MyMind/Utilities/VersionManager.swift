//
//  VersionManager.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

enum VersionError : Error {
    case invalidUpdateInfo
    case invalidBundleInfo
    case invalidResponse
    case noNeedUpdateHint
}

class VersionManager {
        
    static let shared: VersionManager = .init()

    func canUpdate(version: String?) -> Bool {
    
        guard let currentVersion = Bundle.main.releaseVersionNumber else {
            return false
        }
        
        let currentVersioComponents = currentVersion.components(separatedBy: ".")
        
        guard let updateVersion = version else {
            return false
        }
        let updateVersionComponents = updateVersion.components(separatedBy: ".")
        
        print("server app version: \(String(describing: updateVersion))")
        print("current app version: \(String(describing: currentVersion))")
        
        for index in 0..<updateVersionComponents.count {
        
            let currentElement = Int(currentVersioComponents[index]) ?? 0
            let updateElement = Int(updateVersionComponents[index]) ?? 0
            
            if updateElement > currentElement {
                return true
            }
            else if updateElement < currentElement {
                return false
            }
            else {
                continue
            }
        }
        return false
    }
    
    // MARK: - 軟性更新通知
    func isUpdateAvailable(completion: @escaping (String?, Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print(currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version, self.canUpdate(version: version), nil)
            } catch {
                completion(nil, nil, error)
            }
        }
        task.resume()
        return task
    }
}
