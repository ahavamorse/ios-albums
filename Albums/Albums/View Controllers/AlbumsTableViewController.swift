//
//  AlbumsTableViewController.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    var albumController: AlbumController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let albumController = albumController {
            albumController.getAlbums { (error) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let albumController = albumController {
            return albumController.albums.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)

        if let albumController = albumController {
            let album = albumController.albums[indexPath.row]
            
            cell.textLabel?.text = album.name
            cell.detailTextLabel?.text = album.artist
        }

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? AlbumDetailTableViewController else { return }
        if segue.identifier == "newAlbumSegue" {
            destination.albumController = albumController
        } else if segue.identifier == "editAlbumSegue" {
            destination.albumController = albumController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.album = albumController?.albums[indexPath.row]
            }
        }
    }
}
