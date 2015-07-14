//
//  Region.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/13/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//

import Parse

class Region: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var city: City
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Region"
    }
    
    
//    func findByName(region: (region: Region)->()){
//        if let query = Region.query(){
//            query.whereKey("name", equalTo: name)
//            query.findObjectsInBackgroundWithBlock({ (objs, erro) -> Void in
//                if erro != nil, obj as? [Region] where region.count > 0{
//                    region()
//                }
//                
//            })
//            
//            
//            let regions = query.findObjects() as? [Region]
//            if regions?.count > 0{
//                return regions?.first
//            }
//        }
//    }
//
//    func saveIfNotExiste() -> Region{
//        if let obj = findByName(){
//            return obj
//        }else{
//            self.save()
//            return self
//        }
//    }

    
    func findByName(success: (regions: [Region])->(), error: (erro: NSError?)->()){
        if let query = Region.query(){
            query.whereKey("name", equalTo: name)
            query.findObjectsInBackgroundWithBlock({ (objects, erro) -> Void in
                if erro == nil{
                    if let regions = objects as? [Region]{
                        success(regions: regions)
                    }
                }else{
                    error(erro: erro)
                }
            })
        }
    }
    
    func saveIfNotExiste(){
        findByName({ (regions) -> () in
            if regions.count == 0 {
                self.saveInBackground()
            }else{
                self.objectId = regions[0].objectId
            }
        }, error: { (erro) -> () in
        })
    }
   
}
