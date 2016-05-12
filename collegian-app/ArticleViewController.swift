//
//  ArticleViewController.swift
//  collegian-app
//
//  Created by Alan Kane on 4/26/16.
//  Copyright © 2016 Camille Santos. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ArticleViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    
    var item: MWFeedItem! = nil

    @IBOutlet weak var articleText: UITextView!
    @IBOutlet weak var htmlView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = item.author
        
        
        Alamofire.request(.GET, item.link)
            .validate()
            .responseString { response in
                if(response.result.isSuccess) {
                    let html = response.result.value
                    if let doc = Kanna.HTML(html: html!, encoding: NSUTF8StringEncoding) {
                        print(doc.title)
                        
                        // Search for nodes by CSS
                        var htmlString = "<html>"
                        for head in doc.css("head") {
                            htmlString+=head.toHTML!
                        }
                        htmlString+="<body>"
                        
                        for section in doc.css(".entry") {
                            htmlString += section.toHTML!
                        }

                        
                        htmlString+="</body>"
                        
                        htmlString+="</html>"
                        
                        self.htmlView.loadHTMLString(htmlString, baseURL: NSURL(string: "http://www.stmaryscollegian.com/"))
                    }
                    
                }
                
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
