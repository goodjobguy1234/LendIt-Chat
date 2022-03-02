//
//  ViewController.swift
//  LentItChat
//
//  Created by macbook on 26/2/2565 BE.
//

import UIKit
import MultilineTextField
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class ViewController: UIViewController {
    var db: Firestore!
    var chatRef: CollectionReference!
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var sendChatBtn: UIButton!
    @IBOutlet var chatTextFieldHeight: NSLayoutConstraint!
    @IBOutlet var chatTextField: MultilineTextField!
    private let default_height = 45.0
    private var chatListener: ListenerRegistration? = nil
    var phoneNumber = "0639489842"
    
    var itemID = "8eGJu4tFr8qevxUfKQUP"  // itemID for query to find which chatID talk about borrowing this item
    
    //senderID is current login user
//    var senderID = "A9KshCKMdDMhJ5sfzOL15ltVwjG3"
//    var senderName = "Thor are nimanong"
    var senderID = "fVFtKuDvU3cZueU0EuAWifAX0S62"
    var senderName = "Aiden Zaw"
    
    // for another person who receive chat
//    var receiverID = "fVFtKuDvU3cZueU0EuAWifAX0S62"
//    var receiverName = "Aiden Zaw"
    var receiverID = "A9KshCKMdDMhJ5sfzOL15ltVwjG3"
      var receiverName = "Thor are nimanong"
    
    
    var chats: [ChatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        chatRef = db.collection("Chats")
        setupChatNav()
        
        chatTextField.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.showsVerticalScrollIndicator = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readMessageListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        chatListener?.remove()
    }
    
    func setupChatNav() {
        navigationItem.title = senderName
        
        let phoneButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        phoneButton.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        
        var phoneIcon = UIImage(named: "phone-call")
        
        phoneIcon = phoneIcon?.withTintColor(UIColor.blue, renderingMode: .alwaysTemplate)

        phoneButton.setImage(phoneIcon, for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: phoneButton)
        
    }
    
    @objc public func didTapPhoneButton() {
        callNumber(phoneNumber: phoneNumber)
    }
    
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
          let application:UIApplication = UIApplication.shared
          if (application.canOpenURL(phoneCallURL as URL)) {
              application.openURL(phoneCallURL as URL);
        }
      }
    }

    @IBAction func onClickSend(_ sender: Any) {
        
        if(!chatTextField.text.isEmpty) {
            let text = chatTextField.text!
            if (addMessage(text: text)) {
                chatTextField.text = ""
                chatTextField.placeholder = ""
                UIView.animate(withDuration: 0.3) {
                    self.chatTextFieldHeight.constant = self.default_height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func addMessage(text: String) -> Bool {
        var canPostMessage = true
        chatRef.whereField("itemID", isEqualTo: itemID).limit(to: 2).getDocuments(completion: { (querySnapshot, err) in
            if err != nil {
                print("Error")
                canPostMessage = false
            }
            
            if let messageCollection = querySnapshot?.documents[0].reference.collection("messages") {
                
                let newChatData = createChatFireStoreData(body: text, senderID: self.senderID, receiverID: self.receiverID, receiverName: self.receiverName, senderName: self.senderName, timeStamp: Timestamp(date: Date()))
                                                          
                messageCollection.addDocument(data: newChatData) { err in
                    if err != nil {
                        print("Error in writing data")
                        canPostMessage = false
                    }
                }
            }
            
        })
            
        return canPostMessage
    }
    
    func readChat(querySnapshot: QuerySnapshot) {
        let messageCollection = querySnapshot.documents[0].reference.collection("messages")
        chatListener = messageCollection.order(by: "timeStamp", descending: false ).addSnapshotListener({ (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(err!)")
                return
            }
            self.chats = []
            
            documents.forEach { QueryDocumentSnapshot in
                let data = QueryDocumentSnapshot.data()
                if let chatData = ChatModel(data: data, currentLoginID: self.senderID) {
                    self.chats.append(chatData)
                }
            }
            self.chatTableView.reloadData()
            self.chatTableView.layoutIfNeeded()
            self.chatTableView.setContentOffset(CGPoint(x: 0, y: self.chatTableView.contentSize.height - self.chatTableView.frame.height), animated: true)
        })
    }
    
    func readMessageListener() {
        let chatDocument = chatRef.whereField("itemID", isEqualTo: itemID).limit(to: 2)
    
        chatDocument.getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error")
                return
            }
            
            if let doc = querySnapshot {
                if doc.count == 0 {
                    self.chatRef.addDocument(data: ["itemID": self.itemID])
                    return self.readMessageListener()
                } else {
                    self.readChat(querySnapshot: doc)
                }
              
            }
        }
    }
}

extension UITextView {
       func numberOfLines(textView: UITextView) -> Int {
        let layoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}

extension ViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let numberOfTextLine = textView.numberOfLines(textView: chatTextField)
        
        if(numberOfTextLine >= 2) {
            UIView.animate(withDuration: 0.3) { [self] in
                self.chatTextFieldHeight.constant = 100.0
                self.view.layoutIfNeeded()
            }
           
        } else {
            UIView.animate(withDuration: 0.3) {
                self.chatTextFieldHeight.constant = self.default_height
                self.view.layoutIfNeeded()
            }
            
            self.chatTableView.layoutIfNeeded()
            self.chatTableView.setContentOffset(CGPoint(x: 0, y: self.chatTableView.contentSize.height - self.chatTableView.frame.height), animated: true)
            
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentChat = chats[indexPath.row]
        
        if(currentChat.type == .customer) {
            let customerBubble = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerBubbleTableViewCell
            customerBubble.chatText.text = currentChat.textString
            return customerBubble
            
        } else {
            let myBubble = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
            myBubble.userText.text = currentChat.textString
            return myBubble
        }
    }
}
