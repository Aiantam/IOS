//
//  NoteEditController.swift
//  QuickNote
//
//  Created by dev7 on 1/13/17.
//  Copyright © 2017 dev7. All rights reserved.
//

import UIKit

class NoteEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PreviewControllerDelegate {
    // MARK: *** Data model
    var database : OpaquePointer?
    
    // MARK: *** UI Elements
    @IBOutlet weak var NamesTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var slideshowScrollView: UIScrollView!
    
    var imagePicker = UIImagePickerController()
    
    // MARK: *** UI events
    
    @IBAction func addImageButton_Tapped(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    
    // MARK: *** Local variables
    var newImages = [UIImage]()
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButton(contentTextView)
        addDoneButton(to: NamesTextField)
        
        // Thêm nút Save
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote_Tapped))
        self.navigationItem.setRightBarButton(saveButton, animated: true)


        // Thêm các hình ảnh vào scrollview
        for item in (note?.images)!  {
            let image = item as! Image
            addImage(to: slideshowScrollView, with: UIImage(data: image.data! as Data)!)
        }
        
        imagePicker.delegate = self
    }
    
    func saveNote_Tapped() {

        
        // Thêm vào các tags mới

        // *** Cập nhật nội dung
        note!.content = contentTextView.text
        
        // Chỉ lấy 30 kí tự đầu để làm preview
        if (note!.content?.characters.count)! > 45 {
            let index = note!.content?.index((note!.content?.startIndex)!, offsetBy: 45)
            note!.preview = note!.content?.substring(to: index!).appending("...")
        } else {
            note!.preview = note!.content
        }
        
        // *** Cập nhật lại hình ảnh, chỉ lưu các hình ảnh thêm vì nếu xóa là xóa luôn!
        for selectedImage in self.newImages {
            let image = Image.create() as! Image
            image.data = UIImageJPEGRepresentation(selectedImage, 1) as NSData?
            note!.addToImages(image)
        }
        
        DB.save() // Cập nhật CSDL
        
        alert(title: "Success", message: "Your note has been updated!") { _ in
            self.delegate?.doneEditing()
            // Quay lại màn hình trước đó
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Lúc tạo ra scrollView height 120
    func addImage(to scrollView: UIScrollView, with image: UIImage) {
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
        
        
        img.tag = Int(count) // Bổ sung thông tin cho biết đang là tấm ảnh thứ mấy
        img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(previewImage_Tapped))
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        
        scrollView.addSubview(img) // Thêm ảnh mới vào scrollview
        
        // Cập nhật lại kích thước của content size để chứa hình mới
        count += 1
        scrollView.contentSize = CGSize(width: spacing + (width + spacing) * CGFloat(count), height: height)
        
    }
    
    var selectedIndex = -1
    
    func previewImage_Tapped(sender: UITapGestureRecognizer) {
        self.selectedIndex = sender.view!.tag
        performSegue(withIdentifier: "SeguePreviewID", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeguePreviewID" {
            let images = note?.images?.allObjects as! [Image]
            let image = UIImage(data: images[self.selectedIndex].data as! Data)
            
            let dest = segue.destination as! PreviewController
            dest.image = image
            dest.delegate = self
        }
    }
    
    // MARK: *** PreviewControllerDelegate
    func delete() {
        // Cập nhật data model - Bỏ đi ảnh được chọn
        let images = note?.images?.allObjects as! [Image]
        let image = images[self.selectedIndex]
        note?.removeFromImages(image)
        
        // Loại bỏ hình được chọn
        for i in 0..<slideshowScrollView.subviews.count {
            if i == self.selectedIndex {
                slideshowScrollView.subviews[i].removeFromSuperview()
            }
        }

        DB.save() // Cập nhật CSDL
    }
    
    // MARK: *** ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImages += [pickedImage] // Đưa vào hàng đợi để lưu
            addImage(to: slideshowScrollView, with: pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

}

