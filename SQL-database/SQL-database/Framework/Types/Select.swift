//
//  Select.swift
//  SQL-database
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


extension DBConnection {
    public func prepare(_ query: QueryType) throws ->AnySequence<Row>  {
        //构建SQL语句->对象(expression)
        let expression = query.expression
        //expression->String类型
        //select * from t_user
        let statement = try prepare(expression.template, expression.bindings)
        
        //指定这个SQL语句查询字段
        let columnNames: [String:Int] = {
            var (columnNames, index) = ([String:Int](),0)
            //循环遍历查询字段
            for each in query.manager.select.columns {
                //查询字段名称:each.expression.template
                //查询字段下标:index
                columnNames[each.expression.template] = index
                index += 1
            }
            return columnNames
        }()
        
        
        //执行SQL语句，查询数据
        //        try statement.step()
        //返回数据
        return AnySequence {
            //statement.next():执行SQL语句，获取的数据
            //Row(columnNames, $0):解析数据，获取的我们想要的类型
            AnyIterator {
                statement.next().map{ Row(columnNames, $0) }
            }
        }
    }

}

extension QueryType {
    
    //指定查询的字段
    public func select(_ column:Expressible,_ more:Expressible...)->Self {
        return self.select(false, [column] + more)
    }
    //去除重复的字段
    public func select(distinct column:Expressible,_ more:Expressible...)->Self {
        return self.select(true, more)
    }
    //查询所有的字段
    public func select(_ all:[Expressible])->Self {
        return self.select(false, all)
    }
    //查询所有字段->去重复
    public func select(distinct all:[Expressible])->Self {
        return self.select(true, all)
    }
    
    fileprivate func select<Q : QueryType>(_ distinct:Bool,_ columns:[Expressible]) -> Q{
        var query = Q.init(manager.from.name,manager.from.database)
        query.manager = manager
        query.manager.select = (distinct,columns)
        return query
        
    }
}




public struct Row {
    //字段名称
    fileprivate let columnNames:[String:Int]
    //字段的值
    fileprivate let values:[Binding?]
    
    fileprivate init(_ columnNames:[String : Int],_ values:[Binding?]) {
        self.columnNames = columnNames
        self.values = values
    }
    
    //下标语法
    public func get<V: Value>(_ column:Expression<V>) -> V{
        return get(Expression<V?>(column))!
    }
    
    public func get<V: Value>(_ column:Expression<V?>) -> V? {
        //定义嵌套方法
        func valueAtIndex(_ index:Int) ->V? {
            guard let value = values[index] as? V.DataType else {
                return nil
            }
            //是：继续执行->合法
            return (V.fromDatatypeValue(value) as? V)
        }
        
        //第二步：验证下标
        guard let index = columnNames[column.template] else {
            fatalError("没有这个字段，请确认是否传入正确参数");
        }
        
        return valueAtIndex(index)
    }
    
    //下标语法
    public subscript (column:Expression<Bool>)->Bool {
        return get(column)
    }
    public subscript (column:Expression<Bool?>)->Bool? {
        return get(column)
    }
    public subscript (column:Expression<Double>)->Double {
        return get(column)
    }
    public subscript (column:Expression<Double?>)->Double? {
        return get(column)
    }
    public subscript (column:Expression<Float>)->Float {
        return get(column)
    }
    public subscript (column:Expression<Float?>)->Float? {
        return get(column)
    }
    
    public subscript (column:Expression<Int>)->Int {
        return get(column)
    }
    public subscript (column:Expression<Int?>)->Int? {
        return get(column)
    }
    
    public subscript (column:Expression<Int32>)->Int32 {
        return get(column)
    }
    public subscript (column:Expression<Int32?>)->Int32? {
        return get(column)
    }
    public subscript (column:Expression<Int64>)->Int64 {
        return get(column)
    }
    public subscript (column:Expression<Int64?>)->Int64? {
        return get(column)
    }
    public subscript (column:Expression<String>)->String {
        return get(column)
    }
    public subscript (column:Expression<String?>)->String? {
        return get(column)
    }

}
