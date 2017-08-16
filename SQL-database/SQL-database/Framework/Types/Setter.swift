//
//  Setter.swift
//  SQL-database
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

//以对象的形式保存数值和表达式
public struct Setter {
    //字段名称
    let column:Expressible
    //字段的值
    let value:Expressible
    
    
    //构造方法重载
    init<V: Value>(column:Expression<V>,value:Expression<V>) {
        self.column = column
        self.value = value
    }
    
    init<V: Value>(column:Expression<V>,value:V) {
        self.column = column
        self.value = value
    }
    
    init<V: Value>(column:Expression<V?>,value:Expression<V>) {
        self.column = column
        self.value = value
    }
    
    init<V: Value>(column:Expression<V?>,value:Expression<V?>) {
        self.column = column
        self.value = value
    }
    
    init<V: Value>(column:Expression<V?>,value:V?) {
        self.column = column
        self.value = Expression<V?>(value: value)
    }
}

//Setter也是一个表达式
extension Setter: Expressible{
    public var expression: Expression<Void> {
        return "=".infixs(column, value,wrap: false)
    }
}

//定义运算符
precedencegroup ColumnAssignment {
    associativity: left
    assignment: true
    lowerThan: AssignmentPrecedence
}

infix operator --> :ColumnAssignment

//-->方法重载
public func --><V: Value>(column:Expression<V>,value:Expression<V>) -> Setter {
    return Setter(column: column, value: value);
}

public func --><V: Value>(column:Expression<V>,value:V) -> Setter {
    return Setter(column: column, value: value);
}

public func --><V: Value>(column:Expression<V?>,value:Expression<V>) -> Setter {
    return Setter(column: column, value: value);
}

public func --><V: Value>(column:Expression<V?>,value:Expression<V?>) -> Setter {
    return Setter(column: column, value: value);
}

public func --><V: Value>(column:Expression<V?>,value:V?) -> Setter {
    return Setter(column: column, value: value);
}
