//
//  OpenBookingByNumberViewController.swift
//  FemTreKampApp
//
//  Created by Jani Pasanen on 2016-12-02.
//  Copyright © 2016 Jani Pasanen. All rights reserved.
//

import UIKit

class OpenBookingByNumberViewController: UIViewController {

    
    
    @IBAction func OpenButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Open with number button segue", sender:self)
    
    
        
        
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
