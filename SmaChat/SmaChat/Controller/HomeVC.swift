//
//  HomeVC.swift
//  SmChat
//
//  Created by Amr on 9/7/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController  {

    @IBOutlet weak var RoomsTableView: UITableView!
    @IBOutlet weak var RoomTxtField: UITextField!
    var RoomModuleArray = [Room]()
    //called only once
    override func viewDidLoad() {
        super.viewDidLoad()
        ObserveRooms()
        self.RoomsTableView.delegate = self
        self.RoomsTableView.dataSource = self
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        view.addGestureRecognizer(tapGest)
    }
    @objc func dismisskeyboard(){
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil){
            //performSegue(withIdentifier: "ToLogin", sender: nil)
            BackToLogin()
        }
    }
    
    func ObserveRooms(){
        let ref = Database.database().reference()
        ref.child("Rooms").observe(.childAdded) { (Snapshot) in
            if let MyDataArray = Snapshot.value as? [String: Any] {
                if let roomname = MyDataArray["roomName"] as? String{
                    let FinallyMyChatRoom = Room.init(RoomName: roomname, RoomID: Snapshot.key)
                         self.RoomModuleArray.append(FinallyMyChatRoom)
                         self.RoomsTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
       try! Auth.auth().signOut()
        BackToLogin()
    }
    
    func BackToLogin(){
        let BacktoLoginScreen = self.storyboard?.instantiateViewController(withIdentifier: "LoginScreen") as! ViewController
        self.present(BacktoLoginScreen, animated: true, completion: nil)
    }
    @IBAction func CreateRoom(_ sender: UIButton){
        if (self.RoomTxtField.text?.isEmpty == true){
            self.displayErrorMessage(thetitle: "Empty Room Name", errorMess: "please type the room name")
        }
        guard let TheRoomName = self.RoomTxtField.text, TheRoomName.isEmpty == false else {return}
        let DBref = Database.database().reference()
        let Room = DBref.child("Rooms").childByAutoId()
        
        let DataArray:[String: Any] = ["roomName": TheRoomName]
        Room.setValue(DataArray) { (error, ref) in
            if (error == nil){
                self.RoomTxtField.text = ""
                self.displayErrorMessage(thetitle:"New Room",errorMess:"#New Room has been Created")
            }else{
                self.displayErrorMessage(thetitle:"Oooh ,Smack Error",errorMess:"Something Wrong!, Try Again")
            }
        }
        
    }

}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.RoomModuleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ROOM = self.RoomModuleArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        cell.textLabel?.text = "#\(ROOM.RoomName!)"
        cell.textLabel?.textColor = #colorLiteral(red: 0.3424951425, green: 0.3424951425, blue: 0.3424951425, alpha: 1)
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SelectedRoom = self.RoomModuleArray[indexPath.row]
        let mySelectedChatRoom = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoom") as! ChatDetailsViewController
        mySelectedChatRoom.room = SelectedRoom
        self.navigationController?.pushViewController(mySelectedChatRoom, animated: true)
    }
    
}
