//
//  SSManager.swift
//  ShareSchedule
//
//  Created by Developer Kuwa on 2020/10/17.
//  Copyright © 2020 クワシマ・ユウキ. All rights reserved.
//

import Foundation
import Firebase
import CryptoKit
import GoogleSignIn

class SSManager{
    
    static let shared = SSManager()
    
    
    
    init(){
        
    }
    
    func createMailHash(email: String?) -> String{
        let user_mail = email
        let user_mail_data = user_mail?.data(using: .utf8)
        let user_id = SHA256.hash(data: user_mail_data!).compactMap{String(format: "%02x", $0)}.joined()
        return user_id
    }
    
    func isUserDocumentAvailable(user_id: String, completion: ((Bool) -> Void)?){
        Firestore.firestore().collection("users").document(user_id).getDocument{(snap, error) in
            if let _ = error {
                if let comp = completion{
                    comp(false)
                }
                return
            }
            guard let _ = snap?.data() else {
                if let comp = completion{
                    comp(false)
                }
                return
            }
            if let comp = completion{
                comp(true)
            }
        }
    }
    
    func setDocumentToUser(user_id: String, content: [String: Any], completion: (() -> Void)?){
        Firestore.firestore().collection("users").document(user_id).setData(
            content,
            merge: true,
            completion: { Void in
                if let comp = completion{
                    comp()
                }
            }
        )
    }
    
    func getDocumentFromUser(user_id: String, completion: (([String: Any?]) -> Void)?){
        Firestore.firestore().collection("users").document(user_id).getDocument{(snap, error) in
            if let _ = error{
                return
            }
            guard let data = snap?.data() else {
                return
            }
            if let comp = completion{
                comp(data)
            }
        }
    }
    
    func isYoteiDocumentAvailable(yotei_id: String, completion: ((Bool) -> Void)?){
        Firestore.firestore().collection("yotei").document(yotei_id).getDocument{(snap, error) in
            if let _ = error {
                if let comp = completion{
                    comp(false)
                }
                return
            }
            guard let _ = snap?.data() else {
                if let comp = completion{
                    comp(false)
                }
                return
            }
            if let comp = completion{
                comp(true)
            }
        }
    }
    
    func setDocumentToYotei(yotei_id: String, content: [String: Any], completion: (() -> Void)?){
        Firestore.firestore().collection("yotei").document(yotei_id).setData(
            content,
            merge: true,
            completion: { Void in
                if let comp = completion{
                    comp()
                }
            }
        )
    }
    
    func getDocumentFromYotei(yotei_id: String, completion: (([String: Any?]) -> Void)?){
        Firestore.firestore().collection("yotei").document(yotei_id).getDocument{(snap, error) in
            if let _ = error{
                return
            }
            guard let data = snap?.data() else {
                return
            }
            if let comp = completion{
                comp(data)
            }
        }
    }
    
    func deleteDocumentFromYotei(yotei_id: String, completion: (() -> Void)?){
        Firestore.firestore().collection("yotei").document(yotei_id).delete(completion: {Void in
            if let comp = completion{
                comp()
            }
        })
    }
    
    func createRandomYoteiID() -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let tempStr = String((0..<50).map{ _ in letters.randomElement()! })
        let data = tempStr.data(using: .utf8)
        let yotei_id = SHA256.hash(data: data!).compactMap { String(format: "%02x", $0) }.joined()
        return yotei_id
    }
    
    func deleteDocumentFromUsers(user_id: String, completion: (() -> Void)?){
        Firestore.firestore().collection("users").document(user_id).delete(completion: { Void in
            if let comp = completion{
                comp()
            }
        })
    }
    
    
}
