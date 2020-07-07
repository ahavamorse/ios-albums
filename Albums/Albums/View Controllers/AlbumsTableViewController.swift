//
//  AlbumsTableViewController.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    var albumController: AlbumController? = AlbumController()
    var tempAlbums: [Album] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let albumController = albumController {
            albumController.getAlbums { (error) in
                if let error = error {
                    NSLog("Error: \(error)")
                } else {
                    self.tempAlbums = albumController.albums
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempAlbums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        let album = tempAlbums[indexPath.row]
        
            cell.textLabel?.text = album.name
            cell.detailTextLabel?.text = album.artist

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
                albumController?.getAlbums(completion: { (error) in
                    if let error = error {
                        NSLog("Error getting albums when going to details: \(error)")
                    }
                })
                destination.album = tempAlbums[indexPath.row]
            }
        }
    }
}
