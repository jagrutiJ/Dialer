//
//  SettingsViewController.swift
//  Dialer
//
//  Created by Jagruti on 12/12/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet var animationView : UIView!
  
  @IBOutlet var animationViewYAxis : NSLayoutConstraint!
  
  @IBOutlet var providerButton : UIButton!
  
  var provider : String = "test"
  
  let gradePickerValues = ["5. Klasse", "6. Klasse", "7. Klasse"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePicker()

        // Do any additional setup after loading the view.
    }
    

  
  @IBAction func openPicker(){
    UIView.animate(withDuration: Double(0.3), animations: {
      self.animationViewYAxis.constant = 0
      self.animationView.alpha = 1
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func cancelPicker(){
    UIView.animate(withDuration: Double(0.3), animations: {
      self.hidePicker()
    })
  }
  
  @IBAction func donePicker(){
    self.providerButton.titleLabel?.text = self.provider
    UIView.animate(withDuration: Double(0.3), animations: {
      self.hidePicker()
    })
  }
  
  func hidePicker(){
    self.animationViewYAxis.constant = 200
    self.animationView.alpha = 0
    self.view.layoutIfNeeded()
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 3                                 
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return gradePickerValues[row]

  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   provider = gradePickerValues[row]
  }
  
}
