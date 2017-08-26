//
//  ViewController.swift
//  MGRxKitchen
//
//  Created by magic_harly@hotmail.com on 08/24/2017.
//  Copyright (c) 2017 magic_harly@hotmail.com. All rights reserved.
//

import UIKit
import MGRxKitchen
import RxSwift
import RxCocoa

class ViewController: UIViewController , HaveRequestRx , NeedHandleRequestError {

    var errorProvider: PublishSubject<RxMGError> = PublishSubject<RxMGError>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

