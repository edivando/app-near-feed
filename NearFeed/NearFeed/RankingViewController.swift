//
//  RankingViewController.swift
//  NearFeed
//
//  Created by Alisson Carvalho on 22/07/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit
import Parse

class RankingViewController: UIViewController, UITableViewDataSource {
    
    var users = [User]()
    var position : String?
    var maxScore : Int?
    
    //MARK: - Outlets
    @IBOutlet var tableview: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove linhas vazias
        tableview.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//        tableview.dataSource = self
        //self.floatRatingView.editable = false
        
        User.findAllOrderByScores { (users) -> () in
            if let users = users{
                var i = 0
                for ; i < users.count ; i++ {
                    
                    if let data = users[i]["name"] as? String{
                        
                        self.users.append(users[i])
                        println(data)
                        
                        if data == User.currentUser()?.name{
                            //self.positionLabel.text = String(i+1)
                            self.position = String(i+1)
                        }
                        
                    }
                    
                }
                self.maxScore = Int(users[0].score)
            }
            self.tableview.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Eu"
        } else {
            return "Todos"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableview.dequeueReusableCellWithIdentifier("cell") as! RankingTableViewCell
        
        if indexPath.section == 0 {
            
            //self.position = "999"
            
            let user = User.currentUser()!
            
            if self.position?.toInt() <= 1000 {
                cell.positionLabel.text = "\(self.position!)"
            } else {
                cell.positionLabel.font = UIFont(name: "Helvetica", size: 10)
                cell.positionLabel.text = "\(self.position!)"
            }
            cell.nameLabel.text = User.currentUser()?.name
            cell.scoreLabel.text = "\(user.score) scores"
            cell.floatRatingView.rating = Float(Int(Float(user.score) / Float(self.maxScore!) * 5.0))
            user.image.image({ (image) -> () in
                if let image = image{
                    println("entrou no thumb")
                    cell.imageview.image = image
                }
            })
//            if let imageFile = User.currentUser()!["image"] as? PFFile {
//                
//                imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
//                    if error == nil {
//                        cell.imageview.image = UIImage(data: imageData!)
//                    }
//                })
//            } else {
//                cell.imageview.image = UIImage(named: "user")
//            }
            
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

}
