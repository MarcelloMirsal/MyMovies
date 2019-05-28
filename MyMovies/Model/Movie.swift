//
//  Movie.swift
//  MyMovies
//
//  Created by Marcello Mirsal on 10/05/2019.
//  Copyright © 2019 Marcello Mirsal. All rights reserved.
//

import UIKit

struct Movie: Codable {
    
    let id: Int
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, posterPath = "poster_path", releaseDate = "release_date", overview, voteAverage = "vote_average"
    }
}

struct ApiResponse<T: Codable>: Codable {
    var page: Int
    let totalPages: Int
    var results: [T]
    
    enum CodingKeys: String, CodingKey {
        case page, totalPages = "total_pages", results
    }
}
