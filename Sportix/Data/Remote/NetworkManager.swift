//
//  NetworkManager.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Foundation
import Alamofire

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(endpoint: NetworkEndpoint, model: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(API.baseURL + endpoint.path, parameters: endpoint.parameters)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    func fetchSports() async throws -> [SportResponse] {
        []
    }

    func fetchLeagues(sport: String) async throws -> [LeagueResponse] {
        []
    }

    func fetchUpcomingFixtures(sport: String, leagueId: Int) async throws -> [FixtureResponse] {
        []
    }

    func fetchPastFixtures(sport: String, leagueId: Int) async throws -> [FixtureResponse] {
         []
    }

    func fetchTeams(sport: String, leagueId: Int) async throws -> [TeamResponse] {
         []
    }
}
