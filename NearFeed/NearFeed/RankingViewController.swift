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
    
    
    var currentObject : User?
    var usersTemp = [User]()
    var users = [User]()
    var position : String?
    
    //MARK: - Outlets
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var positionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //currentObject = User.currentUser()
        //imageImageView.frame = CGRectMake(0, 0, 100, 100)

        tableview.tableFooterView = UIView(frame: CGRectZero)
        
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableview.dataSource = self
        
        
        
        User.findAllOrderByScores { (users) -> () in
            
            var i = 0
            
            for ; i < users?.count ; i++ {
                
                if let data = users![i]["name"] as? String{
                    
                    self.users.append(users![i])
                    println(data)
                    
                    if data == User.currentUser()?.name{
                        //self.positionLabel.text = String(i+1)
                        self.position = String(i+1)
                    }
                    
                }
                
            }
            
            self.tableview.reloadData()
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func arredondarImagem(imageView: UIImageView ){
        imageView.layer.borderWidth=1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.cornerRadius = 13
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.clipsToBounds = true
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
            
            cell.positionLabel.text = position
            cell.nameLabel.text = User.currentUser()?.name
            cell.scoreLabel.text = "\((User.currentUser()?.score)!) scores"
            //cell.positionLabel.text = String(linha + 1)
            
            if let imageFile = User.currentUser()!["image"] as? PFFile {
                
                imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        cell.imageview.image = UIImage(data: imageData!)
                        self.arredondarImagem(cell.imageview)
                    }
                })
            } else {
                cell.imageview.image = UIImage(named: "user")
                self.arredondarImagem(cell.imageview)
            }
            
            return cell
            
        } else {
        
            let linha = indexPath.row
            //cell.positionLabel.text = String(linha + 1)
            cell.nameLabel.text = self.users[linha].name
            cell.positionLabel.text = String(linha + 1)
            cell.scoreLabel.text = "\(self.users[linha].score) scores"
            
            if let imageFile = users[linha]["image"] as? PFFile {
                
                
                //imageFile = thumbnail
                
                imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        println("entrou no thumb")
                        cell.imageview.image = UIImage(data: imageData!)
                        self.arredondarImagem(cell.imageview)
                    }
                })
            } else {
                cell.imageview.image = UIImage(named: "user")
                self.arredondarImagem(cell.imageview)
            }
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
