

// No longer using this.



// https://www.javaer101.com/en/article/40758113.html

import UIKit
import MobileCoreServices
import Foundation
import SwiftUI
import FirebaseStorage


/*
struct imagePicker : UIViewControllerRepresentable{
    
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent1: self)
    }
    
    @Binding var shown : Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) ->
        UIImagePickerController {
            
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
            
        return imagepic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {
        
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent : imagePicker!
        
        init(parent1: imagePicker ){
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
        
            let storage = Storage.storage()
            let storingimage = storage.reference().child("temp.jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storingimage.putData(image.jpegData(compressionQuality: 0.35)!, metadata: metadata)
            {(response,err) in
                if(err != nil){
                    print(err?.localizedDescription)
                }
                else{
                    // You can also access to download URL after upload.
                    storingimage.downloadURL { (url, error) in
                      guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        
                        return
                      }
                        // upload to
                       // I plan on storing this URL downloadURL
                    }
                }
            }
        }
    }
}
*/
