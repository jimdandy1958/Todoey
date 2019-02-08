//
//  StudentNoteViewController.swift
//  JWMinistry
//
//  Created by Mac on 2/7/19.
//  Copyright © 2019 JimdandyForex. All rights reserved.
//

import UIKit
import RealmSwift

class StudentNoteViewController: UIViewController {

    @IBOutlet weak var studentNoteView: UITextView!
    
    let realm = try? Realm()

    var noteText = ""

    //declare a variable that is the results of the Item Objects
    var studentNotes: Results<Item>?
    
    var selectedStudentNote : Item? {
        didSet{
           // print("selectedStudentNote is ",selectedStudentNote?.studentNote)
            noteText = (selectedStudentNote?.studentNote)!
        }
    }
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNoteView.text = noteText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let results = realm?.objects(Item.self)
        try? realm?.write {
            selectedStudentNote!.studentNote = studentNoteView.text
            //results?[selectedRow].studentNote = studentNoteView.text!
        }
    }
}
