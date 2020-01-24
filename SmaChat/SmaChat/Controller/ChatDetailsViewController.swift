//
//  ChatDetailsViewController.swift
//  SmaChat
//
//  Created by Amr on 10/1/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit
import Firebase
class ChatDetailsViewController: UIViewController {

    @IBOutlet weak var ChatTable: UITableView!
    @IBOutlet weak var MessageTxtField: UITextField!
    @IBOutlet weak var SENDbtnOutLet: UIButton!
    var room:Room?
    var ChatMessArray = [SingleMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = room?.RoomName
        self.ChatTable.delegate = self
        self.ChatTable.dataSource = self
        self.ChatTable.separatorStyle = .none
        self.ChatTable.allowsSelection = false
        FETCHMESSAGES()
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        view.addGestureRecognizer(tapGest)
    }
    @objc func dismisskeyboard(){
        view.endEditing(true)
    }

    @IBAction func SENDBTN(_ sender: Any) {
        
        if self.MessageTxtField.text?.isEmpty == true {
            self.displayErrorMessage(thetitle: "Smack", errorMess: "Empty Message!")
        }
        guard let messTEXT = self.MessageTxtField.text, messTEXT.isEmpty == false else {return}
        self.MessageTxtField.text = ""
        self.dismisskeyboard()
        SENDMESSAGE(CHATTEXT: messTEXT) { (isSuccess) in
            if (isSuccess){
                print("message has been sent successfully")
            }else{
                self.displayErrorMessage(thetitle: "Smack", errorMess: "Weak Internet Connection")
            }
        }
    }
    
    func SENDMESSAGE(CHATTEXT: String, completion: @escaping (_ isSucces: Bool) -> () ){
        guard let USERID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference()
        
        GETUSERNAMEWITHID(id: USERID) { (usernameee) in
            if let USERNAME = usernameee{
                if let roomID = self.room?.RoomID{
                    let MessageDataArray: [String: Any] = ["SenderName": USERNAME, "MessageText": CHATTEXT, "SenderID": USERID]
                    
                    let THEROOM = ref.child("Rooms").child(roomID)
                    THEROOM.child("Messages").childByAutoId().setValue(MessageDataArray, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            completion(true)
                        }else{
                            completion(false)
                        }
                    })
                }
            }
        }
                }
    
    func GETUSERNAMEWITHID(id: String, completion: @escaping (_ UserNamee: String?) -> () ){
        let ref = Database.database().reference()
        let user = ref.child("users").child(id)
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let USERNAME = snapshot.value as? String{
                completion(USERNAME)
            }else{
                completion(nil)
            } }
    }
    
    func FETCHMESSAGES(){
        guard let roomID = self.room?.RoomID else {return}
        let DBRef = Database.database().reference()
        DBRef.child("Rooms").child(roomID).child("Messages").observe(.childAdded) { (Snapshoot) in
         if let DataOfMessageArray = Snapshoot.value as? [String: Any] {
            
            guard let MessageTextxx = DataOfMessageArray["MessageText"] as? String, let SenderNamexx = DataOfMessageArray["SenderName"] as? String, let useridx = DataOfMessageArray["SenderID"] as? String else {return}
            
            let Mess = SingleMessage.init(MessageKey: Snapshoot.key, SenderName: SenderNamexx, MessageTXT: MessageTextxx, UserIDD: useridx)
            self.ChatMessArray.append(Mess)
            self.ChatTable.reloadData()
                
            }
        }
    }
   
    
}


extension ChatDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCurrentMessage = self.ChatMessArray[indexPath.row]
        let cell = ChatTable.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! ChatCellx
        cell.setMessage(mess: myCurrentMessage)
       
        if(myCurrentMessage.UserIDD == Auth.auth().currentUser?.uid){
            cell.setBubbleType(type: .outcoming)
        }else{
            cell.setBubbleType(type: .incoming)
        }
        return cell
    }
    
    
}
