//
//  Scores.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/20/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Foundation

enum Score: NSNumber{
    
    case Post = 5
    case LikeReceive = 1
    case DislikeReceive = -1
    case CommentReceive = 2
//    case LikeSend = 1
//    case DislikeSend = 1
//    case CommentSend = 1
    

    
    var value: NSNumber{
        get{
            return self.rawValue
        }
    }
    
    
}

