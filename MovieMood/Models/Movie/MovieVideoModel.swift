//
//  MovieVideoModel.swift
//  MovieMood
//
//  Created by Дмитрий on 08.04.2023.
//

struct MovieVideoModel: Decodable {
    let id: Int
    let results: [Results]
}

struct Results: Decodable {
    let key: String
}
