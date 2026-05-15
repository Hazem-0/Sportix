//
//  SportixTests.swift
//  SportixTests
//
//  Created by Hazem Abdelraouf on 05/05/2026.
//


import XCTest
@testable import Sportix

class SportixTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }


    func testFetchLeagues_Success() {
        let ex = expectation(description: "fetchLeagues")
        Task {
            do {
                let leagues = try await networkManager.fetchLeagues(sport: .Football)
                XCTAssertFalse(leagues.isEmpty)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50)
    }

    func testFetchTeams_Success() {
        let ex = expectation(description: "fetchTeams")
        Task {
            do {
                let teams = try await networkManager.fetchTeams(sport: .Football, leagueId: 152)
                XCTAssertFalse(teams.isEmpty)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50)
    }

    func testFetchTeamDetails_Success() {
        let ex = expectation(description: "fetchTeamDetails")
        Task {
            do {
                let team = try await networkManager.fetchTeamDetails(sport: .Football, teamId: 2611)
                XCTAssertEqual(team.team_key, 2611)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50)
    }

    func testFetchUpcomingFixtures_Success() {
        let ex = expectation(description: "fetchUpcomingFixtures")
        Task {
            do {
                let fixtures = try await networkManager.fetchUpcomingFixtures(sport: "football", leagueId: 152)
                XCTAssertNotNil(fixtures)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50)
    }

    func testFetchPastFixtures_Success() {
        let ex = expectation(description: "fetchPastFixtures")
        Task {
            do {
                let fixtures = try await networkManager.fetchPastFixtures(sport: "football", leagueId: 152)
                XCTAssertNotNil(fixtures)
            } catch {
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50)
    }

    func testFetchTeamDetails_Failure_InvalidID() {
        let ex = expectation(description: "fetchTeamDetails failure")
        Task {
            do {
                _ = try await networkManager.fetchTeamDetails(sport: .Football, teamId: -9999)
                XCTFail()
            } catch {
                XCTAssertNotNil(error)
            }
            ex.fulfill()
        }
        waitForExpectations(timeout: 50
        )
    }
}
