//
//  ChatModel.swift
//  LentItChat
//
//  Created by macbook on 28/2/2565 BE.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

enum ChatType {
    case user
    case customer
}

struct ChatModel {
    var type: ChatType = ChatType.user
    var textString: String
    var senderID: String
    var senderName: String
    var receiverID: String
    var receiverName: String
    var timeStamp: Timestamp
    
    init?(data: [String: Any], currentLoginID: String) {
        guard let textString = data["body"] as? String,
              let senderID = data["senderID"] as? String,
              let senderName = data["senderName"] as? String,
              let receiverID = data["receiverID"] as? String,
              let receiverName = data["receiverName"] as? String,
              let timeStamp = data["timeStamp"] as? Timestamp  else {
                  return nil
              }
        
        self.textString = textString
        self.senderID = senderID
        self.receiverID = receiverID
        self.receiverName = receiverName
        self.senderName = senderName
        self.timeStamp = timeStamp
        
        if(self.senderID == currentLoginID) {
            self.type = .user
        } else {
            self.type = .customer
        }
    }
    
}

func createChatFireStoreData(body: String, senderID: String, receiverID: String, receiverName: String, senderName: String, timeStamp: Timestamp) -> [String: Any] {
    return [
        "body": body,
        "receiverID": receiverID,
        "receiverName": receiverName,
        "senderID": senderID,
        "senderName": senderName,
        "timeStamp": timeStamp
    ]
}
