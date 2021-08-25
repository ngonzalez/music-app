//
//  ViewController.swift
//  Music App
//
//  Created by enyo on 2018-05-20.
//  Copyright © 2018 enyo. All rights reserved.
//

import UIKit

class ViewController: BaseController {

    @IBOutlet weak var searchBar: UISearchBar!

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let value = searchBar.text {
            search(text: value)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.messagesArray.removeAll()
            self.tableView.reloadData()
        }
    }

    func search(text: String) {
        let escapedTxt = text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let url = NSString(format:"%@/music_folders.json?q=%@", ApiURL, escapedTxt) as String
        getURL(url: url, fn: {(results) in
            self.messagesArray = results as! [AnyObject]
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        })
    }

    override func format_cell_label(item: AnyObject) -> String {
        let itemYear = item["year"] as! String
        let itemName = item["formatted_name"] as! String
        return "\(itemYear) - \(itemName)"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item:AnyObject = getItem(index: indexPath.row)
        let itemId:Int = item["id"] as! Int
        self.selectedId = itemId
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let controller:DetailsViewController = segue.destination as? DetailsViewController {
                controller.selectedId = self.selectedId
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

