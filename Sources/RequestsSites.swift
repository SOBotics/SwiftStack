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

- authors: FelixSFD, NobodyNada
*/
public extension APIClient {
	
	// - MARK: /sites
    /**
     Fetches all `Site`s in the Stack Exchange network synchronously.
     
     - parameter parameters: The dictionary of parameters used in the request
     
     - parameter backoffBehavior: The behavior when an APIRequest has a backoff
     
     - returns: The list of sites as `APIResponse<Site>`
     
     - author: NobodyNada
     */
	public func fetchSites(
		parameters: [String:String] = [:],
		backoffBehavior: BackoffBehavior = .wait) throws -> APIResponse<Site> {
		
		
		var params = parameters
		params["site"] = ""
		
		return try performAPIRequest(
			"sites",
			parameters: params,
			backoffBehavior: backoffBehavior
		)
	}
    
    /**
     Fetches all `Site`s in the Stack Exchange network asynchronously.
     
     - parameter parameters: The dictionary of parameters used in the request
     
     - parameter backoffBehavior: The behavior when an APIRequest has a backoff
     
     - parameter completionHandler: Passes an `APIResponse<Site>?` when the request was successful or `Error?` if the request failed. There is no case, where both parameters are not `nil`.
     
     - author: FelixSFD
     */
    public func fetchSites(parameters: [String: String] = [:], backoffBehavior: BackoffBehavior = .wait, completionHandler: @escaping (APIResponse<Site>?, Error?) -> ()) {
        
        queue.async {
            
            do {
                let response: APIResponse<Site> = try self.fetchSites(parameters: parameters, backoffBehavior: backoffBehavior)
                completionHandler(response, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
	
}
