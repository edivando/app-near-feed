//
//  Extension.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/20/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//


import Parse

extension PFFile{
    
    var image: UIImage?{
        get{
            if let data = getData(){
                return UIImage(data: data)
            }
            return nil
        }
    }
}

