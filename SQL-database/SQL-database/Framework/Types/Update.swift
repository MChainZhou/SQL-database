//
//  Update.swift
//  SQL-database
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

extension QueryType {
    public func update(_ values:Setter...) -> Update {
        return self.update(values)
    }
    public func update(_ values:[Setter]) -> Update {
        let expressionArray:[Expressible?] = [
            Expression<Void>(literal:"UPDATE"),
            tableName(),
            Expression<Void>(literal: "SET"),
            ", ".join(values.map{"=".join([$0.column,$0.value])}),
            whereStatement
        ]
        
        return Update(" ".join(expressionArray.flatMap{$0}).expression)
        
    }
    
}


extension DBConnection {
    public func run(_ update:Update) throws -> Int {
        let expression = update.expression
        return try dbSync{
            try self.run(expression.template, expression.bindings)
            
            return self.changes
        }
    }
}

public struct Update: ExpressionType {
    public var template: String
    public var bindings: [Binding?]
    public init(_ template: String, _ bindings: [Binding?]) {
        self.template = template
        self.bindings = bindings
    }
}
