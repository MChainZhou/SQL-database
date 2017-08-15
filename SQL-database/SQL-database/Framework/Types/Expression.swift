//
//  Expression.swift
//  SQL-database
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


//祖宗类：高度抽象的表达式
//操作类型
//字段类型
//数据类型

public protocol Expressible {
    //这是一个sql语句：合并表达式用的
    var expression:Expression<Void> {get}
    
}


//父亲类
//具体抽象字段表达式
//这个协议定义了字段表达式抽象
public protocol ExpressionType:Expressible {
    //具体的字段
    //抽象一：数据类型
    associatedtype UnderlyingType = Void
    
    //抽象二：模版（例如：表名称、字段名称等等）
    var template:String{get}
    
    //抽象三：绑定参数(表字段->参数列表、约束条件等)
    var bindings: [Binding?]{get}
    
    //抽象四：构造方法
    init(_ template:String,_ bindings:[Binding?])
    
}

//处理特殊字段
extension ExpressionType {
    public init(literal:String) {
        self.init(literal, [])
    }
    
    public init(_ indentifer:String) {
        self.init(literal: indentifer.quote())
    }
}

//扩展：字段类型
extension ExpressionType {
    public var expression:Expression<Void> {
        return Expression(template, bindings)
    }
}

//儿子类
public struct Expression<DataType>:ExpressionType {
    //指定具体的数据类型
    public typealias UnderlyingType = DataType
    
    public var template: String
    
    public var bindings: [Binding?]
    
    public init(_ template: String, _ bindings: [Binding?]) {
        self.template = template
        self.bindings = bindings
    }
}

//让我们的Expressible可以是一种可选类型
public protocol OptionalType{
    associatedtype WrappedType
}

//扩展系统的Optional
extension Optional: OptionalType{
    public typealias WrappedType = Wrapped
}

//扩展抽象表达式字段->表达式ExpressionType
//约束一：数据类型约束
//规定泛型类型必须是Value类型
extension ExpressionType where UnderlyingType: Value{
    public init(value:UnderlyingType){
        self.init("?", [value.datatypeValue])
    }
}

//约束二：可选类型
extension ExpressionType where UnderlyingType:OptionalType,UnderlyingType.WrappedType:Value {
    public static var null:Self{
        return self.init(value: nil)
    }
    
    public init(value: UnderlyingType.WrappedType?){
        self.init("?", [value?.datatypeValue])
    }
}

extension Value {
    public var expression:Expression<Void> {
        //最终将表达式合成一个
        return Expression(value: self).expression
    }
}
