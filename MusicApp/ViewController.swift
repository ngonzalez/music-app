//
//  ViewController.swift
//  MusicApp
//
//  Created by enyo on 2015-04-12.
//  Copyright (c) 2015 enyo. All rights reserved.
//

import UIKit

class ViewController: BaseController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var originalMessagesArray: [AnyObject] = []

    var messagesArray: [AnyObject] = []

    var selectedReleaseId: Int = Int()

    override func viewWillAppear(animated:Bool) {
        getCollection()
        super.viewWillAppear(animated)
    }

    func getItem(index: Int) -> AnyObject {
        return messagesArray[index].valueForKey("release")!
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        messagesArray = originalMessagesArray.filter({ (object:AnyObject) in
            if searchText.isEmpty { return true }
            let name = object.valueForKey("release")!.valueForKey("name") as! String
            return name.lowercaseString.rangeOfString(searchText) != nil
        })

        tableView.reloadData()
    }

    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return messagesArray.count
    }

    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: AnyObject) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "ReleaseCell")
        cell.textLabel!.text = getItem(indexPath.row).valueForKey("name") as? String
        return cell
    }

    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: AnyObject) {
        selectedReleaseId = getItem(indexPath.row).valueForKey("id") as! Int
        performSegueWithIdentifier("ShowDetails", sender:self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            if let controller:DetailsController = segue.destinationViewController as? DetailsController {
                controller.getTracks(selectedReleaseId)
            }
        }
    }

    func getCollection() {
        getData(NSString(format:"%@/music.json", ApiURL) as! String, fn: { (results) in
            self.originalMessagesArray = results as! [AnyObject]
            self.messagesArray = results as! [AnyObject]
            self.tableView.reloadData()
        })
    }

}

