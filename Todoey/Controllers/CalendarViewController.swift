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
        //get the hours
        let hours = floor(computeElapsedTime()/3600)
        //get the total minutes
        let totalminutes = floor(computeElapsedTime()/60)
        //make an hour string
        let hourString = "\(hours) hours."
        //get minutes in our hours counted
        let hourMinutes = hours*60
        // get the differnce between all the minutes and the ones in the hours
        let excessMinutes = totalminutes - hourMinutes
        //make a minutes string of the excess minutes
        let minuteString = "\(excessMinutes) minutes."
        elapsedTimeLabel.text = hourString+" and "+minuteString
    
    
    }
    
    @IBAction func updateEndTimeLabel(_ sender: Any) {
        //get the hours
        let hours = floor(computeElapsedTime()/3600)
        //get the total minutes
        let totalminutes = floor(computeElapsedTime()/60)
        //make an hour string
        let hourString = "\(hours) hours."
        //get minutes in our hours counted
        let hourMinutes = hours*60
        // get the differnce between all the minutes and the ones in the hours
        let excessMinutes = totalminutes - hourMinutes
        //make a minutes string of the excess minutes
        let minuteString = "\(excessMinutes) minutes."
        elapsedTimeLabel.text = hourString+" and "+minuteString
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let Time2 = round(endTimeDatePicker.date.timeIntervalSince(Time1))
        
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
