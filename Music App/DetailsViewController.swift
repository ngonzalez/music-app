//
//  DetailsViewController.swift
//  Music App
//
//  Created by Nicolas Gonzalez on 2018-05-20.
//  Copyright © 2021 Nicolas Gonzalez. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import AVFoundation

class DetailsViewController: BaseController {

    var videoPlayer:AVPlayer!
    
    var playerViewController:AVPlayerViewController = AVPlayerViewController()

    var m3u8_exists:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems(id: self.selectedId)
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func getItems(id: Int) {
        let url = NSString(format:"%@/music_folders/%i.json", ApiURL, id) as String
        getURL(url: url, fn: {(results) in
            self.messagesArray = results as! [AnyObject]
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:AnyObject = getItem(index: indexPath.row)
        let itemId:Int = item["item_id"] as! Int
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.m3u8_exists = false
        playTrack(id: itemId)
    }

    override func format_cell_label(item: AnyObject) -> String {
        let itemArtist = item["artist"] as! String
        let itemTitle = item["title"] as! String
        return "\(itemArtist) - \(itemTitle)"
    }

    func playTrack(id: Int) {
        let trackUrl = NSString(format:"%@/audio_files/%i.json", ApiURL, id) as String
        for _ in 1...10 {
            if (self.m3u8_exists) {
                playStream(url: "/hls/\(id).m3u8")
                break
            } else {
                getURL(url: trackUrl, fn: {(results) in
                    if (results["m3u8_exists"] as? Int == 1) {
                        self.m3u8_exists = true
                    }
                })
                sleep(1)
            }
        }
    }

    func playStream(url: String) {
        let trackUrl = NSString(format:"%@/%@", ApiURL, url) as String
        let streamAsset = AVAsset(url: URL(string: trackUrl)!)
        let playerItem = AVPlayerItem(asset: streamAsset)
        self.playerViewController.delegate = self as? AVPlayerViewControllerDelegate
        let player = AVPlayer(playerItem: playerItem)
        self.playerViewController.player = player
        self.present(self.playerViewController, animated: true) {
            player.play()
        }
    }
    
}
