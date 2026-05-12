//
//  SportixTests.swift
//  SportixTests
//
//  Created by Hazem Abdelraouf on 05/05/2026.
//

import XCTest
@testable import Sportix

class SportixTests: XCTestCase {
    
    var networkObj: NetworkManager!

    
    override func setUpWithError() throws {
        networkObj = NetworkManager.shared
    }

    override func tearDownWithError() throws {
        networkObj = nil
    }
    

  // MARK: - Success Tests
  
  func testFetchLeaguesFromApi() {
      let ex = expectation(description: "load leagues from api")
      
      Task {
          do {
              let leagues = try await networkObj.fetchLeagues(sport: .Football)
              
              XCTAssertNotNil(leagues)
              XCTAssertGreaterThanOrEqual(leagues.count, 0)
              
          } catch {
              XCTFail("Expected success but got error: \(error)")
          }
          
          ex.fulfill()
      }
      
      waitForExpectations(timeout: 10)
  }
  
  
  
  func testFetchTeamDetailsFromApi() {
      let ex = expectation(description: "load team details from api")
      
      Task {
          do {
              let team = try await networkObj.fetchTeamDetails(
                  sport: .Football,
                  teamId: 2611
              )
              
              XCTAssertNotNil(team)
              
          } catch {
              XCTFail("Expected success but got error: \(error)")
          }
          
          ex.fulfill()
      }
      
      waitForExpectations(timeout: 10)
  }
  
  // MARK: - Failure Tests
  
  
  func testFetchTeamDetailsFromApi_Failure() {
      let ex = expectation(description: "load team details failure from api")
      
      Task {
          do {
              let _ = try await networkObj.fetchTeamDetails(
                  sport: .Football,
                  teamId: -1
              )
              
              XCTFail("Should fail with invalid team id")
              
          } catch {
              XCTAssertNotNil(error)
          }
          
          ex.fulfill()
      }
      
      waitForExpectations(timeout: 10)
  }
}

