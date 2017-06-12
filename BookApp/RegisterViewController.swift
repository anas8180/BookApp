//
//  RegisterViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/11/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var userData: [AnyObject]!
    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!

    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitBtn.layer.cornerRadius = 2.0
        
        self.cache = NSCache()
        self.userData = []
        session = URLSession.shared
        task = URLSessionDownloadTask()

        callApi(url: "http://noorkadal.co.in/bookapi.php?")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitTapped(_ sender: Any) {
    }
    @IBAction func loginTaped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Login API Call
    func callApi(url: String) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("public_user_login", forHTTPHeaderField: "status")
        request.addValue("test", forHTTPHeaderField: "username")
        request.addValue("test", forHTTPHeaderField: "userpass")

        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    print(dic)
                }catch{
                    print("something went wrong, try again")
                }
            }
        })
        task.resume()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
