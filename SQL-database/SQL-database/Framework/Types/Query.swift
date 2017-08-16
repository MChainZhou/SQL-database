//
//  Query.swift
//  SQL-database
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


//结构体->类型
//操作：增、删、改、查
//没有继承关系
public struct QueryManager {
    //创建表操作
    var from:(name:String,database:String?)
    
    //过滤器(where条件)->统一调用->是否需要条件
    var filters:Expression<Bool?>?
    
    
    fileprivate init(_ name:String,_ database:String?){
        self.from = (name,database)
    }
    
}

//操作类型
//定义抽象->操作类型接口
public protocol QueryType:Expressible{
    var manager:QueryManager {get set}
    
    init(_ name:String,_ database:String?)
    
}

//提供默认的实现
extension QueryType {
    public var expression:Expression<Void> {
        let manager = [Expressible?]()
        
        return ", ".join(manager.flatMap{ $0 }).expression
    }
    //包装数据库表名称
    func tableName() -> Expressible {
        return " ".join([database(namespace: manager.from.name)])
    }
    
    func database(namespace name:String) -> Expressible {
        let name = Expression<Void>(name)
        
        guard let database = manager.from.database else {
            return name
        }
        return ".".join([Expression<Void>(database),name])
    }
}

//实现操作类型
public protocol SchemaType:QueryType {
    static var identifier:String {get}
}

//定义表
public struct Table:SchemaType {
    public static var identifier = "TABLE"
    
    public var manager: QueryManager
    
    public init(_ name: String, _ database: String? = nil) {
        self.manager = QueryManager(name, database)
    }
}
