//
//  NewsTableViewController.swift
//  SimpleRSSReader
//
//  Created by Simon Ng on 13/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var rssItems: [(title: String, description: String, pubDate: String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let feedParser = FeedParser()
        feedParser.parseFeed("https://www.apple.com/main/rss/hotnews/hotnews.rss", completionHandler: {
            (rssItems: [(title: String, description: String, pubDate: String)]) -> Void in
            self.rssItems = rssItems
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
            })
        })

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            
            return 0
        }
        
        return rssItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        
        // configure the cell
        
        if let item = rssItems?[indexPath.row] {
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.dateLabel.text = item.pubDate
        }
        
        return cell
    }
}
