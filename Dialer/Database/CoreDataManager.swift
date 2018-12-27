//
//  CoreDataManager.swift
//  CoreDataSample
//
//  Created by Jagruti on 5/23/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

  var managedObjectContext : NSManagedObjectContext!
  var psc : NSPersistentStoreCoordinator!
  
  static var shared : CoreDataManager{
    return CoreDataManager(storeName:"Dialer")
  }
  init(storeName : String){
    super.init()
  }
  func initializeCoreDataManager(storeName: String){

    let currentBundle = Bundle(for: CoreDataManager.self)
    guard let momdPath = currentBundle.url(forResource: storeName, withExtension: "momd") else {
      fatalError("Unable to find managedObjectModel")
    }
    let mom = NSManagedObjectModel(contentsOf: momdPath)
    let psc =  NSPersistentStoreCoordinator(managedObjectModel: mom!)
    self.psc = psc
    self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    self.managedObjectContext.persistentStoreCoordinator = psc
    let urlForDocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let storePath = urlForDocumentDirectory?.appendingPathComponent(storeName)
    do{
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storePath, options: nil)
    }
    catch{
      fatalError("")
    }
  }
  func contextForCurrentThread()-> NSManagedObjectContext{
//    if (Thread.isMainThread) {
//      return CoreDataManager.shared.managedObjectContext
//    }
    let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
   // moc.parent = self.managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    moc.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
    return moc;
  }
  
  
  func saveDataConcurrently(foMoc moc : NSManagedObjectContext, completionBlock: @escaping (_ eroor : Error?)->Void)
  {
    moc.performAndWait {
      do {
        try moc.save()
          do {
           // try CoreDataManager.shared.managedObjectContext.save()
            completionBlock(nil);
          }
          catch {
            completionBlock(error)
          }
      
      }
      catch {
        completionBlock(error)
      }
      
    }
    
  }
  static func clearStore() {
    let ENTITIES = ["ContactData"]
    for entity in ENTITIES {
      self.shared.deleteEntity(name: entity)
    }
  }
  
  
  func deleteEntity(name : String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
      try self.psc.execute(deleteRequest, with: self.managedObjectContext)
    } catch let error as NSError {
      // TODO: handle the error
      print("Error in deleting entity \(name) : \(error)")
    }
  }

}
