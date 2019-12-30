//
//  NotificationsTableViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class StudyPlansTableViewController: UITableViewController {

    
    let sm = StudyManager.shared
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy HH:mm"
        return df
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(notification:)), name: NSNotification.Name(rawValue: "Confirmed"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func onReceive(notification: Notification){
        if let userInfo = notification.userInfo, let id = userInfo["id"] as? String{
            sm.setPlanDone(id: id)
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sm.studyPlans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let studyPlan = sm.studyPlans[indexPath.row]
        cell.textLabel?.text = studyPlan.section
        cell.detailTextLabel?.text = dateFormatter.string(from: studyPlan.date)
        if studyPlan.date < Date() && studyPlan.done == false{
            cell.backgroundColor = UIColor(red:1.00, green:0.67, blue:0.65, alpha:1.0)


        } else {
            cell.backgroundColor = studyPlan.done ? UIColor(red:0.31, green:0.82, blue:0.49, alpha:1.0) : UIColor.white
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sm.removePlan(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sm.studyPlans[indexPath.row].date < Date() && sm.studyPlans[indexPath.row].done == false{
            let alert = UIAlertController(title: "Você completou a tarefa?", message: "\(sm.studyPlans[indexPath.row].section)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action) in
                self.sm.setPlanDone(id: self.sm.studyPlans[indexPath.row].id)
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
            self.present(alert,animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
