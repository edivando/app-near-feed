//
//  Message.swift
//  Talk
//
//  Created by Edivando Alves on 6/7/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Foundation

struct Message {
    
    static func success(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Success)
    }
    
    static func success5(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Success, duration: 5)
    }
    
    static func error(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Error)
    }
    
    static func error5(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Error, duration: 5)
    }
    
    static func info(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Info)
    }
    
    static func info5(title: String, text: String){
        TWMessageBarManager.sharedInstance().showMessageWithTitle(title, description: text, type: .Info, duration: 5)
    }
    
}