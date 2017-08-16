//
//  Delete.swift
//  SQL-database
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


extension QueryType {
    
    
    //二：删除数据哭所有的表数据
    @discardableResult public func delete() -> Delete {
        let expressionArray:[Expressible?] = [
            Expression<Void>(literal: "DELETE FROM"),
            tableName(),
            whereStatement
        ]
        return Delete(" ".join(expressionArray.flatMap{ $0 }).expression)
    }
}


extension DBConnection {
    public func run(_ delete:Delete) throws->Int {
        let expression = delete.expression
        
        return try dbSync{
            try self.run(expression.template, expression.bindings)
            return self.changes
        }
        
    }
}

public struct Delete: ExpressionType {
    public var template: String
    public var bindings: [Binding?]
    
    public init(_ template: String, _ bindings: [Binding?]) {
        self.template = template
        self.bindings = bindings
    }
}
