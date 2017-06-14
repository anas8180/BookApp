//
//  AboutUsViewController.swift
//  BookApp
//
//  Created by Asaraa on 6/14/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

     @IBOutlet var aboutusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
