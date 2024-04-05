//
//  ListOfUsersViewController.swift
//  22_01_24_CoreDataDemo
//
//  Created by Vishal Jagtap on 05/04/24.
//

import UIKit
import CoreData

class ListOfUsersViewController: UIViewController , UITableViewDataSource {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var firstNames : [String] = []
    var lastNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "User")
        
        do {
            var retrivedUserRecords = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for eachRetrivedRecord in retrivedUserRecords{
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
        
        
        if editingStyle == .delete{
            self.usersTableView.beginUpdates()
            self.usersTableView.deleteRows(at: [indexPath], with: .fade)
            self.firstNames.remove(at: indexPath.row)
            self.lastNames.remove(at: indexPath.row)
            self.usersTableView.endUpdates()
        }
    }
}
