//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by Harry on 2/24/17.
//  Copyright © 2017 Harry. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    @IBOutlet weak var response: UITextView!
    @IBOutlet var txtMovieName: UITextField!
    @IBOutlet var tblResponse: UITableView!
    @IBOutlet var btnSelectMovie: UIButton!
    var responseArray = NSMutableArray()
    var listArr = NSMutableArray()
    var listArr1 = NSArray()
    var finalData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblResponse.delegate = self
        self.tblResponse.dataSource = self
        self.tblResponse.estimatedRowHeight = 80
        self.tblResponse.rowHeight = UITableViewAutomaticDimension
        self.btnSelectMovie.isEnabled = false
        self.tblResponse.layer.cornerRadius = 10.0
        self.tblResponse.layer.borderWidth = 1
        self.tblResponse.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func getAction(_ sender: Any) {

        SVProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async {
        
            APIUtilities.sharedInstance.requestURL(getRequestUrl, parameters: [:], headers: [:], completion:  {
                (req, res, data)  -> Void in
                SVProgressHUD.dismiss()
                if(data.isSuccess) {
                    self.responseArray.removeAllObjects()
                    let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                    for i in 0..<10 {
                        self.listArr.add((dataArr[i] as AnyObject).value(forKey: "EventTitle") as! String)
                        self.responseArray.add(dataArr[i])
                    }
                    self.listArr1 = self.listArr as NSArray
                    self.btnSelectMovie.isEnabled = true
                }
                else if(data.isFailure) {
                    self.response.text = "Failure: \n\(data.error!)"
                }
            })
        }
    }
    
    @IBAction func btn_clkSelectMovieName(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select Movie Name", rows: self.listArr1 as [AnyObject], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            self.txtMovieName.text = index as? String
            self.finalData.removeAllObjects()
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Actors") as! String, forKey: "Actors")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Director") as! String, forKey: "Director")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "EventReleaseDate") as! String, forKey: "EventReleaseDate")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "EventSynopsis") as! String, forKey: "EventSynopsis")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Genre") as! String, forKey: "Genre")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Language") as! String, forKey: "Language")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Length") as! String, forKey: "Length")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "EventCensor") as! String, forKey: "EventCensor")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "Ratings") as! String, forKey: "Ratings")
            self.finalData.setValue((self.responseArray[value] as! NSDictionary).value(forKey: "BannerURL") as! String, forKey: "BannerURL")
            self.tblResponse.reloadData()
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseDataCell", for: indexPath) as! ResponseDataCell
        cell.lblTitle.text = self.finalData.allKeys[indexPath.row] as? String
        cell.lblList.text = self.finalData.allValues[indexPath.row] as? String
        return cell
    }
}

