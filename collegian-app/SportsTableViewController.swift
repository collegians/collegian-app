//
//  SportsTableViewController.swift
//  collegian-app
//
//  Created by Camille Santos on 4/27/16.
//  Copyright © 2016 Camille Santos. All rights reserved.
//

import UIKit

class SportsFeedTableViewController: UITableViewController, MWFeedParserDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var tableview: UITableView!
    
    var feedItems = [MWFeedItem]()
    
    func request() {
        let url = NSURL(string: "http://stmaryscollegian.com/category/sports/feed")
        let feedParser = MWFeedParser(feedURL: url)
        feedParser.delegate = self
        feedParser.parse()
    }
    
    // MARK: - Feed Parser Delegate
    
    func feedParserDidStart(parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info)
        self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.rowHeight = UITableViewAutomaticDimension
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        request()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return feedItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) as! ArticleTableViewCell
        
        let item = feedItems[indexPath.row] as MWFeedItem
        
        cell.titleLabel?.text = item.title
        
        // Convert NSDate to String to display in UILabel
        let date = item.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let pubDate = dateFormatter.stringFromDate(date)
        cell.dateLabel?.text = pubDate
        
        cell.authorLabel?.text = item.author
        
        // Remove html characters from description feed item
        var summary = item.summary
        summary = summary.stringByReplacingOccurrencesOfString("&#124;", withString: "|")
        summary = summary.stringByReplacingOccurrencesOfString("&#8220;", withString: "\"")
        summary = summary.stringByReplacingOccurrencesOfString("&#8221;", withString: "\"")
        summary = summary.stringByReplacingOccurrencesOfString("&#8217;", withString: "'")
        summary = summary.stringByReplacingOccurrencesOfString("&#8230;", withString: "...\n")
        cell.summaryLabel?.text = summary
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // performSegueWithIdentifier("ArticleViewSegue", sender: self)
        
        let item = feedItems[indexPath.row] as MWFeedItem
        
        let webBrowser = KINWebBrowserViewController()
        let url = NSURL(string: item.link)
        
        webBrowser.loadURL(url)
        
        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ArticleViewSegue" {
            let articleViewController = segue.destinationViewController as! ArticleViewController
            let tableView = view as! UITableView
            let indexPath = tableView.indexPathForSelectedRow!
            let item = feedItems[indexPath.row]
            articleViewController.item = item
        }
    }
    
}
