//
//  AppError.swift
//  Weather Designs
//
//  Created by Jason Ruan on 3/10/20.
//  Copyright © 2020 Jason Ruan. All rights reserved.
//

import Foundation


enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
