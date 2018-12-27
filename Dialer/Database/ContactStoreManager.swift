//
//  ContactStoreManager.swift
//  Dialer
//
//  Created by Jagruti on 11/26/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import CoreData


public struct ContactStruct {
  public var phone: Int16
  public var name: String
  public var callDateTime: Date

  init() {
    self.phone = 0
    self.name = ""
    self.callDateTime = Date(timeIntervalSince1970: 0)
  }
}

class ContactStoreManager: NSObject {

  class func saveContact(_ model : ContactModel, completionHandler: ((_ error : Error?)->Void)?) {
    let moc = CoreDataManager.shared.contextForCurrentThread()
    
    model.dateTime = Date()
    let contact = Contact(context: moc)
    contact.setValue(model.name, forKey: "name")
    contact.setValue(Int64(model.phone), forKey: "phone")
    contact.setValue(model.dateTime, forKey: "callDateTime")
    
    CoreDataManager.shared.saveDataConcurrently(foMoc: moc) { (error) in
      if (completionHandler != nil) { completionHandler!(error) }
      if(error != nil) {
        print("Unable to save contact data, with ID: \(contact)\nError : \(error!.localizedDescription)")
      }
      else {
        
        print("contact data saved successfully:\n\(contact)")
      }
    }
  }
  
  
  class func getContactCount() -> Int {
    
    let moc = CoreDataManager.shared.contextForCurrentThread()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
    let count = try! moc.count(for: fetchRequest)
    return count
  }
  
  class func deleteContact() {
    
  }
  
  class func fetchRecentContact() -> NSMutableArray{
    let moc = CoreDataManager.shared.contextForCurrentThread()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
    let count = try! moc.count(for: fetchRequest)
    if(count > 30){
      fetchRequest.fetchLimit = 30
    }
    let allContacts = try! moc.fetch(fetchRequest)
    let contactarray = NSMutableArray()
    for allContacts in allContacts as! [NSManagedObject] {
      let contactModel = ContactModel()
      contactModel.name = allContacts.value(forKey: "name") as? String
      let phone = allContacts.value(forKey: "phone") as? Int64
      contactModel.phone = "\(phone ?? 0)"
      contactModel.dateTime = allContacts.value(forKey: "callDateTime") as? Date
      contactarray.add(contactModel)
    }
    return contactarray
  }
 
}
