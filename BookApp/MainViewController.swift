//
//  MainViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/10/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate {

    @IBOutlet weak var topBarCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var pageScrollView: UIScrollView!
    var currenPageIndex = 0
    var pageViewController: UIPageViewController!
    var pages:[UIViewController]!
    
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
        topBarItems = ["நூல்கள்","எனது நூல்கள்","எழுத்தாளர்கள்"]
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "நூல்கள்")
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "எனது நூல்கள்")
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "எழுத்தாளர்கள்")
        let vc4 = self.storyboard?.instantiateViewController(withIdentifier: "பதிப்பாளர்கள்")
        let vc5 = self.storyboard?.instantiateViewController(withIdentifier: "புத்தக வகைகள்")
        let vc6 = self.storyboard?.instantiateViewController(withIdentifier: "தகவல்கள்")
        let vc7 = self.storyboard?.instantiateViewController(withIdentifier: "இன்றைய கதைகள்")

        pages = [vc1!,vc2!,vc3!,vc4!,vc5!,vc6!,vc7!]
        setUpPageViewController()
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
        tabBarSelection(index: indexPath.row)
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

    //MARK: - PageViewController Delegate Methods
    func setUpPageViewController()  {
        
        pageViewController = (storyboard?.instantiateViewController(withIdentifier: "PageViewController"))! as! UIPageViewController
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 60, width: self.view.bounds.width, height: self.view.bounds.height-60)
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        syncScrollView()
    }
    
    func syncScrollView() {
        for view in pageViewController.view.subviews {
            if view is UIScrollView {
                pageScrollView = view as! UIScrollView
                pageScrollView.delegate = self
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController) {
            if index > 0 {
                return pages[index-1]
            }
        }
        return nil
      
       /* var index = indexOfController(viewController: viewController)
        if index == NSNotFound || index == 0 {
            return nil
        }
        index -= 1
        return pages[index] */
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController) {
            if index < pages.count-1 {
                return pages[index+1]
            }
        }
        return nil
      
        /*var index = indexOfController(viewController: viewController)
        if index == NSNotFound {
            return nil
        }
        index += 1
        
        if index == pages.count {
            return nil
        }
        return pages[index] */

    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            currenPageIndex = indexOfController(viewController: (pageViewController.viewControllers?.last)!)
            print("current page index\(currenPageIndex)")
            
            selectedItem = currenPageIndex
            topBarCollectionView.reloadData()
        }
    }
    
    func indexOfController(viewController: UIViewController) -> Int {
        
        for i in 0..<pages.count {
            if viewController ==  pages[i]{
                return i
            }
        }
        return NSNotFound
    }
    
    func tabBarSelection(index: Int) {
        let tempIndex = currenPageIndex
        
        //%%% check to see if you're going left -> right or right -> left
        if index > tempIndex {
            var i = tempIndex+1
            while i <= index {
                let crtPageIdx = i
                pageViewController.setViewControllers([pages[i]], direction: .forward, animated: true, completion: { (completed) -> Void in
                    if completed {
                        self.updateCurrentPageIndex(index: crtPageIdx)
                    }
                })
                i += 1
            }
        }
        
        //%%% this is the same thing but for going right -> left
        else if index < tempIndex {
            var i = tempIndex-1
            while i >= index {
                let crtPageIdx = i
                pageViewController.setViewControllers([pages[i]], direction: .forward, animated: true, completion: { (completed) -> Void in
                    if completed {
                        self.updateCurrentPageIndex(index: crtPageIdx)
                    }
                })
                i -= 1
            }
        }
    }
    
    func updateCurrentPageIndex(index: Int) {
        currenPageIndex = index
        print("current page index\(currenPageIndex)")
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
