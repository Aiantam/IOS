//
//  NoteDetailController.swift
//  QuickNote
//
//  Created by dev7 on 1/9/17.
//  Copyright © 2017 dev7. All rights reserved.
//

import UIKit

class FoodDetailController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: *** Local variables
    var database : OpaquePointer?
    
    // MARK: *** Data model
    var mode = ""
    
    // MARK: *** UI Elements
    @IBOutlet weak var NamesTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var slideshowScrollView: UIScrollView!
    
    let imagePicker = UIImagePickerController()
    
    // MARK: *** UI events
    @IBAction func addImageButton_Tapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = createDB()
        createTable_Student(database: database)
        createTable_Grade(database: database)
        
        addDoneButton(contentTextView)
        
        if mode == "Add" {
            self.title = "New note"
            self.contentTextView.text = ""
            
            // Thêm nút Add
            let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNote_Tapped))
            self.navigationItem.setRightBarButton(addButton, animated: true)
        }
        
        imagePicker.delegate = self
    }
    
    func addNote_Tapped() {
        if contentTextView.isEmpty() {
            alert(title: "Error", message: "Note content cannot be empty")
        } else {
            let fullname = txtFullname.text!
            let grade = txtGrade.text!
            let dob = dbDoB.date
            let other = txtOther.text!
            
            // Xử lí các tag
            if !tagsTextField.isEmpty() {
                let seperator = ","
                let tokens = tagsTextField.text!.components(separatedBy: seperator)
                
                for token in tokens {
                    note.addToTags(Tag.findAndCreate(tag: token.trim())!)
                }
            }
            
            // Chỉ lấy 30 kí tự đầu để làm preview
            if (note.content?.characters.count)! > 45 {
                let index = note.content?.index((note.content?.startIndex)!, offsetBy: 45)
                note.preview = note.content?.substring(to: index!).appending("...")
            } else {
                note.preview = note.content
            }
            
            // Lưu các ảnh đã thêm vào note
            for selectedImage in selectedImagesQueue {
                let image =
            }
            
            let query = "INSERT INTO Student (full_name, grade, dob, other_info) values ('\(fullname)', \(grade), '\(dob)', '\(other)')"
            if insert(database: database, query: query){
                delegate?.reloaddata()
            }

            
//            DB.save() // Cập nhật CSDL
            
            alert(title: "Success", message: "Your note has been added!") { _ in
                // Quay lại màn hình trước đó
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: *** UIImagePicker
    
    var selectedImagesQueue = [UIImage]()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImagesQueue += [pickedImage] // Đưa vào hàng đợi để lưu
            addImageTo(scrollView: slideshowScrollView, image: pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    // Lúc tạo ra scrollView height 120
    func addImageTo(scrollView: UIScrollView, image: UIImage) {
        let width = CGFloat(100)
        let height = CGFloat(100)
        let spacing = CGFloat(10)
        
        let size = scrollView.contentSize // Kích thước hiện tại
        var count = CGFloat(0)
        
        if (size.width > 0) { // Đang  chứa bao nhiêu hình?
            count = (size.width - spacing ) / (width + spacing)
        }
        
        // Tạo mới một imageview
        let img = UIImageView(frame: CGRect(x: spacing + (width + spacing) * count, y:10, width: width, height: height))
        img.image = image
        scrollView.addSubview(img) // Thêm ảnh mới vào scrollview
        
        // Cập nhật lại kích thước của content size để chứa hình mới
        count += 1
        scrollView.contentSize = CGSize(width: spacing + (width + spacing) * CGFloat(count), height: height)

    }
}

