//
//  ViewController.swift
//  Music App
//
//  Created by enyo on 2018-05-20.
//  Copyright © 2018 enyo. All rights reserved.
//

import UIKit

class ViewController: BaseController {

    @IBOutlet var searchBar: UISearchBar!

    @IBOutlet weak var searchButton: UIButton!

    @IBAction func buttonClick(sender: UIButton) {
        if let txt = searchBar.text {
            let escapedTxt = txt.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
            let url = NSString(format:"%@/music/search.json?q=%@", ApiURL, escapedTxt) as String
            getURL(url: url, fn: {(results) in
                self.messagesArray = results as! [AnyObject]
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            })
        }
    }

    override func format_cell_label(item: AnyObject) -> String {
        return String(format: "%@", item["year"] as! NSNumber) + " " + (item["formatted_name"] as! String)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let value = getItem(index: indexPath.row)["id"] as? Int {
            self.selectedId = value
            performSegue(withIdentifier: "ShowDetails", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            if let controller:DetailsViewController = segue.destination as? DetailsViewController {
//                controller.getItems(id: self.selectedId)
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

