//
//  TableViewController.swift
//  TableProject
//
//  Created by AJ Hughes on 12/13/20.
//  Copyright © 2020 AJ Hughes. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        segue.destination.view.backgroundColor = UIColor.red
     
        //  if let target = segue.destination as? UIViewController {
        //    target.view.backgroundColor = .black
        }
    }
    
