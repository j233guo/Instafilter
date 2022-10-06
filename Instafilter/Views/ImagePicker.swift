//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Jiaming Guo on 2022-10-05.
//

import PhotosUI
import SwiftUI

// This protocol builds on View, which means the struct can be used inside a SwiftUI view hierarchy
// But we do not provide a body property because the view's body is the view controller itself
// It just shows whatever UIKit sends back
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    typealias UIViewControllerType = PHPickerViewController
    
    // Responsible for creating the initial view controller
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // Create a photo picker configuration
        var config = PHPickerConfiguration()
        // Ask the configuration to provide only images
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    // Let us update the view controller when some SwiftUI state changes
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Tell the picker to go away
            picker.dismiss(animated: true)
            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else { return }
            // If this has an image we can use, use it
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
