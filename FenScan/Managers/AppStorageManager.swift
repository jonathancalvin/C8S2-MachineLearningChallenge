//
//  AppStorageManager.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 13/06/25.
//

/* Example:
 class NetworkManager {
     func fetchData(from url: String, completion: @escaping (Data?) -> Void) {
         guard let url = URL(string: url) else { return }
         let task = URLSession.shared.dataTask(with: url) { data, _, _ in
             completion(data)
         }
         task.resume()
     }
 }

 */

import Foundation

final class AppStorageManager {
    static let shared = AppStorageManager()
    private init() {}
}
