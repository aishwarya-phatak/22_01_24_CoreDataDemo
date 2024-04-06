//
//  ListOfUsersViewController.swift
//  22_01_24_CoreDataDemo
//
//  Created by Vishal Jagtap on 05/04/24.
//

import UIKit
import CoreData

class ListOfUsersViewController: UIViewController , UITableViewDataSource , UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    
    var firstNames : [String] = []
    var lastNames : [String] = []
    var retrivedUserRecords : [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            retrivedUserRecords = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for eachRetrivedRecord in retrivedUserRecords as! [NSManagedObject]{
//                self.firstNames.removeAll()
//                self.lastNames.removeAll()
                
                self.firstNames.append(eachRetrivedRecord.value(forKey: "firstname") as! String)
                self.lastNames.append(eachRetrivedRecord.value(forKey: "lastname") as! String)
                
                self.usersTableView.reloadData() //reload tableview
            }
        }catch{
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        firstNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.usersTableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath)
        cell.textLabel?.text = firstNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if editingStyle == .delete{
            
            self.usersTableView.beginUpdates()
            
            //deleting user records from core data permanently
            managedContext.delete(retrivedUserRecords![indexPath.row])
            
            //to delete a row from users table
            self.usersTableView.deleteRows(at: [indexPath], with: .fade)
            
            //to delete elements from an array
            self.firstNames.remove(at: indexPath.row)
            self.lastNames.remove(at: indexPath.row)
            
            self.usersTableView.endUpdates()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "firstname = %@", searchBar.text!)
        
        do {
            retrivedUserRecords = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            self.firstNames.removeAll()
            self.lastNames.removeAll()
            
            for eachRetrivedRecord in retrivedUserRecords as! [NSManagedObject]{
                self.firstNames.append(eachRetrivedRecord.value(forKey: "firstname") as! String)
                self.lastNames.append(eachRetrivedRecord.value(forKey: "lastname") as! String)
                
                self.usersTableView.reloadData() //reload tableview
            }
        }catch{
            print(error)
        }
    }
}
