//
//  ProfileImagePicker.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import Foundation
import SwiftUI
struct ProfileImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    // Create a UIImagePickerController to use as the view controller for selecting an image
    private let controller = UIImagePickerController()
    
    // Create a Coordinator to handle communication between the view and the view controller
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ProfileImagePicker
        
        init(parent: ProfileImagePicker) {
            self.parent = parent
        }
        
        // Handle when an image is selected from the picker
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        // Handle when the picker is canceled
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
    // Create the UIImagePickerController and set its delegate to the Coordinator
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    // No update is necessary
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

