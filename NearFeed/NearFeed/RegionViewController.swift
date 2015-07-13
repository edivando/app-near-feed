//
//  RegionViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class RegionViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // change indicator view style to white
        tableView.infiniteScrollIndicatorStyle = .White
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            
            tableView.finishInfiniteScroll()
        }
    }

    
    
    
//    private func fetchData(handler: ((Void) -> Void)?) {
//        let hits: Int = Int(CGRectGetHeight(tableView.bounds)) / 44
//        let requestURL = apiURL(hits, page: currentPage)
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(requestURL, completionHandler: {
//            (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.handleResponse(data, response: response, error: error)
//                
//                UIApplication.sharedApplication().stopNetworkActivity()
//                
//                handler?()
//            });
//        })
//        
//        UIApplication.sharedApplication().startNetworkActivity()
//        
//        // I run task.resume() with delay because my network is too fast
//        let delay = (stories.count == 0 ? 0 : 5) * Double(NSEC_PER_SEC)
//        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue(), {
//            task.resume()
//        })
//    }
    

}
