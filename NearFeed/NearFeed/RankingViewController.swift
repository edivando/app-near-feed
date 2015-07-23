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
    
    
    var currentObject : PFUser?
    
    //MARK - Outlets
    @IBOutlet var tableview: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentObject = PFUser.currentUser()
        //imageImageView.frame = CGRectMake(0, 0, 100, 100)
        
        var colecao : [AnyObject]?
        
        //if !PFAnonymousUtils.isLinkedWithUser(currentObject) {
         //   println("nao anonimo")

            var query = User.query()
        
        
                query!.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil, let users = objects {
                        println(users)
                    }
                })
        
//            query.findObjectsInBackgroundWithBlock({ (lista : [AnyObject]?, error : NSError?) -> Void in
//                
//                if (error != nil) {
//                    colecao = lista
//                    println("Printando a Lista")
//                    println(lista)
//                    // The find succeeded. The first 100 objects are available in objects
//                } else {
//                    // Log details of the failure
//                    println("Entrou no error : \(error)")
//                }
//                
//                
//            })
//        
//            for var i = 0 ; i < colecao?.count ; i++ {
//                //let user : PFUser = object["name"] as PFUser
//                println("\(colecao![i])")
//            }
        
        //}


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableview.dequeueReusableCellWithIdentifier("cell") as! RankingTableViewCell
        

        
        let linha = indexPath.row
        
        //let carro = carros[linha]
        
        //(cell as! TableViewCell).usernameLabel.text = friendsArray[indexPath.row] as String
        //cell.labelNome.text = carro.nome
        //cell.labelDesc.text = carro.desc
        
        //let data = NSData(contentsOfURL: NSURL(string: carro.url_foto)!)!
        
        //cell.imagemCarro.setUrl(carro.url_foto)
        
        //        cell.imagemCarro.image = UIImage(named: carro.url_foto)
        //  (cell as! CarroCell).labelNome.text = carro.nome
        //
        //     (cell as! CarroCell).labelDesc.text = carro.desc
        //
        //   (cell as! CarroCell).imagemCarro.image = UIImage(named: carro.url_foto)
        
        //cell.textLabel?.text = "Carro \(carro.nome)"
        
        //cell.imageView?.image = UIImage(named: "ferrari_ff.png")
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
