//
//  Settings.swift
//  YourNYTimes
//
//  Created by Maxim  Grozniy on 11.07.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import Foundation
import UIKit

var nytimesURL: String = "https://api.nytimes.com/svc/search/v2/articlesearch.json?"
var articleSearchAPIKey: String = "api-key=e75fd3c9a1c04a0f8d652b28c64def9c"

struct Settings {
    var lucen: String = ""
    var pagesValue: String = ""
    var fromDate: String = ""
    var toDate: String = ""
    var rangeWay: String = ""
    
    func getString() -> String {
        var searchRequestString = ""
        searchRequestString += nytimesURL + articleSearchAPIKey
        
        if lucen.characters.count > 0 {
            searchRequestString += "&fq=\(lucen)"
        }
        
        if pagesValue.characters.count > 0 {
            searchRequestString += "&page=\(pagesValue)"
        }
        
        if fromDate.characters.count > 0 {
            searchRequestString += "&begin_date=\(fromDate)"
        }
        
        if toDate.characters.count > 0 {
            searchRequestString += "&end_date=\(toDate)"
        }
        
        if rangeWay.characters.count > 0 {
            searchRequestString += "&sort=\(rangeWay)"
        }
        
        return searchRequestString as String
    }
    
}

class Support {
    
    class func loadCommonSettings() {
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "lucen") != nil) {
            let lucen_D = defaults.string(forKey: "lucen")
            settings.lucen = lucen_D!
        }
        
        if (defaults.object(forKey: "pagesValue") != nil) {
            let pagesValue_D = defaults.string(forKey: "pagesValue")
            settings.pagesValue = pagesValue_D!
        }
        
        if (defaults.object(forKey: "fromDate") != nil) {
            let fromDate_D = defaults.string(forKey: "fromDate")
            settings.fromDate = fromDate_D!
        }
        
        if (defaults.object(forKey: "toDate") != nil) {
            let toDate_D = defaults.string(forKey: "toDate")
            settings.toDate = toDate_D!
        }
        
        if (defaults.object(forKey: "rangeWay") != nil) {
            let rangeWay_D = defaults.string(forKey: "rangeWay")
            settings.rangeWay = rangeWay_D!
        }
    }
    
    
    class func getAlert(_ alTitle: String, alMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: alTitle, message: alMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        return alert
    }
}
