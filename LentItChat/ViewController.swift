//
//  ViewController.swift
//  LentItChat
//
//  Created by macbook on 26/2/2565 BE.
//

import UIKit
import MultilineTextField

class ViewController: UIViewController {

    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var sendChatBtn: UIButton!
    @IBOutlet var chatTextFieldHeight: NSLayoutConstraint!
    @IBOutlet var chatTextField: MultilineTextField!
    private let default_height = 45.0
    var phoneNumber = "0639489842"
    
    var chats: [ChatModel] = [
        ChatModel(type: .user, textString: "Hello, sir where should we meet"),
        ChatModel(type: .customer, textString: "Hi, let meet at Assumption university on 3 march."),
        ChatModel(textString: "Okay and what time is it?"),
        ChatModel(type: .customer, textString: "at 12 pm. How is it sound?"),
        ChatModel(textString: "Can it be 14:30 pm? I not sure, I can arrive at 12"),
        ChatModel(type: .customer, textString: "Sureee"),
        ChatModel(textString: "Thank you so nuch, see ya!"),
        ChatModel(type: .customer, textString: "See you! and have a nice day")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupChatNav()
        chatTextField.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.showsVerticalScrollIndicator = false
        
        // To scroll to the buttom when open the chat
        chatTableView.layoutIfNeeded()
        chatTableView.setContentOffset(CGPoint(x: 0, y: chatTableView.contentSize.height - chatTableView.frame.height), animated: true)
    }
    
    func setupChatNav() {
        navigationItem.title = "Chat"
        
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
            let newChat = ChatModel(textString: chatTextField.text)
            chats.append(newChat)
            chatTextField.text = ""
            chatTextField.placeholder = ""
            UIView.animate(withDuration: 0.3) {
                self.chatTextFieldHeight.constant = self.default_height
                self.view.layoutIfNeeded()
            }
            
            
            chatTableView.reloadData()
            chatTableView.layoutIfNeeded()
            chatTableView.setContentOffset(CGPoint(x: 0, y: chatTableView.contentSize.height - chatTableView.frame.height), animated: true)
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
