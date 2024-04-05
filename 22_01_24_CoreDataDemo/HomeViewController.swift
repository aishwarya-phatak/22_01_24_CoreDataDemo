//
//  HomeViewController.swift
//  22_01_24_CoreDataDemo
//
//  Created by Vishal Jagtap on 05/04/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(
            forEntityName: "User",
            in: managedContext)
        
        let userObject = NSManagedObject(
            entity: userEntity!,
            insertInto: managedContext)
        
        userObject.setValue(self.firstnameTextField.text,
                            forKey: "firstname")
        userObject.setValue(self.lastnameTextField.text, forKey: "lastname")
        
        do{
            try managedContext.save()
            print("saved success")
        }catch{
            print(error)
        }
    }
}
