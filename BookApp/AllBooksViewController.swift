//
//  AllBooksViewController.swift
//  BookApp
//
//  Created by MB Air 11 on 6/13/17.
//  Copyright © 2017 oms. All rights reserved.
//

import UIKit

class AllBooksViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var sliderTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)

    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var bannerImgs:[AnyObject]!
    var booksData:[AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bannerImgs = []
        booksData = []
        
        self.cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        sliderTitle.text = ""
        
        bannerImageApi()
        booksApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Configure ScrollView and PageControl
    func configureBannerView() {
        self.pageControl.numberOfPages = bannerImgs.count

        for index in 0..<bannerImgs.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIImageView(frame: frame)
            subView.clipsToBounds = true
            subView.contentMode = .scaleToFill
            if self.cache.object(forKey: index as AnyObject) != nil {
                subView.image = self.cache.object(forKey: index as AnyObject) as? UIImage
            }
            else {
                let url = bannerImgs[index].object(forKey: "book_slider_photo")
                downloadUserImage(url: url as! String, index: index, imageView: subView)
            }
            
            let title = bannerImgs[0].object(forKey: "book_name")
            sliderTitle.text = title as? String

            self.scrollView .addSubview(subView)
        }
        let totalCount: CGFloat = CGFloat(bannerImgs.count)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * totalCount,height: self.scrollView.frame.size.height)
    }
    
    func bannerImageApi() {
       
        let url = String(AllVariables.baseUrl) + "status=book_sliders"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "GET"
        
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    if json["detail"] != nil {
                        self.bannerImgs = []
                        self.bannerImgs = json.value(forKey: "detail") as! [AnyObject]
                        DispatchQueue.main.async {
                            self.configureBannerView()
                        }
                    }
                }catch{
                    print("Error \(error)")
                }
            }
        })
        task.resume()
    }
    @IBAction func pageChanges(_ sender: Any) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
        let title = bannerImgs[Int(pageControl.currentPage)].object(forKey: "book_name")
        sliderTitle.text = title as? String
    }
    func downloadUserImage(url: String,index: Int, imageView: UIImageView) {
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let imgUrl:URL! = URL(string: urlString!)
        URLSession.shared.downloadTask(with: imgUrl, completionHandler: {
            (location, reponse, error) -> Void in
            if let data = try? Data(contentsOf: imgUrl){
                DispatchQueue.main.async(execute: { () -> Void in
                    let img: UIImage! = UIImage(data: data)
                    imageView.image = img
                    self.cache.setObject(img, forKey: index as AnyObject)
                })
            }
            print("\(String(describing: error))")
        }).resume()
    }
    
    //MARK:- Books API
    func booksApi() {
        
        let url = String(AllVariables.baseUrl) + "status=allbooklists"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString!)!)
        request.httpMethod = "GET"
        
        task = session.downloadTask(with: request, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let data:Data! = try? Data(contentsOf: location!)
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
                    if json["allbooks"] != nil {
                        self.booksData = []
                        self.booksData = json.value(forKey: "allbooks") as! [AnyObject]
                        DispatchQueue.main.async {
                            self.booksCollectionView.reloadData()
                        }
                    }
                }catch{
                    print("Error \(error)")
                }
            }
        })
        task.resume()
    }
    
    //MARK: - CollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BookCollectionViewCell
        
        configureCellBorder(cell: cell)
        
        let dataDict: [String:AnyObject] = booksData[indexPath.row] as! [String:AnyObject]
        cell.bookTitleLable.text = dataDict["book_name"] as? String

        let originalPrice = "₹" + String(dataDict["book_original_price"] as! String)
        let price = "₹" + String(dataDict["book_price"] as! String)
        
        let attrString1 = NSAttributedString(string: price, attributes: nil)
//        let attrString2 = NSAttributedString(string: originalPrice, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        
        let attrString2: NSMutableAttributedString =  NSMutableAttributedString(string: originalPrice)
        attrString2.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attrString2.length))
        
        let attrString3 = NSAttributedString(string: " ", attributes: nil)
        let finalPriceString = NSMutableAttributedString()
        finalPriceString.append(attrString1)
        finalPriceString.append(attrString3)
        finalPriceString.append(attrString2)
        
        cell.priceLable.attributedText = finalPriceString
        
        // Download Image
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row+100 as AnyObject) != nil) {
            
            print("Cached image used, no need to download it")
            cell.thumbImgView.image = self.cache.object(forKey: (indexPath as NSIndexPath).row+100 as AnyObject) as? UIImage
        }
        else {
            
            let url = dataDict["book_photo"] as! String
            
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let imgUrl:URL! = URL(string: urlString!)
            
            URLSession.shared.downloadTask(with: imgUrl, completionHandler: {
                (location, reponse, error) -> Void in
                
                if let data = try? Data(contentsOf: imgUrl){
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if let updateCell: BookCollectionViewCell =  collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell {
                            let img: UIImage! = UIImage(data: data)
                            updateCell.thumbImgView.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row+100 as AnyObject)
                        }
                    })
                }
                
            }).resume()
        }

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        var width = 90
//        switch indexPath.row {
//        case 0:
//            width = 90
//            break
//        case 1,2,3:
//            width = 130
//            break
//        case 4:
//            width = 150
//            break
//        case 5:
//            width = 110
//            break
//        case 6:
//            width = 170
//            break
//        default:
//            break
//        }
        let size = CGSize(width: 120, height: 200)
        return size
        
    }
    
    func configureCellBorder(cell: BookCollectionViewCell)  {
        // Content Border
       /* cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1.0
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false */

        cell.layer.cornerRadius = 5.0;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = UIColor.darkGray.cgColor;

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
extension AllBooksViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)

        let title = bannerImgs[Int(pageNumber)].object(forKey: "book_name")
        sliderTitle.text = title as? String
    }
}
