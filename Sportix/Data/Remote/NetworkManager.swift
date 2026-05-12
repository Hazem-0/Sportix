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
        let baseURL = API.baseURL.hasSuffix("/") ? API.baseURL : API.baseURL + "/"
        let cleanPath = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        let finalURL = baseURL + cleanPath
        
        print("🌐 Requesting URL: \(finalURL) | Params: \(endpoint.parameters)")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(finalURL, parameters: endpoint.parameters)
                .validate()
                .responseDecodable(of: T.self) { response in
                    
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("RAW JSON for \(endpoint.path): \n\(jsonString.prefix(1000))...")
                    }

                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        print("Network Error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }


    func fetchSports() async throws -> [SportResponse] {
        return []
    }

    func fetchLeagues(sport: Sport) async throws -> [LeagueResponse] {
        let endpoint = LeaguesEndpoint(sport: sport)
        
        let response = try await request(
            endpoint: endpoint,
            model: SportixResponse<[LeagueResponse]>.self
        )
        
        guard response.success == 1 else {
            throw NetworkError.serverError(response.error ?? "Failed to fetch leagues.")
        }
        
        guard let leagues = response.result else {
            throw NetworkError.emptyData
        }
        
        return leagues
    }

    func fetchUpcomingFixtures(sport: String, leagueId: Int) async throws -> [FixtureResponse] {
        let res = try await request(
            endpoint: FixturesEndpoint(sport: sport.lowercased(), leagueId: leagueId, upcoming: true),
            model: SportixResponse<[FixtureResponse]>.self
        )
        return res.result ?? []
    }
    
    func fetchPastFixtures(sport: String, leagueId: Int) async throws -> [FixtureResponse] {
        let res = try await request(
            endpoint: FixturesEndpoint(sport: sport.lowercased(), leagueId: leagueId, upcoming: false),
            model: SportixResponse<[FixtureResponse]>.self
        )
        return res.result ?? []
    }

    func fetchTeams(sport: Sport, leagueId: Int) async throws -> [TeamResponse] {
        let response = try await request(
            endpoint: TeamsEndpoint(
                sport: sport,
                query: .league(id: leagueId)
            ),
            model: SportixResponse<[TeamResponse]>.self
        )
        
        guard response.success == 1 else {
            throw NetworkError.serverError(response.error ?? "Failed to fetch teams.")
        }
        
        return response.result ?? []
    }

    func fetchTeamDetails(sport: Sport, teamId: Int) async throws -> TeamResponse {
        let response = try await request(
            endpoint: TeamsEndpoint(
                sport: sport,
                query: .team(id: teamId)
            ),
            model: SportixResponse<[TeamResponse]>.self
        )
        
        guard response.success == 1 else {
            throw NetworkError.serverError(response.error ?? "Failed to fetch team details.")
        }
        
        guard let team = response.result?.first else {
            throw NetworkError.emptyData
        }
        
        return team
    }
}
