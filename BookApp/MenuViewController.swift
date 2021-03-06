//
//  MenuViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/10/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController,loginDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView = UIView(frame: .zero)
        navigationController?.navigationBar.isHidden = true
    
        setMenuLayoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    //MARK: - Set Values for UI
    func setMenuLayoutUI() {
        // Check for logged in user
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: AllVariables.userData) == nil {
            return
        }
        let userData = defaults.object(forKey: AllVariables.userData) as! [String:String]
        
        if userData.isEmpty {
            loginBtn.setTitle("உள் நுழை ", for: .normal)
//            loginBtn.isUserInteractionEnabled = true
        }
        else {
            loginBtn.setTitle(userData["username"], for: .normal)
//            loginBtn.isUserInteractionEnabled = false
            downloadUserImage(urlString: userData["userimage"]!)
        }
    }
    
    // MARK: - Download Image
    func downloadUserImage(urlString: String) {
        let imgUrl:URL! = URL(string: urlString)
        URLSession.shared.downloadTask(with: imgUrl, completionHandler: {
            (location, reponse, error) -> Void in
            if let data = try? Data(contentsOf: imgUrl){
                DispatchQueue.main.async(execute: { () -> Void in
                    let img: UIImage! = UIImage(data: data)
                        self.profileImage.image = img
                        self.profileImage.layer.cornerRadius = 50
                        self.profileImage.clipsToBounds = true
                })
            }
        }).resume()
    }
    
    //MARK: - Login delegate
    func resultsFromLogin(optiontype: String) {
        if optiontype == "Success" {
            setMenuLayoutUI()
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "LoginSegue" {
            let navigationCtrl: UINavigationController = segue.destination as! UINavigationController
            let viewCtrl: LoginViewController = navigationCtrl.topViewController as! LoginViewController
            viewCtrl.delegate = self
        }
    }

}
