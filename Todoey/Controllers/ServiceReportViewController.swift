//
//  StudentInfoViewController.swift
//  JWMinistry
//
//  Created by Mac on 2/3/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift

class ServiceReportViewController: UIViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    
    var myReport =  ServiceReport()
    
    //////////////////////////////////////////////////////
    
    //Name
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func nameDidEnd(_ sender:UITextField){
        self.nameTextField.resignFirstResponder()
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.name = nameTextField.text!
        }
    }
    
    //////////////////////////////////////////////////////
    
    //Month
    @IBOutlet weak var monthTextField: UITextField!
    @IBAction func monthDidEnd(_ sender: UITextField) {
        self.monthTextField.resignFirstResponder()
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.month = monthTextField.text!
        }
    }
    //this function is to make the keboard disappear when we hit the return key
    //we also set up the delegates to these text fields in viewdidload
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    ////////////////////////////////////////////////////////
    
    //Hours
    @IBOutlet weak var hourStepper: UIStepper!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBAction func hourStepperValueChanged(_ sender: UIStepper) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.hours = Int(Int(sender.value).description)!
        }
        hoursTextField.text = "\(results.hours)"
    }
    @IBAction func hourEditDidEnd(_ sender: UITextField) {
        //hoursTextField.resignFirstResponder()
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.hours = Int(hoursTextField.text!) ?? 0
        }
        hourStepper.value = Double(Int(hoursTextField.text!) ?? 0)
    }
    
    ///////////////////////////////////////////////////////
    //Placements
    @IBOutlet weak var placementStepper: UIStepper!
    @IBOutlet weak var placementsTextField: UITextField!
    @IBAction func placementStepperValueChanged(_ sender: UIStepper) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.placements = Int(Int(sender.value).description)!
        }
        placementsTextField.text = "\(results.placements)"
    }
    @IBAction func placementsChanged(_ sender: UITextField) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.placements = Int(placementsTextField.text!) ?? 0
        }
    }
    @IBAction func placementsDidEnd(_ sender: Any) {
        placementStepper.value = Double(Int(placementsTextField.text!) ?? 0)
    }
    
    /////////////////////////////////////////////////////
    //Videos
    @IBOutlet weak var videoStepper: UIStepper!
    @IBOutlet weak var videosTextField: UITextField!
    @IBAction func videoStepperValueChanged(_ sender: UIStepper) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.videos = Int(Int(sender.value).description)!
        }
        videosTextField.text = "\(results.videos)"
    }
    @IBAction func videoDidChange(_ sender: UITextField) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.videos = Int(videosTextField.text!) ?? 0
        }
       videoStepper.value = Double(Int(videosTextField.text!) ?? 0)
    }
    
    ///////////////////////////////////////////////////////
    @IBOutlet weak var rvStepper: UIStepper!
    @IBOutlet weak var rvsTextField: UITextField!
    //RV's
    @IBAction func rvStepperValueChanged(_ sender: UIStepper) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.returnVisits = Int(Int(sender.value).description)!
        }
        rvsTextField.text = "\(results.returnVisits)"
    }
    @IBAction func rvDidChange(_ sender: UITextField) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.returnVisits = Int(rvsTextField.text!) ?? 0
        }
        rvStepper.value = Double(Int(rvsTextField.text!) ?? 0)
    }
    
    ///////////////////////////////////////////////////////
    //Studies
    @IBOutlet weak var studiesStepper: UIStepper!
    @IBOutlet weak var studiesTextField: UITextField!
    @IBAction func studiesStepperVauleChanged(_ sender: UIStepper) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.bibleStudies = Int(Int(sender.value).description)!
        }
        studiesTextField.text = "\(results.bibleStudies)"
    }
    @IBAction func studiesDidChange(_ sender: UITextField) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.bibleStudies = Int(studiesTextField.text!) ?? 0
        }
        studiesStepper.value = Double(Int(studiesTextField.text!) ?? 0)
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
    noteTextView.text = ""
    
    }
    @IBOutlet weak var noteTextView: UITextView!
    @IBAction func savePressed(_ sender: UIButton) {
        let results = realm.objects(ServiceReport.self)[0]
        try? realm.write {
            results.notes = noteTextView.text ?? "note"
        }
        noteTextView.resignFirstResponder()
    }
    
    
    ///////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        //must do this so that the stepper can get text values
        loadReport()
        
        setStepperParameters()
        
       //  print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////
    
    override func viewWillAppear(_ animated: Bool) {
        loadReport()
    }
    ////////////////////////////////////////////////////
    func updateFields() {
        let results = realm.objects(ServiceReport.self)[0]
        hoursTextField.text      = "\(results.hours)"
        placementsTextField.text = "\(results.placements)"
        videosTextField.text     = "\(results.videos)"
        rvsTextField.text        = "\(results.returnVisits)"
        studiesTextField.text    = "\(results.bibleStudies)"
        
    }
    
    ////////////////////////////////////////////////////////
    
    func loadReport () {
        //this code only runs the first time the app is run
        //and there is no report object yet.
        if realm.objects(ServiceReport.self).count == 0{
            try? realm.write{
                realm.add(myReport)
            }
        }
        let results = realm.objects(ServiceReport.self)[0]
        nameTextField.text    = results.name
        monthTextField.text   = results.month
        hoursTextField.text   = "\(results.hours)"
        placementsTextField.text = "\(results.placements)"
        videosTextField.text  = "\(results.videos)"
        rvsTextField.text     = "\(results.returnVisits)"
        studiesTextField.text = "\(results.bibleStudies)"
        noteTextView.text = results.notes
        }
    
    ////////////////////////////////////////////////////
    
    func setStepperParameters(){
        //
        hourStepper.wraps = true
        hourStepper.autorepeat = true
        hourStepper.maximumValue = 100
        hourStepper.value = Double(Int(hoursTextField.text!) ?? 0)
        //
        placementStepper.wraps = true
        placementStepper.autorepeat = true
        placementStepper.maximumValue = 100
        placementStepper.value = Double(Int(placementsTextField.text!) ?? 0)
        //
        videoStepper.wraps = true
        videoStepper.autorepeat = true
        videoStepper.maximumValue = 100
        videoStepper.value = Double(Int(videosTextField.text!) ?? 0)
        //
        rvStepper.wraps = true
        rvStepper.autorepeat = true
        rvStepper.maximumValue = 100
        rvStepper.value = Double(Int(rvsTextField.text!) ?? 0)
        
        //
        studiesStepper.wraps = true
        studiesStepper.autorepeat = true
        studiesStepper.maximumValue = 100
        studiesStepper.value = Double(Int(studiesTextField.text!) ?? 0)
    }
    
    ////////////////////////////////////////////////////////
    
    func saveReport() {
        try? realm.write{
            myReport.hours = (Int(hoursTextField.text!))!
        }
    }
    
    ////////////////////////////////////////////////////////
    
    //picker info
    //picker
    //    @IBOutlet weak var PlacementPicker: UIPickerView!
    //    //datasource
    //    private let dataSource = ["0","1","2","3","4","5","6","7","8","9"]
    //    //outlet
    //    @IBOutlet weak var pickerLabel: UILabel!
    
    
    
}//end of class

//extension ServiceReportViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return dataSource.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        pickerLabel.text = dataSource[row]
//    }
// 
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return dataSource[row]
//    }
//}
