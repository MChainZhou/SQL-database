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
            
//            //执行SQL
//            try connection.execute("create table t_user(t_user_sex text,t_user_name text)")
//            
//            let statement = try connection.run("insert into t_user(t_user_sex,t_user_name) values(?,?)", "男","Dream")
//            
//            print(statement.description)
            let table = Table("t_user")
            print("表名：\(table.manager.from)")
            let name = Expression<String>("t_user_name")
            let id = Expression<Int>("t_user_id")
            
            
            let sql = table.creat({ (builder) in
                builder.column(name).column(id)
            })
            
            try connection.run(sql)
            
            //测试插入语句
            let insert = table.insert(id --> 10, name --> "Dream")
            let rowid = try connection.run(insert)
            
            print(rowid)
            
            let insert_1 = table.insert(id --> 20, name --> "Andy同学")
            try connection.run(insert_1)
            
            //测试更新
            let update = table.update(id --> 30, name --> "Jock")
            
            let row = try connection.run(update)
            print("....\(row)")
            
            //添加条件删除
            let filter = table.filter(id == 10)
                        //采用带条件的filter执行删除
            //            let delete = filter.delete()
            //            try connection.run(delete)
            
//            let update = filter.update(name --> "Somebody同学")
            let  updates = filter.update(name --> "haha")
            
            try connection.run(updates)
            
            
        } catch {
            print("出现了异常\(error)");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

