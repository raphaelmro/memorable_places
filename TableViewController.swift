//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Raphael Onofre on 5/25/16.
//  Copyright © 2016 Raphael Onofre. All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]

var activePlace = -1


class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if places.count == 1 {
            
            places.removeAtIndex(0)
            places.append(["name":"Taj Mahal","lat":"27.173891","lon":"78.042068"])
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 

        cell.textLabel?.text = places[indexPath.row]["name"]

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row
        return indexPath
    
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData() 
    }
    

}
