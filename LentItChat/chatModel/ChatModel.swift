//
//  ChatModel.swift
//  LentItChat
//
//  Created by macbook on 28/2/2565 BE.
//

import Foundation

enum ChatType {
    case user
    case customer
}

struct ChatModel {
    var type: ChatType = ChatType.user
    var textString: String
}

