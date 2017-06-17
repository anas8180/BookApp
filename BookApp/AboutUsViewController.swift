//
//  AboutUsViewController.swift
//  BookApp
//
//  Created by Asaraa on 6/14/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

<<<<<<< HEAD
class AboutUsViewController: UIViewController,UIScrollViewDelegate {

     @IBOutlet var aboutusLabel: UILabel!
    
    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var authorData:[AnyObject]!
    var pageScrollView: UIScrollView!
    
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        authorData = []
     //authorAPI()
        
                pageScrollView = scrollView!
        pageScrollView.delegate = self
        
=======
class AboutUsViewController: UIViewController {

     @IBOutlet var aboutusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
>>>>>>> c0f3812e54d90e2bd15804b975ae05bf5de45be3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
<<<<<<< HEAD
    func authorAPI() {
        
        let url = String(AllVariables.baseUrl) + "status=aboutus"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "GET"
        
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    
                    if json["allnews"] != nil {
                        self.authorData = []
                        self.authorData = json.value(forKey: "allnews") as! [AnyObject]
                        DispatchQueue.main.async {
                          self.aboutusLabel.text = (json as AnyObject).object(forKey: "content") as? String
                         }
                    }
                }catch{
                    print("Error \(error)")
                }
            }
        })
        task.resume()
    }

    @IBAction func backTapped(_ sender: Any) {
        
=======
    @IBAction func backTapped(_ sender: Any) {
>>>>>>> c0f3812e54d90e2bd15804b975ae05bf5de45be3
        dismiss(animated: true, completion: nil)
    }

    /*
<<<<<<< HEAD
     
     
     self.userNameLbl.text = (dataDict as AnyObject).object(forKey: "name") as? String
     
=======
>>>>>>> c0f3812e54d90e2bd15804b975ae05bf5de45be3
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
