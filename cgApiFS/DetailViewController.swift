//
//  DetailViewController.swift
//  cgApiFS
//
//  Created by ALLAN CHAI on 21/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    /* https://api.foursquare.com/v2/venues/4b2f1828f964a5207de924e3/tips?client_id=YB4D0XHPQRGOQ1PGDCU1NDD3VJ0PELXV5IW1FET4DQO4BPIM&client_secret=J134ORAK2X0XM4RV4BQVQ4QSBQ4P5D5RDL1JUZYMZZOKU2AV&v=20130815
*/
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    var sushiVenue : SushiVenue?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sushiVenue?.name
         nameLabel.text  = sushiVenue?.name
    
        if sushiVenue?.address != "" {
        addressLabel.text = sushiVenue?.address
        } else {
            addressLabel.text = "unknown address (better don't go) "
        }
        
        if sushiVenue?.phoneNumber != "" {
        phoneLabel.text = sushiVenue?.phoneNumber
        } else {
            phoneLabel.text = "Uncontactable"
        }
        
        if sushiVenue?.url != "" {
        urlLabel.text = sushiVenue?.url
        } else {
            urlLabel.text = "no internet"
        }
        categoryLabel.text = sushiVenue?.category
        
        
        
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
