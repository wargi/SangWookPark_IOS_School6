//
//  ViewController.swift
//  While
//
//  Created by 박상욱 on 2018. 1. 18..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loop : While = While()
        
        loop.timesTable(times: 4)
        print("\(loop.triangular(number: 10))")
        print("\(loop.addAll(num: 12479))")
        print("\(loop.revers(num: 37591))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

