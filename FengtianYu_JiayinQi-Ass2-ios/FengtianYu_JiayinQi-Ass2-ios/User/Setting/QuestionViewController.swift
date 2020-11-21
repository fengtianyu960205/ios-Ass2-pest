//
//  QuestionViewController.swift
//  FengtianYu_JiayinQi-Ass2-ios
//
//  Created by 俞冯天 on 21/11/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import WebKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>aboutquestion</title>
        </head>
        <body>
        <details>
            <summary style="font-weight:bold;font-size:50px">What is harm score, why would I use it?</summary>

            <p style= "font-size:40px">The harm score represents a predefined harmfulness of each listed species, if the scroe is 100, it means the species is extremely harmful to human while if the score is between 0 to 20, it means the species in not really hamrful but human still need some information about how to deal with them.
            </p>
        </details>
        <br>
        <br>
        <details>
            <summary style="font-weight:bold;font-size:50px">How to use photo screen ?</summary>
            <p style= "font-size:40px">In photo screen , user can take a photo and input their current address or click address button to generate current address automatically.Then they need to input the species name which is in the species list. After uploading, user can see the location in location screen and photo they just upload in pest album page.
            </p>
        </details>
        <br>
        <br>
        <details>
            <summary style="font-weight:bold;font-size:50px">How to use Home map screen ?</summary>
            <p style= "font-size:40px">In this page, there is an Australia map which shows all pests’ location. User can click the location button at right-bottom corner to generate user current location or just type start location in the blank. Then user type destination location and click get direction button. Then user can see some routes in a map and user can zoom the map to see whether there are pests through the route or not. This function is to help tourists plan their journey to avoid pests.
            </p>
        </details>
        <br>
        <br>
        <details>
            <summary style="font-weight:bold;font-size:50px">How to use Species search screen ?</summary>
            <p style= "font-size:40px">In this page, user can search pest in pest list according pest name, city and state.user can scroll the view to change page or click the segment button to change page to search by name, city or state.
            </p>
        </details>
        <br>
        <br>
        <details>
            <summary style="font-weight:bold;font-size:50px">What is User interesting  pest list screen</summary>
            <p style= "font-size:40px">In this screen, user can see their interesting pest list which they just add in pest detail information.
            </p>
        </details>
        </body>
        </html>
        
        
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
