//
//  Country.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//


import Parse

class Country: PFObject, PFSubclassing  {
    
    @NSManaged var name: String
   
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Country"
    }
    
    
//    func findByName() -> Country?{
//        if let query = Country.query(){
//            query.whereKey("name", equalTo: name)
//            let countrys = query.findObjects() as? [Country]
//            if countrys?.count > 0{
//                return countrys?.first
//            }
//        }
//        return nil
//    }
//    
//    func saveIfNotExiste() -> Country{
//        if let obj = findByName(){
//            return obj
//        }else{
//            self.save()
//            return self
//        }
//    }
    
    func findByName(success: (countrys: [Country])->(), error: (erro: NSError?)->()){
        if let query = Country.query(){
            query.whereKey("name", equalTo: name)
            query.findObjectsInBackgroundWithBlock({ (objects, erro) -> Void in
                if erro == nil{
                    if let countrys = objects as? [Country]{
                        success(countrys: countrys)
                    }
                }else{
                    error(erro: erro)
                }
            })
        }
    }
    
}
