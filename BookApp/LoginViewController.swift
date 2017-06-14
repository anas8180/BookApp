//
//  LoginViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/11/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

protocol loginDelegate {
    func resultsFromLogin(optiontype: String)
}
class LoginViewController: UIViewController {

    var userData: [AnyObject]!
    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!

    var delegate: loginDelegate?
    
    @IBOutlet weak var passwrodTxtFld: UITextField!
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitBtn.layer.cornerRadius = 2.0
        
        self.cache = NSCache()
        self.userData = []
        session = URLSession.shared
        task = URLSessionDownloadTask()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func submitTapped(_ sender: Any) {
        callApi(appendUrl: AllVariables.baseUrl)
    }
    
    // MARK: - Login API Call
    func callApi(appendUrl: String) {
        
        let url = String(appendUrl) + "status=public_user_login" + "&username=" + String(usernameTxtFld.text!) + "&userpass=" + String(passwrodTxtFld.text!)
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "POST"
        
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    print(json)
                    
                    if json["user_details"] != nil {
                        
                        let arrayData: NSArray = json.value(forKey: "user_details") as! NSArray
                        let userData:[String:String] = arrayData.object(at: 0) as! [String : String]
                        let defaults = UserDefaults.standard
                        defaults.set(userData, forKey: AllVariables.userData)
                        defaults.synchronize()
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.resultsFromLogin(optiontype: "Success")
                    }
                    else {
                        self.showAlert(titleVal: "Message", messageVal: json["message"]! as! String)
                    }
                    
                }catch{
                    print("something went wrong, try again")
                    self.showAlert(titleVal: "Message", messageVal: "something went wrong, try again")
                }
            }
        })
        task.resume()
        
    }
    
    // MARK: - Show Alert
    func showAlert(titleVal: String, messageVal: String) {
        let alertCtrl = UIAlertController(title: titleVal, message: messageVal, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { aciton -> Void in
            
        }
        alertCtrl.addAction(okAction)
        self.present(alertCtrl, animated: true, completion: nil)
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
