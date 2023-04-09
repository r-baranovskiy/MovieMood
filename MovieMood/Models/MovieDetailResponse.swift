//
//  MovieDetailResponse.swift
//  MovieMood
//
//  Created by Сергей Золотухин on 04.04.2023.
//

struct MovieDetailResponse: Decodable {
    let backdrop_path: String?
    let genres: [Genre]
    let title: String
    let vote_average: Double
    let runtime: Int?
    let release_date: String
    let poster_path: String?
    let overview: String?
}

struct Genre: Decodable {
    let id: Int
    let name: String
}


