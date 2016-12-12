//
//  SiteTests.swift
//  SwiftStack
//
//  Created by FelixSFD on 10.12.16.
//
//

import XCTest
import SwiftStack

class SiteTests: XCTestCase {
    
    var expectation: XCTestExpectation?
    
    func testMainSite() {
        let json = "{\"styling\": {\"tag_background_color\": \"#E0EAF1\",\"tag_foreground_color\": \"#3E6D8E\",\"link_color\": \"#0077CC\"},\"related_sites\": [{\"relation\": \"meta\",\"api_site_parameter\": \"meta.example\",\"site_url\": \"http://meta.example.stackexchange.com/\",\"name\": \"Meta Example Site\"}],\"launch_date\": 1481360679,\"open_beta_date\": 1481274279,\"closed_beta_date\": 1481187879,\"site_state\": \"normal\",\"twitter_account\": \"@StackExchange\",\"favicon_url\": \"http://sstatic.net/stackexchange/img/favicon.ico\",\"icon_url\": \"http://sstatic.net/stackexchange/img/apple-touch-icon.png\",\"audience\": \"example lovers\",\"site_url\": \"http://example.stackexchange.com\",\"api_site_parameter\": \"example\",\"logo_url\": \"http://sstatic.net/stackexchange/img/logo.png\",\"name\": \"Example Site\",\"site_type\": \"main_site\"}"
        
        let site = Site(jsonString: json)
        let jsonSite = site?.jsonString
        print(jsonSite ?? "nil")
        XCTAssertNotNil(jsonSite)
    }
    
    
    func testFetchSites() {
        expectation = expectation(description: "Fetched sites")
        
        let client = APIClient()
        print("starting...")
        client.fetchSites([:], backoffBehavior: .wait) {
            response, error in
            print("completion handler")
            if error != nil {
                print(error)
                XCTFail("Sites not fetched")
                return
            }
            
            print(response?.items)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}
