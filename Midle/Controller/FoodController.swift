//
//  NotesController.swift
//  QuickNote
//
//  Created by dev7 on 1/9/17.
//  Copyright © 2017 dev7. All rights reserved.
//

import UIKit

class FooodController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: *** Data model
    var database : OpaquePointer?
    var tagName = "All"
    
    // MARK: *** UI Elements
    var id = [Int]()
    var fullname = [String]()
    var dob = [String]()
    var grade = [Int]()
    var other = [String]()
    var param : UserDefaults!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: *** UI events
    @IBAction func addNoteButton_Tapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueNoteDetailID", sender: self)
    }
    
    // MARK: *** Local variables
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData() // Cập nhật giao diện
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueNoteDetailID" {
            let dest = segue.destination as! NoteDetailController
            dest.mode = "Add"
            dest.delegate = self
        } else if segue.identifier == "SegueNoteEditID" {
            let dest = segue.destination as! NoteEditController
            dest.note = self.selectedNote
            dest.delegate = self
        }
    }
    
    func addNote(newNote: Note) {
        notes += [newNote] // Cập nhật data model
    }
    
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(id.count)
        return id.count
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! StudentCell
            cell.lbFullname.text = "Full name: " + fullname[indexPath.row]
            cell.lbGrade.text = "Grade: " + String(grade[indexPath.row])
            cell.lbDoB.text = " - Day of Birth: "  + date_as_string(date: dob[indexPath.row])!
            cell.lbOther.text = "Other Info: " + other[indexPath.row]
            return cell
        }
        func reloaddata() {
            getAll()
            myTable.reloadData()
            alert(title: "Success", message: "Student has been added!") { _ in
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "addStudentSegue" {
                let dest = segue.destination as! AddStudentDetails
                dest.delegate = self
            } else if segue.identifier == "editStudentSegue" {
                let indexPath = myTable.indexPathForSelectedRow
                let index : Int! = indexPath?.row
                let idStudent : Int = id[index]
                print("adkjf \(idStudent)")
                param.set(idStudent, forKey: "currentRow")
                myTable.reloadData()
            }
            
        }
        
        // Hiển thị một hình ảnh của note nếu có
        let a = note.images?.allObjects as! Array<Image>
        if a.count > 0 {
            cell.noteImageView.image = UIImage(data: a[0].data as! Data)
        }
        
        return cell
    }
    
    var selectedNote: Note?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notes[indexPath.row] as? Note
        performSegue(withIdentifier: "SegueNoteEditID", sender: self)
    }
    
    // MARK: *** NoteEditControllerDelegate
    func doneEditing() {
        tableView.reloadData() // Cập nhật giao diện
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            DB.MOC.delete(note)
            notes.remove(at: indexPath.row) // Cập nhật data model
            
            DB.save() // Cập nhật CSDL
            tableView.deleteRows(at: [indexPath], with: .fade) // Cập nhật giao diện
        }
    }
}

