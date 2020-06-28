//
//  ImagePicker.swift
//  merchant-app
//
//  Created by Aashish Thoutam on 6/27/20.
//  Copyright © 2020 Aashish Thoutam. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    private var presentationMode

    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void

    final class Coordinator: NSObject,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate {

        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void

        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            var uiImage: UIImage?
            
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                uiImage = editedImage
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                uiImage = originalImage
            }
//            print(info[UIImagePickerController.InfoKey.imageURL])
            onImagePicked(uiImage!)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
