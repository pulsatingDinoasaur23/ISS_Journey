//
//  APIClient.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//

import Foundation

protocol APIClientProtocol{
    func fetchISSLocation(completion: @escaping (Result<ISSLocalized, Error>) -> Void)
}

class APIClient: APIClientProtocol {

    
    func fetchISSLocation(completion: @escaping (Result<ISSLocalized, Error>) -> Void) {
        let urlString = "http://api.open-notify.org/iss-now.json?callback=?"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    do {
                        let jsonString = String(data: data, encoding: .utf8) ?? ""
                        let cleanedData = jsonString.replacingOccurrences(of: "?(", with: "").replacingOccurrences(of: ")", with: "")
                        let cleanedDataUTF8 = cleanedData.data(using: .utf8)
                        
                        let decoder = JSONDecoder()
                        let issData = try decoder.decode(ISSLocalized.self, from: cleanedDataUTF8!)
                        
                        completion(.success(issData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        } else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}
