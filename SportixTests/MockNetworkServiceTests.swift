//
//  MockNetworkServiceTests.swift
//  SportixTests
//
//  Created by Aalaa Adel on 15/05/2026.
//



import XCTest
@testable import Sportix

final class MockNetworkServiceTests: XCTestCase {
    
    var mockSuccessObj: MockNetworkService!
    var mockFailureObj: MockNetworkService!
    
    override func setUpWithError() throws {
        mockSuccessObj = MockNetworkService(shouldReturnWithError: false)
        mockFailureObj = MockNetworkService(shouldReturnWithError: true)
    }
    
    override func tearDownWithError() throws {
        mockSuccessObj = nil
        mockFailureObj = nil
    }
    
    
    func testMockGetLeagues_Success() {
        let ex = expectation(description: "Mock Leagues Success")
        
        mockSuccessObj.getLeagues(sport: .Football) { result in
            switch result {
            case .success(let leagues):
                XCTAssertNotNil(leagues)
                XCTAssertEqual(leagues.count, 2)
                XCTAssertEqual(leagues.first?.league_name, "Premier League")
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockGetLeagues_Failure() {
        let ex = expectation(description: "Mock Leagues Failure")
        
        mockFailureObj.getLeagues(sport: .Football) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
                XCTAssertEqual((error as NSError).code, 404)
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    
    func testMockGetUpcomingFixtures_Success() {
        let ex = expectation(description: "Mock Upcoming Fixtures Success")
        
        mockSuccessObj.getUpcomingFixtures(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
                XCTAssertEqual(fixtures.count, 0)
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockGetUpcomingFixtures_Failure() {
        let ex = expectation(description: "Mock Upcoming Fixtures Failure")
        
        mockFailureObj.getUpcomingFixtures(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    
    func testMockGetPastFixtures_Success() {
        let ex = expectation(description: "Mock Past Fixtures Success")
        
        mockSuccessObj.getPastFixtures(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success(let fixtures):
                XCTAssertNotNil(fixtures)
                XCTAssertEqual(fixtures.count, 0)
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockGetPastFixtures_Failure() {
        let ex = expectation(description: "Mock Past Fixtures Failure")
        
        mockFailureObj.getPastFixtures(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    
    func testMockGetTeams_Success() {
        let ex = expectation(description: "Mock Teams Success")
        
        mockSuccessObj.getTeams(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success(let teams):
                XCTAssertNotNil(teams)
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.team_key, 96)
                XCTAssertEqual(teams.first?.team_name, "Juventus FC")
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockGetTeams_Failure() {
        let ex = expectation(description: "Mock Teams Failure")
        
        mockFailureObj.getTeams(
            sport: .Football,
            leagueId: 152
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    
    func testMockGetTeamDetails_Success() {
        let ex = expectation(description: "Mock Team Details Success")
        
        mockSuccessObj.getTeamDetails(
            sport: .Football,
            teamId: 96
        ) { result in
            switch result {
            case .success(let team):
                XCTAssertNotNil(team)
                XCTAssertEqual(team.team_key, 96)
                XCTAssertEqual(team.team_name, "Juventus FC")
                XCTAssertEqual(team.players?.count, 1)
                XCTAssertEqual(team.players?.first?.player_name, "Michele Di Gregorio")
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockGetTeamDetails_Failure() {
        let ex = expectation(description: "Mock Team Details Failure")
        
        mockFailureObj.getTeamDetails(
            sport: .Football,
            teamId: 96
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual((error as NSError).domain, "MockError")
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 2)
 
    }
}
