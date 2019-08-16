//
//  ViewController.swift
//  ContactsApplication
//
//  Created by Mobile Team 3 on 11/12/17.
//  Copyright © 2017 Mobile Team 3. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource {
    var managedObjectContext : NSManagedObjectContext?
    
    var dataModel:DataModel?
    var contacts:[ContactItem]?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    
    @IBAction func createContact(_ sender: Any) {
        let name = nameTextField.text
        let phone = phoneTextField.text
        let email = emailtextField.text
        
        

        
        
        let success = dataModel?.createContact(name:name!, phone:phone!, email:email!)
        
        if success! {
            print("Created contact ")
        }
        contacts = dataModel?.getAllContacts()
        contactsTableView.reloadData()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel = DataModel()
        dataModel?.managedObjectContext = self.managedObjectContext
        contacts = dataModel?.getAllContacts()
        contactsTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (contacts?.count) ?? 0
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let contact = contacts?[indexPath.row]
        if let contact = contact{
            cell?.textLabel?.text = contact.name
        }
        return cell!
    }


}

