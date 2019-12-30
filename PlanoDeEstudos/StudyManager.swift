//
//  StudyManager.swift
//  PlanoDeEstudos
//
//  Created by Anderson Alencar on 18/12/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
import UserNotifications

class StudyManager {
    
    static let shared = StudyManager()
    private let ud = UserDefaults.standard
    var studyPlans: [StudyPlan] = []
    
    
    private init(){
        if let data = ud.data(forKey: "StudyPlans"), let plans = try? JSONDecoder().decode([StudyPlan].self, from: data){
            self.studyPlans = plans
        }
    }
    
    func savePlans() {
        if let data = try? JSONEncoder().encode( studyPlans){
            ud.set(data, forKey: "StudyPlans")
        }
    }
    
    func addPlan(_ studyPlan: StudyPlan){
        self.studyPlans.append(studyPlan)
        savePlans()
    }
    
    func removePlan(at indexPlan: Int) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [studyPlans[indexPlan].id])
        studyPlans.remove(at: indexPlan)
        savePlans()
    }
    
    func setPlanDone(id : String){
        let studyPlan = studyPlans.first { (studyPlan) -> Bool in
            return studyPlan.id == id
        }
        
        if let studyPlan = studyPlan {
            studyPlan.done = true
            savePlans()
        }
    }
    
    func pedentPlans() -> [StudyPlan]{
        
        let plans = studyPlans.filter { (studyPlan) -> Bool in
            studyPlan.date < Date() && studyPlan.done == false
        }
        return plans
        
    }
    
}
