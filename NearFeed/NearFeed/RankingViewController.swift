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
    
    //MARK - Outlets
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
        return 3
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
