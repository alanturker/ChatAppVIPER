//
//  FireBaseStorageManager.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 2.05.2022.
//

import Foundation
import FirebaseStorage

final class FireBaseStorageManager {
    
    static let shared = FireBaseStorageManager()
    
    let storage = Storage.storage().reference()
    
    public typealias uploadCompletion = (Result<String,Error>) -> Void
    public typealias downloadCompletion = (Result<URL,Error>) -> Void
    
    public func uploadPicture(with data: Data, fileName: String, completion: @escaping uploadCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { [weak self] metaData, error in
            guard let self = self else { return }
            guard error == nil else {
                //failed to upload
                print("Failed to upload data to Firebase for picture.")
                completion(.failure(StorageErrors.failedToUploadPicture))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get downloadURL of picture uploaded to Firebase")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUploadPicture
        case failedToGetDownloadURL
    }
    
    public func downloadURL(with path: String, completion: @escaping downloadCompletion) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        }
    }
}
