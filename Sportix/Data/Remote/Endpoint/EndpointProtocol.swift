//
//  EndpointProtocol.swift
//  Sportix
//
//  Created by Hazem Abdelraouf on 10/05/2026.
//

import Alamofire

protocol NetworkEndpoint {
    var path: String { get }
    var parameters: Parameters { get }
}

