//
//  SongTableViewCell.swift
//  Albums
//
//  Created by Ahava on 5/22/20.
//  Copyright © 2020 Ahava. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    var song: Song?
    var delegate: SongTableViewCellDelegate?
    
    func update() {
        if let song = song {
            songTitleTextField.text = song.title
            durationTextField.text = song.duration
            addSongButton.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        songTitleTextField.text = ""
        durationTextField.text = ""
        addSongButton.isHidden = false
    }
    
    @IBAction func addSong(_ sender: Any) {
        if let title = songTitleTextField.text,
            let duration = durationTextField.text {
            delegate?.addSong(with: title, duration: duration)
        }
    }
}

protocol SongTableViewCellDelegate {
    func addSong(with title: String, duration: String)
}
