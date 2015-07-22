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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


class Color{
    static let blue     = UIColor(netHex: 0x334D5C)
    static let green    = UIColor(netHex: 0x45B29D)
    static let yellow   = UIColor(netHex: 0xEFC94C)
    static let orange   = UIColor(netHex: 0xE27A3F)
    static let red      = UIColor(netHex: 0xDF5A49)
    
    static let gray     = UIColor(netHex: 0x90A0A8)
}






