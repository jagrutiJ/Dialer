//
//  ContactViewController.swift
//  Dialer
//
//  Created by Jagruti on 6/7/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import Contacts
import GoogleMobileAds

class ContactViewController: UIViewController {
  
  @IBOutlet var contactTable: UITableView!

  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet var bannerView: GADBannerView!
  
  var model : ContactModel!
  
  var firstCharacterSetArray :[String] = []
  var filterfirstCharacterSetArray :[String] = []
  var phoneNumberArray : NSMutableArray = []
  var contactArray :[ContactModel] = []
  var filteredArray :[ContactModel] = []
  var contactDict = NSMutableDictionary()
  var siriContactList = [[String: String]]()

  var indexArray = ["#","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMob()
        self.setCustomCellToTable()
        self.fetchAllContacts()
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func addMob(){
      bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
      bannerView.rootViewController = self
      bannerView.load(GADRequest())
    }
  
}
//MARK: UI
extension ContactViewController{
  private func setCustomCellToTable(){
    contactTable.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    contactTable.rowHeight = UITableViewAutomaticDimension
    contactTable.estimatedRowHeight = 100
  }
}
extension ContactViewController: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return firstCharacterSetArray.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let firstCharater = self.firstCharacterSetArray[section]
    let modelArray = contactDict[firstCharater]
    return (modelArray! as AnyObject).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContactTableViewCell
    let firstCharater = self.firstCharacterSetArray[indexPath.section]
    let dataArray = contactDict[firstCharater] as! [ContactModel]
    self.model = dataArray[indexPath.row]
    cell.name.isHidden = false
    cell.name!.text = model.name
    cell.number!.text = model.phone

    if(model.name == "#"){
      cell.name.isHidden = true
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
    let footerView = UIView(frame:rect)
    let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.size.width - 16, height: 40))
    footerView.backgroundColor = UIColor.init(red: 174/255, green: 209/255, blue: 255/255, alpha: 1)
    label.text = firstCharacterSetArray[section]

    //footerView.backgroundColor = UIColor.clear
    footerView.addSubview(label)
    return footerView

  }
}

//MARK: TableView Delegates
extension ContactViewController:UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    tableView.deselectRow(at: indexPath, animated: false)
    let firstCharater = self.firstCharacterSetArray[indexPath.section]
    let dataArray = contactDict[firstCharater] as! [ContactModel]
    self.model = dataArray[indexPath.row]
    callButtonClicked(contact: model)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    
    return 73
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    return 10
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
      return 40
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return indexArray
  }
}


func callButtonClicked(contact :ContactModel){
  let cleanPhoneNumber = contact.phone.replacingOccurrences(of: " ", with: "")

  if let url = URL(string: "tel://\(cleanPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
    if #available(iOS 10, *) {
      UIApplication.shared.open(url)
      
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  contact.phone = cleanPhoneNumber
  ContactStoreManager.saveContact(contact, completionHandler: nil)
}

//MARK: UISearchBarDelegate Delegates
extension ContactViewController:UISearchBarDelegate{

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
  searchBar.text = ""
  // Hide the cancel button
    self.loadAllContacts()
    contactTable.reloadData()
    
    searchBar.setShowsCancelButton(false, animated: true)
    searchBar.resignFirstResponder()

  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
 

  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
    print("searchText: \(searchText)")
    //let searchString = String.trimmingCharacters(in: .whitespaces)

    if(searchText.trimmingCharacters(in: .whitespaces).count > 0){
      firstCharacterSetArray.removeAll()
      firstCharacterSetArray.append(String(searchText.characters.first!))
      
      self.filteredArray = contactArray.filter({ $0.name.hasPrefix(searchText) })
      self.CreateDict(filteredArray: filteredArray)
      //print(filteredArray)
    }
    else{
      print("searchText: \(searchText)")
      self.loadAllContacts()
     
    }
    contactTable.reloadData()
  }
  
  func loadAllContacts(){
    
    self.filteredArray = self.contactArray
    firstCharacterSetArray = filterfirstCharacterSetArray
    self.CreateDict(filteredArray: filteredArray)
  }
}

extension ContactViewController{

  func fetchAllContacts(){
    do {
      var nameArray :[String] = []
      if #available(iOS 9.0, *) {
        let contactStore = CNContactStore()
        var results: [CNContact] = []
        
        try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])) {
          (contact, cursor) -> Void in
          results.append(contact)
          
        
          var fullname : String = contact.givenName + " \(contact.familyName)"
          
          for phoneNumber:CNLabeledValue in contact.phoneNumbers {
            let number  = phoneNumber.value
            
            if(number.stringValue.characters.count>9)
            {
              self.model = ContactModel()
              self.model.name = fullname
              let a = (String(fullname.characters.first!))
              if(self.getValue(alphabet: a)){
                fullname = "#"
                self.model.name = fullname

              }
              
              if(fullname == " "){
                self.model.name = number.stringValue
              }
              else{
                nameArray.append(fullname)
              }
              self.model.phone = number.stringValue
              if(self.model.name != "SPAM")
              {
                self.filteredArray.append(self.model)

              }
            }
          }
          self.siriContactList.append(["name":self.model.name, "number": self.model.phone])
          self.contactArray = self.filteredArray.sorted(by: {$0.name.compare($1.name) == .orderedAscending})
          self.filteredArray = self.contactArray
          
        }
        SortArrayAlbhabetically(nameArray: nameArray)
        saveContactLlistforSiri()
  

      } else {
        // Fallback on earlier versions
      }
    }
    catch{
      print("Handle the error please")
    }
  }
  
    func saveContactLlistforSiri(){
      var set = Set<String>()
      let arraySet: [[String : Any]] = siriContactList.compactMap {
        guard let name = $0["name"] else {return nil }
        return set.insert(name).inserted ? $0 : nil
      }
      DataManager.sharedManager.saveContacts(contacts: arraySet as! [[String : String]])
    }
  
    func SortArrayAlbhabetically(nameArray : [String]){
      
      var firstLetters = [String]()
      for string in nameArray {
      firstLetters.append(String(string.characters.first!).uppercased())
      }

      firstLetters = Array(Set(firstLetters))
      firstCharacterSetArray = firstLetters.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
      
      filterfirstCharacterSetArray = firstCharacterSetArray
      self.CreateDict(filteredArray: contactArray)

      }
  
    func CreateDict(filteredArray : [ContactModel]){
    
     
      for alphabet in firstCharacterSetArray{
        
       let arr = filteredArray.filter({ $0.name.hasPrefix(alphabet) }) // Abc
        contactDict.setValue(arr, forKey: alphabet)
       // filtercontactDict.setValue(arr, forKey: alphabet)

      }
    // print("\(String(describing: contactDict))")
      self.contactTable.reloadData()
    }
  
  func getValue(alphabet : String) -> Bool{
    
    var indexCharacter : Bool = false
    switch alphabet {
    case "1":
      indexCharacter = true
    case "2":
      indexCharacter = true
    case "3":
      indexCharacter = true
    case "4":
      indexCharacter = true
    case "5":
      indexCharacter = true
    case "6":
      indexCharacter = true
    case "7":
      indexCharacter = true
    case "8":
      indexCharacter = true
    case "9":
      indexCharacter = true
    case "+":
      indexCharacter = true
    default:
      indexCharacter = false
    }
    return indexCharacter
  }
}

