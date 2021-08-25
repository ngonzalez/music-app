//
//  BaseController.swift
//  Music App
//
//  Created by enyo on 2018-05-20.
//  Copyright © 2018 enyo. All rights reserved.
//

import UIKit

class BaseController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate {

    var ApiURL = "http://192.168.64.5"

    @IBOutlet var tableView: UITableView!

    var messagesArray: [AnyObject] = []

    var selectedId: String = String()

    func getItem(index: Int) -> AnyObject {
        return messagesArray[index]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "TableViewCell")
        cell.textLabel!.text = format_cell_label(item: getItem(index: indexPath.row))
        return cell
    }

    func getURL(url: String, fn: @escaping (AnyObject) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            do {
                fn(try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject)
            } catch let error as NSError {
                print(error)
            }
        })
        task.resume()
    }

    func format_cell_label(item: AnyObject) -> String {
        fatalError("must be overriden")
    }
}
