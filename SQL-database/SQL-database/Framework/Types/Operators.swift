//
//  Operators.swift
//  Dream_Architect_SQLiteFramework
//
//  Created by Dream on 2017/7/3.
//  Copyright © 2017年 Tz. All rights reserved.
//

/*********"&&"重载运算符操作**start**********/
//"&&"重载运算符操作
public func &&(lhs: Expression<Bool>, rhs: Expression<Bool>) -> Expression<Bool> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Expression<Bool>, rhs: Expression<Bool?>) -> Expression<Bool?> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Expression<Bool?>, rhs: Expression<Bool>) -> Expression<Bool?> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Expression<Bool?>, rhs: Expression<Bool?>) -> Expression<Bool?> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Expression<Bool>, rhs: Bool) -> Expression<Bool> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Expression<Bool?>, rhs: Bool) -> Expression<Bool?> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Bool, rhs: Expression<Bool>) -> Expression<Bool> {
    return "AND".infixs(lhs, rhs)
}
public func &&(lhs: Bool, rhs: Expression<Bool?>) -> Expression<Bool?> {
    return "AND".infixs(lhs, rhs)
}
/************************end************************/


/************"=="重载运算符操作******start*************/
//"=="重载运算符操作
public func ==<V : Value>(lhs: Expression<V>, rhs: Expression<V>) -> Expression<Bool> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: Expression<V>, rhs: Expression<V?>) -> Expression<Bool?> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: Expression<V?>, rhs: Expression<V>) -> Expression<Bool?> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: Expression<V?>, rhs: Expression<V?>) -> Expression<Bool?> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: Expression<V>, rhs: V) -> Expression<Bool> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: Expression<V?>, rhs: V?) -> Expression<Bool?> where V.DataType : Equatable {
    guard let rhs = rhs else { return "IS".infixs(lhs, Expression<V?>(value: nil)) }
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: V, rhs: Expression<V>) -> Expression<Bool> where V.DataType : Equatable {
    return "=".infixs(lhs, rhs)
}
public func ==<V : Value>(lhs: V?, rhs: Expression<V?>) -> Expression<Bool?> where V.DataType : Equatable {
    guard let lhs = lhs else { return "IS".infixs(Expression<V?>(value: nil), rhs) }
    return "=".infixs(lhs, rhs)
}



