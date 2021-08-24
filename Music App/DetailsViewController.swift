//
//  DetailsViewController.swift
//  Music App
//
//  Created by enyo on 2018-05-20.
//  Copyright © 2018 enyo. All rights reserved.
//

import UIKit
import AVKit
import Foundation
import AVFoundation

class DetailsViewController: BaseController {

    var videoPlayer:AVPlayer!
    
    var m3u8_exists:Bool = false
    
    var streamUrl:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems(id: self.selectedId)
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func getItems(id: String) {
        let url = NSString(format:"%@/music_folders/%@.json", ApiURL, self.selectedId) as String
        getURL(url: url, fn: {(results) in
            self.messagesArray = results as! [AnyObject]
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:AnyObject = getItem(index: indexPath.row)
        let itemId:String = item["data_url"] as! String
        self.tableView.deselectRow(at: indexPath, animated: true)
        playTrack(id: itemId)
    }

    override func format_cell_label(item: AnyObject) -> String {
        let itemArtist = item["artist"] as! String
        let itemTitle = item["title"] as! String
        return "\(itemArtist) - \(itemTitle)"
    }

    func playTrack(id: String) {
        print("playTrack \(id)")
        let trackUrl = NSString(format:"%@/audio_files/%@.json", ApiURL, id) as String
        for _ in 1...10 {
            getURL(url: trackUrl, fn: {(results) in
                print(results)
                if (results["m3u8_exists"] as? Int == 1) {
                    self.m3u8_exists = true
                    print("m3u8_exists: \(self.m3u8_exists)")
                }
                if let itemId = results["item_id"] as? Int {
                    self.streamUrl = "/hls/\(itemId).m3u8"
                    print("streamUrl: \(self.streamUrl)")
//                    let streamAsset = AVAsset(url: URL(string: self.streamUrl)!)
//                    let playerItem = AVPlayerItem(asset: streamAsset)
//                    let playerViewController = AVPlayerViewController()
//                    playerViewController.delegate = self as? AVPlayerViewControllerDelegate
//                    let player = AVPlayer(playerItem: playerItem)
//                    playerViewController.player = player
//                    self.present(playerViewController, animated: true) {
//                        player.play()
//                    }
                }
            })
            if (self.m3u8_exists) {
                break
            } else {
                sleep(1)
            }
        }
    }

}
