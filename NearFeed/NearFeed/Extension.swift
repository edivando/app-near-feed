//
//  Extension.swift
//  NearFeed
//
//  Created by Edivando Alves on 7/20/15.
//  Copyright (c) 2015 J7ss. All rights reserved.
//


import Parse

extension PFFile{
    
    func image(callback:(image: UIImage?)->()){
        getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data{
                callback(image: UIImage(data: data))
            }
            callback(image: nil)
        }
    }
}

extension NSDate {
    func dayForYear() -> Int{
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let day = gregorian?.ordinalityOfUnit(.CalendarUnitDay, inUnit: .CalendarUnitYear, forDate: self){
            return day
        }
        return 0
    }
    
    func dateFormat() -> String{
        let timeDif = NSDate().dayForYear() - dayForYear()
        var formatter = NSDateFormatter()
        
        if timeDif == 0{
            formatter.dateFormat = "HH:mm a"
            return formatter.stringFromDate(self)
        }else if timeDif < 8{
            formatter.dateFormat = "EEEE"
            return formatter.stringFromDate(self)
        }else{
            formatter.dateFormat = "dd/MM/yy"
            return formatter.stringFromDate(self)
        }
    }
}

