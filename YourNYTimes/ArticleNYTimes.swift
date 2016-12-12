//
//  ArticleNYTimes.swift
//  YourNYTimes
//
//  Created by Maxim  Grozniy on 08.07.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import Foundation

class ArticleNYTimes {
    
    var main: String = ""
    var snippet: String = ""
    var original: String = "by New York Times"
    var pub_date: String = ""
    var section_name: String = ""
    var lead_paragraph: String = ""
    var image_URL: [Multimedia]?
    var web_url: String = ""
    
    
}

struct Multimedia {
    var name: String = ""
    var url: String = ""
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}


