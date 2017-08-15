//
//  Schema.swift
//  SQL-database
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


extension QueryType {
    //创建表
    public func creat(_ identifier:String, _ name:Expressible) -> Expressible {
        let  expressionArray:[Expressible?] = [
            Expression<Void>(literal:"CREAT"),
            Expression<Void>(literal:identifier),
            name
        ]
        return " ".join(expressionArray.flatMap{$0})
    }
}

//统一组装类
extension Table {
    
    //构建表
//    public func creat(_ build:())

}

// 构建者模式：具体的构建者
public final class TableBuilder {
    //字段列表->表达式数组
    fileprivate var expressions = [Expressible]()
    
    @discardableResult public func column<V:Value>(_ name:Expression<V>,unique:Bool = false,defaultValue:Expression<V>? = nil) ->TableBuilder {
        return self.column(name, V.declareDataType, unique: unique, defaultValue: defaultValue)
    }
    
    @discardableResult public func column<V : Value>(_ name: Expression<V>, unique: Bool = false, defaultValue: V) -> TableBuilder {
        return self.column(name, V.declareDataType, unique: unique, defaultValue: defaultValue)
    }
    
    @discardableResult public func column(_ name: Expressible,_ datatype: String, unique: Bool = false, defaultValue: Expressible?) -> TableBuilder{
        self.expressions.append(expressionFunc(name, datatype, false, unique,defaultValue))
        return self
    }
    
    private func expressionFunc(_ column:Expressible,_ datatype:String,_ null:Bool,_ unique:Bool = false,_ defaultValue:Expressible?) -> Expressible{
        
        let expressionArray:[Expressible?] = [
            column,//字段的名称
            Expression<Void>(literal: datatype),//字段的类型
            null ? nil : Expression<Void>(literal: "NOT NULL" ),//是否为空
            unique ? Expression<Void>(literal: "UNIQUE" ) : nil,//字段唯一
            //在默认值的前面拼接SQL默认关键字:DEFAULT
            defaultValue.map{"DEFAULT".prefix($0)},//默认值
        ]
        
        return " ".join(expressionArray.flatMap{$0})
    }
}
