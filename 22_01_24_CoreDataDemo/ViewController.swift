//
//  ViewController.swift
//  22_01_24_CoreDataDemo
//
//  Created by Vishal Jagtap on 04/04/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addPersonRecords()
        retrivePersonRecords()
    }
    
    func addPersonRecords(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(
            forEntityName: "User",
            in: managedContext)
        
        let userObject = NSManagedObject(
            entity: userEntity!,
            insertInto: managedContext)
        
        userObject.setValue("Tushar", forKey: "firstname")
        userObject.setValue("Sontakke", forKey: "lastname")
        
        do{
            try managedContext.save()
        } catch {
            print(error)
        }
        
        for i in 1...3{
            let userObject = NSManagedObject(
                entity: userEntity!,
                insertInto: managedContext)
            
            userObject.setValue("Person\(i)", forKey: "firstname")
            userObject.setValue("PersonLastName\(i)", forKey: "lastname")
        }
        
        do{
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func retrivePersonRecords(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do{
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for eachResult in results{
                print("Firstname is :\(eachResult.value(forKey: "firstname") as! String)")
                print("Lastname is :\(eachResult.value(forKey: "lastname") as! String)")
            }
        }catch{
           print(error)
        }
    }
}
