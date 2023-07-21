//
//  CoreDataModels.swift
//  ISS_Journey
//
//  Created by michaell medina on 09/07/23.
//


import Foundation
//esta estructira es por que la estructura ISSentity de coredata no se puede apegar al protocolo decodable y managed all mismo tiempo 
// MARK: - ISSLocalized
struct ISSLocalized: Codable {
    let message: String
    let issPosition: IssPosition
    let timestamp: Int

    enum CodingKeys: String, CodingKey {
        case message
        case issPosition = "iss_position"
        case timestamp
    }
}

// MARK: - IssPosition
struct IssPosition: Codable {
    let latitude, longitude: String
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
