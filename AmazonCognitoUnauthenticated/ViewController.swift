//
//  ViewController.swift
//  AmazonCognitoUnauthenticated
//
//  Created by Grzegorz Tatarzyn on 13/12/2014.
//  Copyright (c) 2014 Grzegorz Tatarzyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let nickKey: String = "nick"
    private let emailKey: String  = "email"
    private let cognitoStore: CognitoStore = CognitoStore()
    
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedIdentity:", name: CognitoStoreReceivedIdentityIdNotification, object: cognitoStore)
        
        cognitoStore.requestIdentity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveUserInfo(sender: AnyObject) {
        if nicknameField.hasText() {
            cognitoStore.saveItem(nickKey, value: nicknameField.text)
        }

        if emailField.hasText() {
            cognitoStore.saveItem(emailKey, value: emailField.text)
        }
    }

    func receivedIdentity(notification: NSNotification) {
        requestUserInfo()
    }
    
    private func requestUserInfo() {
        cognitoStore.loadInfo(updateDisplayWithUserInfo)
    }
    
    private func updateDisplayWithUserInfo(userInfo: Dictionary<NSObject, AnyObject>) {
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            self.saveButton.enabled = true
            
            if var nick: String = userInfo[self.nickKey] as? String {
                self.nicknameField.text = nick
            }
            
            if var email: String = userInfo[self.emailKey] as? String {
                self.emailField.text = email
            }
        })
    }
}

