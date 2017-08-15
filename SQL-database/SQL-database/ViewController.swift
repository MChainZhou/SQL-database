//
//  ViewController.swift
//  SQL-database
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let path = Bundle.main.path(forResource: "test", ofType: ".db")
            let connection = try DBConnection(path!)
            print(connection.readonly)
            
            //执行SQL
            try connection.execute("create table t_user(t_user_sex text,t_user_name text)")
            
            let statement = try connection.run("insert into t_user(t_user_sex,t_user_name) values(?,?)", "男","Dream")
            
            print(statement.description)
            
            
        } catch {
            print("出现了异常\(error)");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

