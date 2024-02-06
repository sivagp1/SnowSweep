//
//  ImagePickerModel.swift
//  SnowSweep
//
//  Created by Siva Ganesh Polepalli on 5/5/23.
//

import SwiftUI

struct ImagePickerModel: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?

    @Environment(\.presentationMode) var presentationMode


    func makeUIViewController(context: Context) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = .photoLibrary

        imagePicker.delegate = context.coordinator

        return imagePicker

    }


    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {


    }

    func makeCoordinator() -> Coordinator {

        Coordinator(self)

    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: ImagePickerModel

    
        init(_ parent: ImagePickerModel) {

            self.parent = parent

        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let selectedImage = info[.originalImage] as? UIImage {

                parent.selectedImage = selectedImage

            }

            parent.presentationMode.wrappedValue.dismiss()

        }

    }

}


