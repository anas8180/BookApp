//
//  PublishersViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/13/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class PublishersViewController: UITableViewController {

    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var publishersData:[AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        publishersData = []
        
        publisherAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func publisherAPI() {
        
        let url = String(AllVariables.baseUrl) + "status=allpublishers"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "GET"
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    if json["allpublishers"] != nil {
                        self.publishersData = []
                        self.publishersData = json.value(forKey: "allpublishers") as! [AnyObject]
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
        if publishersData == nil {
            return 0
        }
        
        return publishersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let dataDict: [String:AnyObject] = publishersData[indexPath.row] as! [String:AnyObject]
        cell.titleLable.text = dataDict["publisher_name"] as? String
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
