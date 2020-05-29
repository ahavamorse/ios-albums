//
//  Album.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import Foundation

struct Album: Codable {
    
    enum CodingKeys: String, CodingKey {
        case artist
        case name
        case id
        case genres
        case songs
        case coverArt
        
        enum SongsKeys: String, CodingKey {
            case duration
            case id
            case name
            
            enum DurationKeys: String, CodingKey {
                case duration
            }
            
            enum NameKeys: String, CodingKey {
                case title
            }
        }
        
        enum CoverArtKeys: String, CodingKey {
            case url
        }
    }
    
    var name: String
    var artist: String
    var id: String
    var genres: [String]
    var songs: [Song]
    var coverArt: [URL]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode name, artist, and id
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.id = try container.decode(String.self, forKey: .id)
        
        // Decode Genres
        var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        var genres: [String] = []
        
        while genresContainer.isAtEnd == false {
            let genre = try genresContainer.decode(String.self)
            genres.append(genre)
        }
        
        self.genres = genres
        
        // Decode Songs
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        var songs: [Song] = []
        
        while songsContainer.isAtEnd == false {
            let songContainer = try songsContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.self)
            
            let songId = try songContainer.decode(String.self, forKey: .id)
            
            let durationContainer = try songContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.DurationKeys.self, forKey: .duration)
            
            let songDuration = try durationContainer.decode(String.self, forKey: .duration)
            
            let nameContainer = try songContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.NameKeys.self, forKey: .name)
            
            let songTitle = try nameContainer.decode(String.self, forKey: .title)
            
            let song = Song(title: songTitle, duration: songDuration, id: songId)
            songs.append(song)
        }
        
        self.songs = songs
        
        // Decode Cover Art
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        var urls: [URL] = []
        
        while coverArtContainer.isAtEnd == false {
            let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtKeys.self)
            
            let urlString = try urlContainer.decode(String.self, forKey: .url)
            if let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        
        self.coverArt = urls
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(artist, forKey: .artist)
        try container.encode(id, forKey: .id)
        
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        for url in coverArt {
            var urlContainer = coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtKeys.self)
            try urlContainer.encode(url, forKey: .url)
        }
        
        var genresContainer = container.nestedUnkeyedContainer(forKey: .genres)
        
        for genre in genres {
            try genresContainer.encode(genre)
        }
        
        var songsContainer = container.nestedUnkeyedContainer(forKey: .songs)
        
        for song in songs {
            var songContainer = songsContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.self)
            
            var durationContainer = songContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.DurationKeys.self, forKey: .duration)
            try durationContainer.encode(song.duration, forKey: .duration)
            
            try songContainer.encode(song.id, forKey: .id)
            
            var nameContainer = songContainer.nestedContainer(keyedBy: CodingKeys.SongsKeys.NameKeys.self, forKey: .name)
            
            try nameContainer.encode(song.title, forKey: .title)
        }
        
    }
}
