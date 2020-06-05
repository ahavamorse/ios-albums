//
//  AlbumDetailTableViewController.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var genresTextField: UITextField!
    @IBOutlet weak var coverURLsTextField: UITextField!
    
    var albumController: AlbumController?
    var album: Album? {
        didSet {
            updateViews()
        }
    }
    var tempSongs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        if let album = album {
            albumNameTextField.text = album.name
            artistTextField.text = album.artist
            genresTextField.text = album.genres.joined(separator: ", ")
            
            var urlsString = ""
            
            for url in album.coverArt {
                urlsString += "\(url)"
            }
            
            coverURLsTextField.text = urlsString
            
            tempSongs = album.songs
        } else {
            albumNameTextField.text = "New Album"
        }
    }
    
    func addSong(with title: String, duration: String) {
        if let albumController = albumController {
            let song = albumController.createSong(title: title, duration: duration, id: title)
            tempSongs.append(song)
        }

        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: tempSongs.count, section: 0), at: .bottom, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSongs.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongTableViewCell else { return UITableViewCell() }
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let albumController = albumController {
            if indexPath.row == albumController.albums[indexPath.row].songs.count - 1 {
                return 100
            }
        }
        return 140
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveAlbum(_ sender: UIBarButtonItem) {
        if let albumController = albumController,
            let title = albumNameTextField.text,
            let artist = artistTextField.text,
            let genresText = genresTextField.text,
            let coverArtUrlsText = coverURLsTextField.text {
            if let album = album {
                
                let genresArray = genresText.split(separator: ",")
                var genres: [String] = []
                for substring in genresArray {
                    let words = substring.split(separator: " ")
                    let genre = words.joined(separator: " ")
                    genres.append(genre)
                }
                
                let urlArray = coverArtUrlsText.split(separator: ",")
                var urls: [URL] = []
                for substring in urlArray {
                    let string = substring.description.replacingOccurrences(of: " ", with: "")
                    if let url = URL(string: string) {
                        urls.append(url)
                    }
                }
                
                albumController.update(album: album, name: title, artist: artist, id: title, genres: genres, songs: tempSongs, coverArt: urls)
                
            } else {
                // TODO: Create new Album
            }
        }
        
    }
    
}
