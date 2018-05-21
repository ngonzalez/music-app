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
    
    var mediaUrl:String!
    
    var streamUuid:String!
    
    var streamUrl:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        getItems(id: self.selectedId)
    }

    func getItems(id: Int) {
        let url = NSString(format:"%@/music/%i.json", ApiURL, id) as String
        getURL(url: url, fn: {(results) in
            self.messagesArray = results as! [AnyObject]
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let value = getItem(index: indexPath.row)["id"] as? Int {
            // Clear track infos
            self.mediaUrl = nil
            self.streamUuid = nil
            self.streamUrl = nil
            
            // Start Player
            playTrack(id: value)
        }
    }

    override func format_cell_label(item: AnyObject) -> String {
        return (item["number"] as! String) + " - " +
               (item["artist"] as! String) + " - " +
               (item["title"] as! String)
    }
    
    func playTrack(id: Int) {
        let trackUrl = NSString(format:"%@/tracks/%i.json", ApiURL, id) as String
        for _ in 1...5 {
            getURL(url: trackUrl, fn: {(trackResults) in
                if let value = trackResults["media_url"] as? String {
                    self.mediaUrl = value
                }
            })
            if (self.mediaUrl != nil) {
                break
            } else {
                sleep(1)
            }
        }
        if (self.mediaUrl != nil) {
            let streamUrl = NSString(format:"%@/streams/%i.json", ApiURL, id) as String
            for _ in 1...5 {
                getURL(url: streamUrl, fn: {(streamResults) in
                    if let value = streamResults.value(forKey: "stream_uuid") as? String {
                        self.streamUuid = value
                    }
                })
                if (self.streamUuid != nil) {
                    break
                } else {
                    sleep(1)
                }
            }
        }
        if (self.mediaUrl != nil && self.streamUuid != nil) {
            let getStreamUrl = NSString(format:"%@/streams/get_url.json?stream_uuid=%@", ApiURL, self.streamUuid) as String
            for _ in 1...5 {
                getURL(url: getStreamUrl, fn: {(getStreamResults) in
                    if let value = getStreamResults["stream_url"] as? String {
                        self.streamUrl = value
                    }
                })
                if (self.streamUrl != nil) {
                    break
                } else {
                    sleep(1)
                }
            }
        }
        if (self.mediaUrl != nil && self.streamUuid != nil && self.streamUrl != nil) {
            let streamAsset = AVAsset(url: URL(string: self.streamUrl)!)
            let playerItem = AVPlayerItem(asset: streamAsset)
            let playerViewController = AVPlayerViewController()
            playerViewController.delegate = self as? AVPlayerViewControllerDelegate
            let player = AVPlayer(playerItem: playerItem)
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }

}
