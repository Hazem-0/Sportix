//
//  NetworkError.swift
//  Sportix
//
//  Created by Aalaa Adel on 10/05/2026.
//


import Foundation

enum NetworkError: LocalizedError {
    
    case emptyData
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "No data found."
        case .serverError(let message):
            return message
        }
    }
}
