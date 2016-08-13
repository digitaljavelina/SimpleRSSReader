//
//  FeedParser.swift
//  SimpleRSSReader
//
//  Created by Michael Henry on 1/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class FeedParser: NSObject, NSXMLParserDelegate {
    
    private var rssItems: [(title: String, description: String, pubDate: String)] = []
    private var currentElement = ""
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    private var parserCompletionHandler: ([(title: String, description: String, pubDate: String)] -> Void)?
    
    func parseFeed(feedUrl: String, completionHandler: ([(title: String, description: String, pubDate: String)] -> Void)?) -> Void {
        self.parserCompletionHandler = completionHandler
        
        let request = NSURLRequest(URL: NSURL(string: feedUrl)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            // parse xml data
            
            let parser = NSXMLParser(data: data)
            parser.delegate = self
            parser.parse()
        })
        
        task.resume()
    }
    
    // MARK: - Parser delegate methods
    
    func parserDidStartDocument(parser: NSXMLParser) {
        rssItems = []
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            var rssItem = (title: currentTitle, description: currentDescription, pubDate: currentPubDate)
            rssItems += [rssItem]
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.localizedDescription)
    }

}
