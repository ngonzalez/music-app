//
//  DetailsController.swift
//  MusicApp
//
//  Created by enyo on 2015-04-12.
//  Copyright (c) 2015 enyo. All rights reserved.
//

import UIKit

import AVFoundation;
import AVKit;

class DetailsController: BaseController {

    @IBOutlet var tableView: UITableView!
    
    var messagesArray: [AnyObject] = []

    var selectedTrackid: Int = Int()
    
    func getItem(index: Int) -> AnyObject {
        return messagesArray[index].valueForKey("track")!
    }

    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return messagesArray.count
    }

    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: AnyObject) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TrackCell")
        cell.textLabel!.text = getItem(indexPath.row).valueForKey("name") as? String
        return cell
    }

    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: AnyObject) {
        selectedTrackid = getItem(indexPath.row).valueForKey("id") as! Int
        performSegueWithIdentifier("ShowMusic", sender:self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMusic" {
            if let controller:AVPlayerViewController = segue.destinationViewController as? AVPlayerViewController {
                controller.player = AVPlayer.playerWithURL(NSURL(string: NSString(format:"%@/demo.mp3", ApiURL) as! String)) as! AVPlayer
            }
        }
    }

    func getTracks(releaseId: Int) {
        getData(NSString(format:"%@/music/%i.json", ApiURL, releaseId) as! String, fn: { (results) in
            self.messagesArray = results as! [AnyObject]
            self.tableView.reloadData()
        })
    }

}
