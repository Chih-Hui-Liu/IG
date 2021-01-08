//
//  MovieData.swift
//  IG
//
//  Created by Leo on 2021/1/7.
//

import Foundation
struct MovieData : Codable{
    var feed:Feed
}
struct Feed:Codable {
    var title:String
    var country:String
    var updated:String
    var results:[Results]
}
struct Results:Codable {
    var artistName:String
    var releaseDate:String
    var name:String
    var kind:String
    var artworkUrl100:URL
    var genres:[Genres]
    struct Genres:Codable {
        var name:String
        var url:URL
    }
    var url:URL
}
