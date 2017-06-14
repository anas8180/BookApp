//
//  StoryViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/13/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class StoryViewController: UITableViewController {

    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var storyData:[AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        storyData = []
        
        storyAPI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Call API
    func storyAPI() {
        
        let url = String(AllVariables.baseUrl) + "status=allstories"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "GET"
        
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    if json["allnews"] != nil {
                        self.storyData = []
                        self.storyData = json.value(forKey: "allnews") as! [AnyObject]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }catch{
                    print("Error \(error)")
                }
            }
        })
        task.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if storyData == nil {
            return 0
        }
        return storyData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // Configure the cell...
        
        // Configure the cell...
        let dataDict: [String:AnyObject] = storyData[indexPath.row] as! [String:AnyObject]
        
        cell.titleLable.text = dataDict["story_name"] as? String
        cell.descLable.text = dataDict["story_info"] as? String

        // Download Image
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row+200 as AnyObject) != nil) {
            
            print("Cached image used, no need to download it")
            cell.thumbImgView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row+200 as AnyObject) as? UIImage
        }
        else {
            
            let url = dataDict["story_thumb_photo"] as! String
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let imgUrl:URL! = URL(string: urlString!)
            
            URLSession.shared.downloadTask(with: imgUrl, completionHandler: {
                (location, reponse, error) -> Void in
                
                if let data = try? Data(contentsOf: imgUrl){
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let updateCell: CustomTableViewCell =  tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
                            let img: UIImage! = UIImage(data: data)
                            updateCell.thumbImgView.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row+200 as AnyObject)
                        }
                    })
                }
                
            }).resume()
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
