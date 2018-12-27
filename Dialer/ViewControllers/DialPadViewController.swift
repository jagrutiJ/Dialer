//
//  DialPadViewController.swift
//  Dialer
//
//  Created by Jagruti on 9/14/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import CoreData

class DialPadViewController: UIViewController {

  @IBOutlet var numberLable : UILabel!
  
  @IBOutlet weak var clearButton : UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
      clearButton.addGestureRecognizer(longGesture)
      
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func clearText(){
  
    numberLable.text = String((numberLable.text?.dropLast())!)

  }
  
  @objc func longTap(sender : UIGestureRecognizer){
    print("Long tap")
    if sender.state == .ended {
      print("UIGestureRecognizerStateEnded")
      numberLable.text = ""
      
    }
    else if sender.state == .began {
      print("UIGestureRecognizerStateBegan.")
      numberLable.text = ""

      //Do Whatever You want on Began of Gesture
    }
  }
  
  @IBAction func callButtonClicked(){
    if let dialNumber = Int(numberLable.text!) {
      if let url = URL(string: "tel://\(dialNumber)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
          UIApplication.shared.open(url)
        } else {
          UIApplication.shared.openURL(url)
        }
      }
    }
    let contact = ContactModel()
    contact.phone = numberLable.text
    ContactStoreManager.saveContact(contact, completionHandler: nil)

}
  
  @IBAction func buttonClicked(sender : AnyObject){
    
    let button = sender as! UIButton
    numberLable.text = (numberLable.text)! + String(button.tag)
    
//      switch (button.tag)
//      {
//      case 0:
//        print("zero")
//
//      case 1:
//        print("one")
//
//      case 2:
//        print("two")
//
//      case 3:
//        print("three")
//
//      case 4:
//        print("four")
//
//      case 5:
//        print("five")
//
//      default:
//        print("Integer out of range")
//      }
    }
}
