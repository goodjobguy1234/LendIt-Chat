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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupChatNav()
        chatTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setupChatNav() {
        navigationItem.title = "Chat"
        
        let phoneButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        var phoneIcon = UIImage(named: "phone-call")
        
        phoneIcon = phoneIcon?.withTintColor(UIColor.blue, renderingMode: .alwaysTemplate)

        phoneButton.setImage(phoneIcon, for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: phoneButton)
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
        let g = textView.safeAreaLayoutGuide
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
