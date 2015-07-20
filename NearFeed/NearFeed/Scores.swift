//
//  Scores.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/20/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Foundation

enum Score: NSNumber{
    
    case NewPost
    case LikeReceive
    case DislikeReceive
    case CommentReceive
    case LikeSend
    case DislikeSend
    case CommentSend
    
    static let values = [5, 1, -1, 2, 1, 1, 1]
    
    var value: Int{
        get{
            return Score.values[self.rawValue.integerValue]
        }
    }
}


