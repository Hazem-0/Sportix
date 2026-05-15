//
//  MockNetworkService.swift
//  SportixTests
//
//  Created by Aalaa Adel on 15/05/2026.
//

import XCTest
@testable import Sportix

protocol NetworkService {
    func getLeagues(
        sport: Sport,
        completion: @escaping (Result<[LeagueResponse], Error>) -> Void
    )
    
    func getUpcomingFixtures(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[FixtureResponse], Error>) -> Void
    )
    
    func getPastFixtures(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[FixtureResponse], Error>) -> Void
    )
    
    func getTeams(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[TeamResponse], Error>) -> Void
    )
    
    func getTeamDetails(
        sport: Sport,
        teamId: Int,
        completion: @escaping (Result<TeamResponse, Error>) -> Void
    )
    
    func getRoster(
        sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[PlayerResponse], Error>) -> Void
    )
}

final class MockNetworkService: NetworkService {
    
    let shouldReturnWithError: Bool
    
    init(shouldReturnWithError: Bool) {
        self.shouldReturnWithError = shouldReturnWithError
    }
    
    func getLeagues(
        sport: Sport,
        completion: @escaping (Result<[LeagueResponse], Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Leagues Failure"]
            )
            
            completion(.failure(error))
        } else {
            let leagues = [
                LeagueResponse(
                    league_key: 152,
                    league_name: "Premier League",
                    country_name: "England",
                    league_logo: "https://example.com/premier-league.png"
                ),
                LeagueResponse(
                    league_key: 302,
                    league_name: "La Liga",
                    country_name: "Spain",
                    league_logo: nil
                )
            ]
            
            completion(.success(leagues))
        }
    }
    
    func getUpcomingFixtures(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[FixtureResponse], Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Upcoming Fixtures Failure"]
            )
            
            completion(.failure(error))
        } else {
            completion(.success([]))
        }
    }
    
    func getPastFixtures(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[FixtureResponse], Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Past Fixtures Failure"]
            )
            
            completion(.failure(error))
        } else {
            completion(.success([]))
        }
    }
    
    func getTeams(
        sport: Sport,
        leagueId: Int,
        completion: @escaping (Result<[TeamResponse], Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Teams Failure"]
            )
            
            completion(.failure(error))
        } else {
            let teams = [
                TeamResponse(
                    team_key: 96,
                    team_name: "Juventus FC",
                    team_logo: "https://example.com/juventus.png",
                    team_country: "Italy",
                    team_founded: "1897",
                    players: nil
                )
            ]
            
            completion(.success(teams))
        }
    }
    
    func getTeamDetails(
        sport: Sport,
        teamId: Int,
        completion: @escaping (Result<TeamResponse, Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Team Details Failure"]
            )
            
            completion(.failure(error))
        } else {
            let players = [
                PlayerResponse(
                    player_key: 700014087,
                    player_image: "https://example.com/player.png",
                    player_name: "Michele Di Gregorio",
                    player_number: "16",
                    player_type: "Goalkeepers",
                    player_injured: "No"
                )
            ]
            
            let team = TeamResponse(
                team_key: teamId,
                team_name: "Juventus FC",
                team_logo: "https://example.com/juventus.png",
                team_country: "Italy",
                team_founded: "1897",
                players: players
            )
            
            completion(.success(team))
        }
    }
    
    func getRoster(
        sport: Sport,
        teamId: Int,
        completion: @escaping (Result<[PlayerResponse], Error>) -> Void
    ) {
        if shouldReturnWithError {
            let error = NSError(
                domain: "MockError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Mock Roster Failure"]
            )
            
            completion(.failure(error))
        } else {
            let mockRoster = [
                PlayerResponse(
                    player_key: 700014087,
                    player_image: "https://example.com/player.png",
                    player_name: "Michele Di Gregorio",
                    player_number: "16",
                    player_type: "Goalkeepers",
                    player_injured: "No"
                )
            ]
            
            completion(.success(mockRoster))
        }
    }
}
