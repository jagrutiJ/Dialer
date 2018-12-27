//
//  ViewController.swift
//  Dialer
//
//  Created by Jagruti on 6/7/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import Intents

class ViewController: UITabBarController{

  override func viewDidLoad() {
    super.viewDidLoad()
  
    INPreferences.requestSiriAuthorization { (status) in
      if status == .authorized {
        print("Siri access allowed")
      } else {
        print("Siri access denied")
      }
    }
    // Do any additional setup after loading the view, typically from a nib.
   // DataManager.sharedManager.saveContacts(contacts: [["name": "Aai", "number": "9423967700"], ["name": "Tony Stark", "number": "1800-IRONMAN"], ["name": "Bruce Banner", "number": "1800-HULKSMASH"], ["name": "Bruce Wayne", "number": "1800-BATMAN"]])

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

