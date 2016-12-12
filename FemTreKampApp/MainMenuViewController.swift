//
//  ViewController.swift
//  FemTreKampApp
//
//  Created by Jani Pasanen on 2016-11-22.
//  Copyright © 2016 Jani Pasanen. All rights reserved.
//

import UIKit


class MainMenuViewController: UIViewController {
    
    
    private struct Constants {
        static let OpenBookingSegue = "Open Booking"
        static let RegisterBookingSegue = "Register Booking"
        static let ChangeBookingSegue = "Change Booking"
        
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        <#code#>
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

