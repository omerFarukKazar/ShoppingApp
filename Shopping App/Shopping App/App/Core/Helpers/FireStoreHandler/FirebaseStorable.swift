//
//  FirebaseStorable.swift
//  Shopping App
//
//  Created by Ömer Faruk Kazar on 27.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseStorage

protocol FirebaseStorable: UserDefaultsAccessible,
                           FireBaseFireStoreAccessible {}

extension FirebaseStorable {
    /**
     Uploads the given image data to FirebaseStorage.

     - parameters:
        - imageData:: Data of the image.
        - completion:: If upload operation is successful, returns url which is the URL of uploaded image on Firebase. Else returns error.

     # Notes: #
     1.  uploadTask returns metadata and downloadURL, these parameters can be used in the future in case of need.
     */
    func upload(imageData: Data,
                completion: @escaping ((_ url: URL?,
                                        _ error: Error?) -> Void)) {
        let storageRef = Storage.storage().reference(withPath: "profilePhotos")
        let data = imageData

        guard let uid = uid else { return }
        let imageRef = storageRef.child(uid)

        let uploadTask = imageRef.putData(data, metadata: nil) { (_, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            //          guard let metadata = metadata else {
            //
            //            return
            //          }
            // Metadata contains file metadata such as size, content-type.
            //          let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil, error)
                    return
                }
                completion(downloadURL, nil)
            }
        }
    }
}
