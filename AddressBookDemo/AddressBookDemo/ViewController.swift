//
//  ViewController.swift
//  AddressBookDemo
//
//  Created by useradmin on 2018/11/22.
//  Copyright © 2018年 francis. All rights reserved.
//

import UIKit
import AddressBook

class ViewController: UIViewController {
    
    lazy var addressBook: ABAddressBook = {
        let ab: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        return ab;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configConnectBtn()
    }
    
    
    func configConnectBtn(){
        let targetBtn = UIButton.init(type: .custom)
        targetBtn.setTitle("通讯录", for: .normal)
        targetBtn.backgroundColor = UIColor.black
        targetBtn.setTitleColor(UIColor.white, for: .normal)
        targetBtn.addTarget(self, action: #selector(connectBtnAction(button:)), for: .touchUpInside)
        self.view.addSubview(targetBtn)
        targetBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        targetBtn.center = self.view.center
    }
    
    @objc func connectBtnAction(button:UIButton){
        self.contactConfig()
    }
    
    //MARK: - contact config
    
    func contactConfig() {
        switch ABAddressBookGetAuthorizationStatus() {
        case .denied :
            self.contactRefuse()
            break
        case .restricted:
            self.contactRefuse()
            break
        case .authorized:
            self.contactAuthorized()
            break
        case .notDetermined:
            self.requestContact()
            break
        }
    }
    
    func contactRefuse() {
        
    }
    
    func contactAuthorized(){
        let contract = LFContractViewController()
        contract.contactCallBackBlock { (selectArray) in
            for person in selectArray{
                print(person.name ?? "None",person.phone ?? "None")
            }
        }
        self.present(contract, animated: true) {
            
        }
    }
    
    func requestContact(){
        ABAddressBookRequestAccessWithCompletion(addressBook) { (granted:Bool, error:CFError!) in
            DispatchQueue.main.async {
                if !granted{
                    self.contactRefuse()
                }else{
                    self.contactAuthorized()
                }
            }
        }
        
    }


}

