//
//  TracksDataSource.swift
//  DeezerFun
//
//  Created by Erick Vavretchek on 11/2/20.
//  Copyright © 2020 Erick Vavretchek. All rights reserved.
//

import UIKit

class TracksDataSource: NSObject, UITableViewDataSource {
    
    var tracks: [[Track]] = []
    var album: Album?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell,
            let album = album else {
            return UITableViewCell()
        }
        
        cell.configure(track: tracks[indexPath.section][indexPath.row], album: album)
        return cell
    }
}
