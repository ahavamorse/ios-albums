//
//  AlbumController.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import Foundation

class AlbumController {
    
    
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
}
