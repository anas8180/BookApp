//
//  MainViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/10/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var topBarCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var topBarItems:[String]!
    var selectedItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        topBarItems = ["நூல்கள்","எனது நூல்கள்","எழுத்தாளர்கள்","பதிப்பாளர்கள்","புத்தக வகைகள்","தகவல்கள்","இன்றைய கதைகள்"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topBarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TopBarCollectionViewCell
        
        cell.titleLable.text = topBarItems[indexPath.row]
        
        if indexPath.row == selectedItem {
            cell.tabIndicator.isHidden = false
        }
        else {
            cell.tabIndicator.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        selectedItem = indexPath.row
        topBarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = 90
        switch indexPath.row {
        case 0:
            width = 90
            break
        case 1,2,3:
            width = 130
            break
        case 4:
            width = 150
            break
        case 5:
            width = 110
            break
        case 6:
            width = 170
            break
        default:
            break
        }
        let size = CGSize(width: width, height: 60)
        
        return size
        
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
