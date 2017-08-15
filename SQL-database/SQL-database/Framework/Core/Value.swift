//
//  Value.swift
//  SQL-database
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//


//绑定类型
//所有类型的基类
public protocol Binding {
    
}

//数字类型
public protocol Number:Binding {
    
}

//值类型
public protocol Value:Binding {
    //泛型一:数据类型->程序当中数据类型(Int、Double、Float、String)
    associatedtype DataType:Binding
    //泛型二：返回值类型->程序当中返回值类型(有可能要进行类型转换)
    associatedtype ValueType = Self
    
    //一个静态属性和一个静态方法
    //作用：数据库表字段名称和表字段类型
    //属性：数据库表字段名称->String类型
    static var declareDataType:String {get}
    //方法：将程序中数据类型->转成->数据库类型
    static func fromDatatypeValue(_ dataTypeValue:DataType)-> ValueType;
    
    //对象属性:定义了当前返回值的类型
    var datatypeValue:DataType{get}
}

extension Double :Number,Value {
    public static var declareDataType = "REAL"
    
    public static func fromDatatypeValue(_ dataTypeValue: Double) -> Double {
        return dataTypeValue
    }
    
    public var datatypeValue: Double{
        return self
    }
}

extension Float : Number, Value {
   

    //程序中Float类型->REAL类型
    public static var declareDataType = "REAL"
    
    public static func fromDatatypeValue(_ datatypeValue: Float) -> Float {
        return datatypeValue
    }
    
    public var datatypeValue: Float {
        //返回值
        return self
    }
    
}

//Int类型
//数据库里面：程序中整形类型->integer类型
extension Int : Number , Value {
   

    //程序中Int类型->INTEGER类型
    public static var declareDataType = "INTEGER"
    
    public static func fromDatatypeValue(_ datatypeValue: Int) -> Int {
        return datatypeValue
    }
    
    public var datatypeValue: Int {
        //返回值
        return self
    }
}

//Int32位类型
extension Int32 : Number , Value {
    //程序中Int32类型->INTEGER类型
    public static var declareDataType = "INTEGER"
    
    public static func fromDatatypeValue(_ datatypeValue: Int32) -> Int32 {
        return datatypeValue
    }
    
    public var datatypeValue: Int32 {
        //返回值
        return self
    }
}

//Int64位类型
extension Int64 : Number , Value {
    //程序中Int64类型->INTEGER类型
    public static var declareDataType = "INTEGER"
    
    public static func fromDatatypeValue(_ datatypeValue: Int64) -> Int64 {
        return datatypeValue
    }
    
    public var datatypeValue: Int64 {
        //返回值
        return self
    }
}

extension String: Value,Binding {

    //程序中Int64类型->TEXT类型
    public static var declareDataType = "TEXT"
    
    public static func fromDatatypeValue(_ datatypeValue: String) -> String {
        return datatypeValue
    }
    
    public var datatypeValue: String {
        //返回值
        return self
    }
}

extension Bool :Value,Number {

    public static var declareDataType = Int.declareDataType
    
    public static func fromDatatypeValue(_ dataTypeValue: Int) -> Bool {
        return dataTypeValue != 0
    }
    
    public var datatypeValue: (Int){
        return self ? 1 : 0
    }
}


