//
//  ViewController.swift
//  AmazonCognitoUnauthenticated
//
//  Created by Grzegorz Tatarzyn on 13/12/2014.
//  Copyright (c) 2014 Grzegorz Tatarzyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let cognitoStore: CognitoStore = CognitoStore()
    
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cognitoStore.requestIdentity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveUserInfo(sender: AnyObject) {
        if nicknameField.hasText() {
            cognitoStore.saveItem("nick", value: nicknameField.text)
        }

        if emailField.hasText() {
            cognitoStore.saveItem("email", value: nicknameField.text)
        }
    }

}

