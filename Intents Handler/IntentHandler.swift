//
//  IntentHandler.swift
//  Intents Handler
//
//  Created by Jagruti on 12/13/18.
//  Copyright © 2018 Jagruti. All rights reserved.
//

import Intents


// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension,INStartAudioCallIntentHandling{
  
  func handle(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
    
    let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartAudioCallIntent.self))
    let response = INStartAudioCallIntentResponse(code: .continueInApp, userActivity: userActivity)
    completion(response)
  }
  
  func resolveContacts(for intent: INStartAudioCallIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
    
    var contactName: String?
    
    if let contacts = intent.contacts {
      contactName = contacts.first?.displayName
    }
  
   
    DataManager.sharedManager.findContact(contactName: contactName, with: { (contacts) in
      
      switch contacts.count {
        
      case 1:
        completion([INPersonResolutionResult.success(with: contacts.first!)])
      case 2 ... Int.max:
        completion([INPersonResolutionResult.disambiguation(with: contacts)])
      default:
        completion([INPersonResolutionResult.unsupported()])
      }
      
    })
  }
  
  func confirm(intent: INStartAudioCallIntent, completion: @escaping (INStartAudioCallIntentResponse) -> Void) {
    
    let userActivity = NSUserActivity(activityType: NSStringFromClass(INStartAudioCallIntent.self))
    let response = INStartAudioCallIntentResponse(code: .ready, userActivity: userActivity)
    completion(response)
  }
  
}
