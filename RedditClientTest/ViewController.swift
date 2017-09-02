//
//  ViewController.swift
//  RedditClientTest
//
//  Created by Loren Levine on 8/21/17.
//  Copyright © 2017 RedditClientTest. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //Create global array to put responseData into for TableView
    var htmlResponseString = String()
    var responseDataArray = [String]()
    var parsedDataArray = [String]()
    var responseDataLinkArray = [String]()
    
    //var urlString = "https://www.reddit.com/top/"
    var nextResultsString = String()
    
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbarView: UIView!
    @IBOutlet var viewForFullImage: UIView!
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var selectedArticleInt = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("\n(VIEW DID LOAD)\n")
    
        //GET SCREEN SIZE//
        let screenSizeWidth = UIScreen.main.bounds.width
        let screenSizeHeight = UIScreen.main.bounds.height
        print("ScreenSizeWidth:", screenSizeWidth) //7: 667.0    7+: 736
        print("ScreenSizeHeight:", screenSizeHeight)
        var deviceModel = String()
        if screenSizeHeight == 667 {
            deviceModel = "iPhone6"
        } else if screenSizeHeight == 736 {
            deviceModel = "iPhone6+"
        }
        print("DeviceModel:", deviceModel)
        print("\n")
        
        
        
        ////POSITION UI ELEMENTS////
        //toolbarView.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 44)
        toolbarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        toolbarView.layer.shadowRadius = 4
        toolbarView.layer.shadowOpacity = 0.3
 
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Auto-Sizing Cell Heights
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        
        //TODO:Test this on different sizes
        //tableView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64) //(OriginX, OriginY, Height, Width
        
        
        
        
        
        //POSITION SUBVIEW FOR FULL IMAGE VIEW & BUTTONS//
        //viewForFullImage.frame = CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) //(OriginX, OriginY, Height, Width
        viewForFullImage.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.86)
        viewForFullImage.isHidden = true
        
        
        //articleImageView.frame = CGRect(x: 50, y: 100, width: UIScreen.main.bounds.width-60, height: UIScreen.main.bounds.height-320)
        //articleImageView.center = CGPoint(x:UIScreen.main.bounds.width/2, y:(UIScreen.main.bounds.height/2)-80)
        articleImageView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        articleImageView.layer.cornerRadius = 8
        //articleImageView.clipsToBounds = true
        articleImageView.layer.shadowOffset = CGSize(width: 2, height: 6)
        articleImageView.layer.shadowRadius = 8
        articleImageView.layer.shadowOpacity = 0.8
        
        //activityIndicator.center = CGPoint(x:UIScreen.main.bounds.width/2, y:(UIScreen.main.bounds.height/2)-80)
        
        
        
        /*
        if deviceModel == "iPhone6" {
            closeButton.center = CGPoint(x:88, y:500)
            saveButton.center = CGPoint(x:265, y:500)
        } else if deviceModel == "iPhone6+" {
            closeButton.center = CGPoint(x:112, y:540)
            saveButton.center = CGPoint(x:288, y:540)
        }
        */
        
        
        
        
        let urlString = "https://www.reddit.com/top/"
        ////CHECK IF DATA CONNECTION AVAILABLE////
        if ConnectionCheck.isConnectedToNetwork() {
            print("Data Connection: YES")
            //getData()
            performSelector(inBackground: #selector(getData(url:)), with: urlString)
            //performSelector(inBackground: #selector(jsonData), with: nil)
        } else{
            print("Data Connection: NO")
            //Show AlertView
        }
        
        
        
        
        
    }

    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GET URL DATA //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
   
    //NOT WORKING YET///
    
    func jsonData() {
        print("\n\n(JSON DATA)")
        
        
        
        /*
        
        //Method 4
        print("METHOD 4")
        let url4 = URL(string: "https://www.reddit.com/top/.json")
        let session4 = URLSession.shared // or let session = URLSession(configuration: URLSessionConfiguration.default)
        if let usableUrl = url4 {
            let task4 = session4.dataTask(with: usableUrl, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        //print("StringData: ",stringData) //JSONSerialization
                    }
                }
            })
            task4.resume()
        }
        
        
        //Method 3
        print("METHOD 3")
        let session3 = URLSession.shared
        let url3 = URL(string: "https://www.reddit.com/top/.json")!
        let task3 = session3.dataTask(with: url3) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                //print("StringData: ",string) //JSONSerialization
                
            }
            
            
        }
        task3.resume()
        
        */
 
        
        
        
        
        
        //TODO: Come back to this- JSON Parsing
        //Method 6
        print("METHOD 6")
        let url6 = URL(string: "https://www.reddit.com/top/.json") //
        //let url6 = URL(string: "http://jsonplaceholder.typicode.com/users/2")
        if let usableUrl = url6 {
            let request = URLRequest(url: usableUrl)
            let task6 = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        //print("StringData:\n",stringData) //JSONSerialization
                        
                        print("\nParse with Serializer...")
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any] {
                            
                            print("\n______________________________IndiValue________________________________________")
                            if let name = dictionary["data"] as? String {
                                // access individual value in dictionary
                                //print("DictionaryValue: ")
                                //print("\nValue from Dict:")
                                //print(name)
                            }
                            
                            print("\n___________________________All Keys/Values_____________________________________")
                            for (key, value) in dictionary {
                                // access all key / value pairs in dictionary
                                print(key," :: ",value)
                                //print("Key:Value", key)
                            }
                        
                            print("\n_____________________________Nested Values_____________________________________")
                            if let nestedDictionary = dictionary["data:children:data"] as? [String: Any] {
                                // access nested dictionary values by key
                                print("NestedDictionary:", nestedDictionary)
                                print(nestedDictionary)
                                
                                //Get sub-value
                                if let dict1 = nestedDictionary["data:children:data"] as? [String: Any] {
                                    // access nested dictionary values by key
                                    //print("Dict1:", dict1)
                                }
                            }
                            
                        }
                    }
                }
                
                
                
                
                
            })
            task6.resume()
        }
        
        
        //Way to get Nested Values
        /*
        if let pictureDict = snapshot.value["picture"] as? [String:AnyObject]{
            
            if let dataDict = pictureDict.value["data"] as? [String:AnyObject]{
                
                self.pictureURL =  dataDict.value["url"] as! String
                
            }
        }
        */
        
        
        
        
    }

    
    //PAGING: Use global variable for passing & updating link
    //TODO: Try using RSS feed for easier parsing
    
    
    func getData(url:String) {
        print("\n\n(GET DATA)")
        
        print("URL String:", url) //Prints out correctly here.
        //url = url.replacingOccurrences(of: " ", with: "")
        //let dispatchQueue = DispatchQueue(label: "com.app.dispatchQueue", qos: .utility, attributes: .concurrent)
        //dispatchQueue.async {
        let trimmedURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if let dataURL = URL(string: trimmedURL) { //"https://www.reddit.com/top/"
            //Only crashes after method is called 2nd time with updated 'urlString'
            let task = URLSession.shared.dataTask(with: dataURL) { (data, response, error) in
                if let data = data,
                    let htmlResponse = String(data: data, encoding: String.Encoding.utf8) {
                    //print("Response:", htmlResponse)
                    if htmlResponse.contains("page not found") {
                        print("Response Data Not Valid")
                        let myAlert = UIAlertController(title: "Error!", message: "URL Data Not Valid", preferredStyle: UIAlertControllerStyle.alert)
                        myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(myAlert, animated: true, completion: nil)
                    } else {
                        print("Response Data is Valid")
                        self.htmlResponseString = htmlResponse
                        self.parseData()
                    }
                }
            }
        
            task.resume()
        } else {
            print("DataURL is nil")
        }
        //} //End DispatchQueue

    
        
    }
    
   
    func getDataTest(url:String) {
        print("\n\n(GET DATA TEST)", url)
    }
    
    
    
    func parseData() {
        print("\n\n(PARSE DATA)")
        
        //print(htmlResponseString)
        
        //// MANUAL HTML PARSING ////
        //Create Array from String//
        responseDataArray = htmlResponseString.components(separatedBy: "data-rank=") //Split Full HTML Response by Article Postings
        
        
        //This can be done in TableView Delegate Method...
        //Print out array
        print("\nResponse DATA ARRAY:")
        var i = 1
        while i < responseDataArray.count {
            //print("•", responseDataArray[i])
            print("\n")

            //MANUALLY PARSE HTML RESPONSE DATA//
            let articleStringFull = responseDataArray[i] //Get full response data for each article
            
            //print("\n")
            //print("[\(i)]")
            //Extract Rank// data-rank="1" data-comments
            let rankArray = articleStringFull.components(separatedBy: " data-comments")
            var rankString = rankArray[0]
            rankString = rankString.replacingOccurrences(of: "\"", with: "")
            print("RANK: ", rankString)
            
            
            //Extract TITLE
            let titleArray = articleStringFull.components(separatedBy: "rel=\"\" >")
            var titleString = titleArray[2]
            let titleArray2 = titleString.components(separatedBy: "<") //Remove text after Element
            titleString = titleArray2[0]
            titleString = titleString.replacingOccurrences(of: "&quot", with: "")
            print("TITLE: ", titleString)
            
            
            //Extract AUTHOR
            let authorArray = articleStringFull.components(separatedBy: "class=\"author")
            var authorString = authorArray[1]
            let authorArray2 = authorString.components(separatedBy: "<") //Remove text after Element
            authorString = authorArray2[0]
            let authorArray3 = authorString.components(separatedBy: ">") //Remove additional text before Element
            authorString = authorArray3[1]
            print("AUTHOR: ", authorString)
            
            //Extract COMMENT COUNT
            let commentsArray = articleStringFull.components(separatedBy: "nofollow\" >")
            var commentsString = commentsArray[1]
            let commentsArray2 = commentsString.components(separatedBy: "<") //Remove text after Element
            commentsString = commentsArray2[0]
            print("COMMENTS: ", commentsString)
            
            //Extract TIMESTAMP
            let timeArray = articleStringFull.components(separatedBy: "live-timestamp\">")
            var timeString = timeArray[1]
            let timeArray2 = timeString.components(separatedBy: "<") //Remove text after Element
            timeString = timeArray2[0]
            print("TIME: ", timeString)
            
            
            //Extract THUMBNAIL URL //Use "rel="
            //If no thumbnail, "src" won't exist. Need to use different string
            //let thumbArray = articleStringFull.components(separatedBy: "img src=\"//") //Use "rel="
            let thumbArray = articleStringFull.components(separatedBy: "rel=\"\" >")
            var thumbString = thumbArray[1]
            //let thumbArray2 = thumbString.components(separatedBy: "\"") //Remove text after Element
            let thumbArray2 = thumbString.components(separatedBy: "<div")
            thumbString = thumbArray2[0] //String where thumnail src should be.
            //print("ThumbString: ", thumbString)
            
            //Test if img src exists
            if thumbString.contains(".jpg") {
                let thumbArray3 = thumbString.components(separatedBy: "\"")
                thumbString = thumbArray3[1]
                thumbString = thumbString.replacingOccurrences(of: "//", with: "")
                thumbString = "http://" + thumbString
                print("THUMBURL: ", thumbString)
            } else {
                //print("NO Image Source!")
                thumbString = "NO IMAGE"
                print("THUMBURL: ", thumbString)
            }
            
            //Extract Full Quality Image
            var fullImageString = String()
            if thumbString=="NO IMAGE" {
                fullImageString = "NO IMAGE"
                print("FULLIMAGEURL: ", fullImageString)
            } else {
                if articleStringFull.contains("media-preview-content&quot;&gt; &lt;a href=&quot;") {
                    let fullImageArray = articleStringFull.components(separatedBy: "media-preview-content&quot;&gt; &lt;a href=&quot;")
                    fullImageString = fullImageArray[1]
                    let fullImageArray2 = fullImageString.components(separatedBy: "&quot")
                    fullImageString = fullImageArray2[0]
                    fullImageString = fullImageString.replacingOccurrences(of: ".gifv", with: ".gif")
                    print("FULLIMAGEURL: ", fullImageString)
                } else {
                    //If full quality image can't be found, will use thumbnail image.
                    fullImageString = thumbString
                    print("FULLIMAGEURL: ", fullImageString)
                }
            }
            
            
            
            
            
            //Add Parsed Strings to New Array for Access in TableView
            let parsedArticleData = rankString + " [•] " + titleString + " [•] " + authorString + " [•] " + commentsString + " [•] " + timeString + " [•] " + thumbString + " [•] " + fullImageString
            print("\nParsedArticleData: ", parsedArticleData)
            parsedDataArray.append(parsedArticleData)
            
            
            
            
            i = i+1
        }
        
        
        ////Extract Link for Next Page////
        
        //class="next-button"><a href="https://www.reddit.com/top/?count=25&amp;after=t3_6xduef"
        
        
        responseDataLinkArray = htmlResponseString.components(separatedBy: "next-button") //Split Full HTML Response by Article Postings
        nextResultsString = responseDataLinkArray[1]
        //print("\nNextLinkString: ", nextLinkString)
        let nextLinkArray = nextResultsString.components(separatedBy: "rel=\"nofollow next\"")
        nextResultsString = nextLinkArray[0]
        //print("NextLinkString: ", nextLinkString)
        nextResultsString = nextResultsString.replacingOccurrences(of: "\"", with: "")
        nextResultsString = nextResultsString.replacingOccurrences(of: "amp;", with: "")
        nextResultsString = nextResultsString.replacingOccurrences(of: "><a href=", with: "")
        print("\nNextLinkString: ", nextResultsString)
        //urlString = nextResultsString
        
        print("\n\n")
        
        
        //tableView.reloadData()
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }

    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////// TABLE VIEW //////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arrayCount = self.parsedDataArray.count + 1
        
        return arrayCount
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //CustomCell Implementation
        let cellReuseIdentifier = "Cell"
        let customCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomCell
        
        //Cell Design
        //customCell.cellLabel.textColor = CGColor
        customCell.thumbailImage.layer.cornerRadius = 5
        //customCell.thumbailImage.clipsToBounds = true
        
        
        
        //ParsedDataArray Objects:
        //[0]RANK
        //[1]TITLE
        //[2]AUTHOR
        //[3]COMMENTS
        //[4]TIME
        //[5]THUMBNAIL
        //[6]FULLIMAGE
        
        
        if indexPath.row < parsedDataArray.count {
            //GET PRE-PARSED DATA ARRAY//
            let articleDataString = parsedDataArray[indexPath.row]
            let articleDataArray = articleDataString.components(separatedBy:" [•] ")
            
            
            //SET VALUES TO UI LABELS//
            customCell.rankLabel.text = "Rank: " + articleDataArray[0]
            customCell.cellLabel.text = articleDataArray[1]
            customCell.authorLabel.text = articleDataArray[2]
            //customCell.commentsLabel.text = articleDataArray[3]
            customCell.timeLabel.text = articleDataArray[4]
            let thumbString = articleDataArray[5]
            customCell.loadNextLabel.text = ""
            customCell.thumbailImage.isHidden = false
            
            //CHECK IF POST HAS AN IMAGE//
            if thumbString == "NO IMAGE" {
                //No Image Available
                print(thumbString)
            } else {
                //Image Is Available
                //CONCURRENT LOADING//
                let url = URL(string: thumbString)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        customCell.thumbailImage.image = UIImage(data: data!)
                    }
                }
                //Add shadow effect for posts with images
                customCell.thumbailImage.layer.shadowOffset = CGSize(width: 1, height: 2)
                customCell.thumbailImage.layer.shadowRadius = 2
                customCell.thumbailImage.layer.shadowOpacity = 0.4
                
            }

        }else {
            customCell.loadNextLabel.text = "(Pull Up to Load Next Results)"
            customCell.rankLabel.text = ""
            customCell.cellLabel.text = ""
            customCell.authorLabel.text = ""
            customCell.timeLabel.text = ""
            customCell.thumbailImage.image = nil
            customCell.thumbailImage.isHidden = true
        }
        
        
        
        
        
        
        //GCD TUTORIAL: https://www.appcoda.com/grand-central-dispatch/
        
        
        
        return customCell
        
    }
    
    
    
    //TODO: Paging?
    //TODO: Save App State
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\n(TableView:DidSelectRow) \(indexPath.row).")
        
        if indexPath.row < parsedDataArray.count {
            activityIndicator.isHidden = false
            self.saveButton.isEnabled = false
            
            
            //GET PRE-PARSED DATA ARRAY//
            let articleDataString = parsedDataArray[indexPath.row]
            let articleDataArray = articleDataString.components(separatedBy:" [•] ")
            
            selectedArticleInt = indexPath.row
            print("Article#: ", selectedArticleInt + 1)
            
            //SET VALUES TO UI LABELS//
            //customCell.cellLabel.text = articleDataArray[0]
            //customCell.authorLabel.text = articleDataArray[1]
            //customCell.commentsLabel.text = articleDataArray[2]
            //customCell.timeLabel.text = articleDataArray[3]
            let imageURLString = articleDataArray[5]
            print("SelectedImageURL:", imageURLString)
            
            
            if imageURLString == "NO IMAGE" {
                print(imageURLString)
                //Don't open Image View
            } else {
                let url = URL(string: imageURLString)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.articleImageView.image = UIImage(data: data!)
                        //self.articleImageView.image = UIImage(data: data as Data)
                        self.activityIndicator.isHidden = true
                        self.saveButton.isEnabled = true
                    }
                }
                
                
                //Delay or use loading graphic
                //Open View with ImageView
                viewForFullImage.isHidden = false
                
            }
         
            
        } else{
            print("Load Next Results Request...")
            performSelector(inBackground: #selector(getData(url:)), with: nextResultsString)
        }
        
        
        
    }
    
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("\n\n(scrollViewWillBeginDragging)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewOffset = scrollView.contentOffset.y
        //print("\nScrollOffset", scrollViewOffset)
        
        let scrollViewHeight = scrollView.bounds.height
        //print("ScrollViewHeight", scrollViewHeight)
        
        let scrollViewContentHeight = scrollView.contentSize.height - scrollViewHeight //Account for visible size
        //print("ScrollViewContentHeight", scrollViewContentHeight)
        
        let scrollOffsetValue = scrollViewContentHeight - scrollViewOffset
        //print("ScrollOffsetValue", scrollOffsetValue)
        //Value should be 0 when scrolled to bottom
        //Values will be negative when force-dragged further..... THEN load next list of results
        
        if scrollOffsetValue < -150.0 { //Larger negative values increase requred drag/pull strength
            print("\n(scrollViewDidScroll)")
            print("PullToLoad Request, Will get next page of results.")
            
            
            performSelector(inBackground: #selector(getData(url:)), with: nextResultsString)
        }
    }
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        //print("\n\n(scrollViewDidScrollToTop)")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //Let go of touch
        //print("\n\n(scrollViewWillBeginDecelerating)")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ///print("\n\n(scrollViewDidEndDecelerating)")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //While touching screen
        //print("\n\n(scrollViewWillEndDragging)")
        let dragVelocity = velocity
        //print("Velocity: ", dragVelocity)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //While touching screen
        //print("\n\n(scrollViewDidEndDragging)")
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //print("\n\n(scrollViewDidEndScrollingAnimation)")
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func closeImageView() {
        print("\n\n(CLOSE IMAGE VIEW)")
        
        viewForFullImage.isHidden = true
        articleImageView.image = nil
    }
    
    
    
    @IBAction func saveImageFromURL() {
        print("\n\n(SAVE IMAGE FROM URL)")
    
        //print("SelectedImageINT: ", selectedImageInt)
        
        let articleDataString = parsedDataArray[selectedArticleInt]
        let articleDataArray = articleDataString.components(separatedBy:" [•] ")
        
        let imageURLString = articleDataArray[5] //TODO: Get full quality image?
        print("SelectedImageURL:", imageURLString)
        
        
        UIImageWriteToSavedPhotosAlbum(articleImageView.image!, self, nil, nil) //Try setting ComplettionSelector (3rd parameter)
        
        
        viewForFullImage.isHidden = true
        articleImageView.image = nil
        
        
        let myAlert = UIAlertController(title: "Photo Saved!", message: ":)", preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

