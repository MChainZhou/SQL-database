//
//  Insert.swift
//  SQL-database
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

extension QueryType {
    //插入的是一个对象，不是一个值
    public func insert(_ value:Setter,_ more:Setter...)->Insert{
        return self.insert([value] + more)
    }
    
    fileprivate func insert(_ values:[Setter]) -> Insert {
        let insert = values.reduce((column:[Expressible](),values:[Expressible]())) { (insert, setter) in
            (insert.column+[setter.column],insert.values + [setter.value])
        }
        
        //拼接SQL语句->面向对象形式存在
        let expressionArray:[Expressible?] = [
            Expression<Void>(literal: "INSERT"),
            Expression<Void>(literal: "INTO"),
            tableName(),
            //wrap方法给我们的字段名称之间加入","进行分割
            //例如：原来是(id name)->(id,name)
            "".wrap(insert.column) as Expression<Void>,
            Expression<Void>(literal: "VALUES"),
            "".wrap(insert.values) as Expression<Void>
        ]
        
        return Insert(" ".join(expressionArray.flatMap{ $0 }).expression)
    }
}

//执行数据库
extension DBConnection {
    @discardableResult public func run(_ insert:Insert) throws -> Int64 {
        let expression = insert.expression
        
        return try dbSync{
            try self.run(expression.template, expression.bindings)
            return self.lastInsertRowid
        }
    }
}


public struct Insert: ExpressionType {
    public var template: String
    public var bindings: [Binding?]
    
    public init(_ template: String, _ bindings: [Binding?]) {
        self.template = template
        self.bindings = bindings
    }
}
