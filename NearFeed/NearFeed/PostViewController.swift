//
//  PostViewController.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        PostLike().findAll()
        
        let post = Post()
        post.newPost("Test new post \(NSUUID().UUIDString)", images: nil) { (error) -> () in
            if error == nil{
                PostLike().addLike(post, like: true)
                
                PostComment().addComment(post, message: "Test comment")
                
                PostReport().addReport(post, message: "Conteudo improprio")
                
            }
        }
    }


}
