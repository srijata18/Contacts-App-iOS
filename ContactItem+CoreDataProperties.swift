//
//  ContactItem+CoreDataProperties.swift
//  ContactsApplication
//
//  Created by Mobile Team 3 on 11/12/17.
//  Copyright © 2017 Mobile Team 3. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactItem> {
        return NSFetchRequest<ContactItem>(entityName: "ContactItem")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?

}
