//
//  CalendarViewController.swift
//  JWMinistry
//
//  Created by Mac on 2/1/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //@IBOutlet weak var dateLabel: UILabel!

    //@IBOutlet weak var endTimeDateLabel: UILabel!
    
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    
    @IBAction func updateDateLabel(_ sender: Any) {
        let hours = "\(round(computeElapsedTime()/3600)) hours."
        let minutes = "\(round(computeElapsedTime()/60).remainder(dividingBy: 60)) minutes."
        elapsedTimeLabel.text = hours+" and "+minutes
    }
    
    @IBAction func updateEndTimeLabel(_ sender: Any) {
        let hours = "\(round(computeElapsedTime()/3600)) hours."
        let minutes = "\(round(computeElapsedTime()/60).remainder(dividingBy: 60)) minutes."
        elapsedTimeLabel.text = hours+" and "+minutes

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      dateLabel.text = formatDate()
  //      endTimeDateLabel.text = formatDate()
        //elapsedTimeLabel.text = "elapsed time"
    }
    
    func formatDate() ->String {
        
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: datePicker.date)
        return dateString
    }
    
    func computeElapsedTime()->TimeInterval{
        let Time1 = datePicker.date
        let Time2 = endTimeDatePicker.date.timeIntervalSince(Time1)
        
        return Time2
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
