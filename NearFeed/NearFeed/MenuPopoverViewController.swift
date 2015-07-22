//
//  MenuPopoverViewController.swift
//  NearFeed
//
//  Created by Yuri Reis on 22/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class MenuPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var selected:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.scrollEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToCheck = tableView.cellForRowAtIndexPath(indexPath)
        cellToCheck?.accessoryType = UITableViewCellAccessoryType.Checkmark
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    

    
    // MARK: - Navigation

}
