//
//  DataModel.swift
//  ContactsApplication
//
//  Created by Mobile Team 3 on 11/12/17.
//  Copyright © 2017 Mobile Team 3. All rights reserved.
//

import UIKit
import CoreData
class DataModel: NSObject {
    var managedObjectContext:NSManagedObjectContext?
    func getAllContacts() -> [ContactItem]?
    {
        var  contacts:[ContactItem]?
        var fetchRequest = NSFetchRequest<ContactItem>(entityName: "ContactItem" )
//        var sort = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sort]
        do{
            contacts = try managedObjectContext?.fetch(fetchRequest) as? [ContactItem]
            
        }
        catch { fatalError("Failed to fetch contacts!!!! : \(error)")}
        
         return contacts
        
        
    }
    func createContact(name:String , phone : String,  email : String) -> Bool
    {
     let managedObject = NSEntityDescription.insertNewObject(forEntityName: "ContactItem", into: self.managedObjectContext!)
        let contactItem = managedObject as? ContactItem
        
        contactItem?.name = name
        contactItem?.email = email
        contactItem?.phone = phone
        
        
        var success = false
        do{
       try managedObjectContext?.save()
             success = true
        } catch {
            
            print("Unable to insert")
        }
        return success
    }
}
