//
//  RequestsSites.swift
//  SwiftStack
//
//  Created by FelixSFD on 11.12.16.
//
//

import Foundation
import Dispatch

/**
 This extension contains all requests in the SITES section of the StackExchange API Documentation.
 
 - author: FelixSFD
 */
public extension APIClient {
    
    // - MARK: /sites
    /**
     JUST A TEST!
     
     - warning: Just a test. No parameters can be set yet!
     */
    public func fetchSites(completionHandler: @escaping (APIResponse<Site>?, Error?) -> ()) {
        DispatchQueue(label: "fetchSitesQueue").async {
            do {
                if let rawItems = try self.performAPIRequest("/sites", [:], backoffBehavior: .wait) as? [[String: Any]] {
                    var responseDict = [String: Any]()
                    responseDict["items"] = rawItems
                    
                    let response = APIResponse<Site>(dictionary: responseDict)
                    completionHandler(response, nil)
                }
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
}
