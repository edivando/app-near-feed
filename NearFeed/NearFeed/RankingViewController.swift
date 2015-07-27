//
//  RankingViewController.swift
//  NearFeed
//
//  Created by Alisson Carvalho on 22/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class RankingViewController: UITableViewController {
    
    var users = [User]()
    var userPosition = "9999"
    var maxScore : Int?
    
    var page = 0
    var isLoading = false
    
//    //MARK: - Outlets
//    @IBOutlet var tableview: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        page = 0
        //Remove linhas vazias
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//        tableview.dataSource = self
        //self.floatRatingView.editable = false
        
        loadUsers()
    }
    
    func loadUsers(){
        User.findAllOrderByScores(page, callback: { (users) -> () in
            if let users = users{
                self.maxScore = Int(users[0].score)
                
                for (index, user) in enumerate(users){
                    if user.objectId == User.currentUser()?.objectId{
                        self.userPosition = "\(index)"
                    }
                    self.users.append(user)
                }
            }
            self.page++
            self.isLoading = false
            self.tableView.reloadData()
        })
    }
    
    func updateUsers(){
        User.findAllOrderByScores(page, callback: { (users) -> () in
            if let users = users where users.count > 0{
                for (index, user) in enumerate(users){
                    if user.objectId == User.currentUser()?.objectId{
                        self.userPosition = "\(index)"
                    }
                    let indexPath = NSIndexPath(forRow: self.users.count, inSection: 1)
                    self.users.append(user)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
            self.page++
            self.isLoading = false
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y
        var maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 40 {
            if !isLoading && users.count > 0{
                isLoading = true
                updateUsers()
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Eu"
        } else {
            return "Todos"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RankingTableViewCell
        if indexPath.section == 0 {
            
            let user = User.currentUser()!
            cell.positionLabel.text = userPosition
            
//            if position <= 1000 {
//                cell.positionLabel.text = "\(position)"
//            } else {
//                cell.positionLabel.font = UIFont(name: "Helvetica", size: 10)
//                cell.positionLabel.text = "\(position)"
//            }
            
            
            cell.nameLabel.text = User.currentUser()?.name
            cell.scoreLabel.text = "\(user.score) scores"
            cell.floatRatingView.rating = Float(Int(Float(user.score) / Float(self.maxScore!) * 5.0))
            user.image.image({ (image) -> () in
                if let image = image{
                    println("entrou no thumb")
                    cell.imageview.image = image
                }
            })
            return cell
            
        } else {
            let user = users[indexPath.row]
            cell.nameLabel.text = user.name
            cell.positionLabel.text = String(indexPath.row + 1)
            cell.scoreLabel.text = "\(user.score) scores"
            cell.floatRatingView.rating = Float(Int(Float(user.score) / Float(self.maxScore!) * 5.0))
            cell.imageview.image = UIImage(named: "user")
            user.image.image({ (image) -> () in
                if let image = image{
                    println("entrou no thumb")
                    cell.imageview.image = image
                }
            })
            return cell
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
            return 0
        } else {
            if section == 0 {
                return 1
            
            } else {
                return users.count
            }
        }
    }
    
//    private func getCurrentUserPosition() -> Int?{
//        for (index, user) in enumerate(users){
//            if user.objectId == User.currentUser()?.objectId{
//                return index
//            }
//        }
//        return nil
//    }

}





//func updateUsers(){
//    User.findAllOrderByScores(page, callback: { (users) -> () in
//        if let users = users{
//            self.users = users
//            self.maxScore = Int(users[0].score)
//            
//            //                var i = 0
//            //                for ; i < users.count ; i++ {
//            //
//            //                    if let data = users[i]["name"] as? String{
//            //
//            //                        self.users.append(users[i])
//            //                        println(data)
//            //
//            //                        if data == User.currentUser()?.name{
//            //                            //self.positionLabel.text = String(i+1)
//            //                            self.position = String(i+1)
//            //                        }
//            //
//            //                    }
//            //
//            //                }
//            
//        }
//        self.isLoading = false
//        self.tableview.reloadData()
//    })
//}