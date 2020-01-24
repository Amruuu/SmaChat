//
//  ChatCellx.swift
//  SmaChat
//
//  Created by Amr on 10/8/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit

class ChatCellx: UITableViewCell {
    
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var ChatTextView: UITextView!
    @IBOutlet weak var ChatStack: UIStackView!
    @IBOutlet weak var ChatContainer: UIView!
    
    enum bubbleType {
        case incoming
        case outcoming
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        ChatContainer.layer.cornerRadius = 7
    }
    func setMessage(mess: SingleMessage){
        UsernameLabel.text = mess.SenderName
        ChatTextView.text = mess.MessageTXT
    }
    func setBubbleType(type: bubbleType){
        if(type == .incoming) {
            ChatStack.alignment = .leading
            ChatContainer.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            ChatTextView.textColor = #colorLiteral(red: 0.207699158, green: 0.207699158, blue: 0.207699158, alpha: 1)
        } else if(type == .outcoming){
            ChatStack.alignment = .trailing
            ChatContainer.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            ChatTextView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
