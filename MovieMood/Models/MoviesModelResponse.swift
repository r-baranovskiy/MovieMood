//
//  MoviesModelResponse.swift
//  MovieMood
//
//  Created by Сергей Золотухин on 04.04.2023.
//

struct MoviesResponseModel: Decodable {
    let results: [MovieModel]
}

struct MovieModel: Decodable {
    let id: Int
    let title: String
    let release_date: String
    let genre_ids: [Int]
}
