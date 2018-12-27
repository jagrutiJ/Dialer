//
//  RecentCallViewController.swift
//  Dialer
//
//  Created by Jagruti on 11/26/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RecentCallViewController: UIViewController {

  @IBOutlet var recentCallTableView : UITableView!
  
  @IBOutlet var bannerView: GADBannerView!
  
  var interstitial: GADInterstitial!
  
  var timer = Timer()
  
  var recentCallArray : [ContactModel] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recentCallTableView.tableFooterView = UIView()
        self.setCustomCellToTable()
        self.addMob()

        interstitial = createAndLoadInterstitial()


        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    recentCallArray = ContactStoreManager.fetchRecentContact() as! [ContactModel]
    print(recentCallArray)
    self.recentCallTableView.reloadData()

    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (Timer) in
      self.callFullScreenAd() // per the OP's example
    })
    
  }
  override func viewDidAppear(_ animated: Bool) {
  
  }
  
  func createAndLoadInterstitial() -> GADInterstitial {
    interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    interstitial.delegate = self as? GADInterstitialDelegate
    interstitial.load(GADRequest())
    return interstitial
  }
  
  func callFullScreenAd() {

    if interstitial.isReady {
      interstitial.present(fromRootViewController: self)
    }
    
  }
  
  func addMob(){
    bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    bannerView.rootViewController = self
    bannerView.load(GADRequest())
  }
  
  private func setCustomCellToTable(){
    recentCallTableView.register(UINib(nibName: "RecentCallTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentCell")
  }

}


extension RecentCallViewController: UITableViewDataSource{

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return recentCallArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell") as! RecentCallTableViewCell
    
    let model : ContactModel = recentCallArray[indexPath.row]
    cell.name!.text = model.name
    cell.number!.text = model.phone
    cell.callTime.text = getDate(date: model.dateTime)
    cell.number!.isHidden = false

    if(model.name == nil){
      cell.number!.isHidden = true
      cell.name!.text = model.phone
    }
    
    return cell
  }
}

func getDate(date : Date) -> String {

  let dateFormatter = DateFormatter()
  let currentDate = Date()
  dateFormatter.dateFormat = "dd-MMM-yyyy"
  let date1 = dateFormatter.string(from: date)
  let date2 = dateFormatter.string(from: currentDate)
  dateFormatter.dateFormat = "EEE, dd-MMM-yyyy, hh:mm a"

  if(date1 == date2){
    dateFormatter.dateFormat = "hh:mm a"

  }
  let goodDate = dateFormatter.string(from: date)
  return goodDate
}


func compareDate(dateA : Date) -> String {
  
  let dateB = Date()
  var Day : String = ""
  switch dateA.compare(dateB) {
  case .orderedAscending:
      Day = "Yesterday"
  case .orderedSame:
      Day = "Today"
  case .orderedDescending:
    Day = "Today"

  }
  return Day

}

//MARK: TableView Delegates
extension RecentCallViewController:UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    tableView.deselectRow(at: indexPath, animated: false)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    
    return 65
  }
 
}
