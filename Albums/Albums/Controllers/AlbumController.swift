//
//  AlbumController.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import Foundation

class AlbumController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var albums: [Album] = [] 
    let baseURL: URL = URL(string: "https://albums-50376.firebaseio.com/")!
    
    func testDecodingExampleAlbum() {
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")
        guard let url = urlPath else { return }
        let data = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let album = try! decoder.decode(Album.self, from: data)
        print(album)
    }
    
    func testEncodingExampleAlbum() {
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")
        guard let url = urlPath else { return }
        let data = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let album = try! decoder.decode(Album.self, from: data)
        print(album)
        
        let encoder = JSONEncoder()
        let albumData = try! encoder.encode(album)
        let albumString = String(data: albumData, encoding: .utf8)
        print(albumString!)
    }
    
    func getAlbums(completion: @escaping (Error?) -> ()) {
        let getAlbumUrl = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: getAlbumUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error receiving album data: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Bad Data", code: 0, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let albums = try decoder.decode([String: Album].self, from: data)
                self.albums = []
                for (_, album) in albums {
                    self.albums.append(album)
                }
                print("Order: \(self.albums[0].name), \(self.albums[1].name)")
                completion(nil)
            } catch {
                NSLog("Error decoding album objects: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func put(album: Album) {
        let addAlbumUrl = baseURL
            .appendingPathComponent("\(album.id)")
            .appendingPathExtension("json")
        
        var request = URLRequest(url: addAlbumUrl)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(album)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding album object: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Other error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Status code: \(response.statusCode)")
                return
            }
        }.resume()
    }
    
    func createAlbum(name: String, artist: String, id: String, genres: [String], songs: [Song], coverArt: [URL]) {
        let album = Album(name: name, artist: artist, id: id, genres: genres, songs: songs, coverArt: coverArt)
        self.albums.append(album)
        put(album: album)
    }
    
    func createSong(title: String, duration: String, id: String) -> Song {
        let song = Song(title: title, duration: duration, id: id)
        return song
    }
    
    func update(album: Album, name: String, artist: String, id: String, genres: [String], songs: [Song], coverArt: [URL]) {
        var album = album
        
        album.name = name
        album.artist = artist
        album.id = id
        album.genres = genres
        album.songs = songs
        album.coverArt = coverArt
        
        put(album: album)
    }
}
