//
//  PreviewController.swift
//  QuickNote
//
//  Created by dev7 on 1/13/17.
//  Copyright © 2017 dev7. All rights reserved.
//

import UIKit

protocol PreviewControllerDelegate {
    func delete()
}

class PreviewController: UIViewController {
    // MARK: *** Data model
    var image: UIImage?
    
    // MARK: *** UI Elements
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: *** UI events
    
    // MARK: *** Local variables
    var delegate: PreviewControllerDelegate?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        // Thêm nút Xóa
        let deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteButton_Tapped))
        self.navigationItem.setRightBarButton(deleteButton, animated: true)
    }
    
    func deleteButton_Tapped() {
        delegate?.delete()
        _ = self.navigationController?.popViewController(animated: true)
    }
}

