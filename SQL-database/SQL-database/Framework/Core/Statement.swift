//
//  Statement.swift
//  SQL-database
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation


//扩展知识?
//sqlite3_destructor_type解释
//SQLITE_STATIC(0):表指针对应的内容恒定不变的(表数据不可修改->可以这理解)
let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
//SQLITE_TRANSIENT(1):表示数据库可以读写，随时随刻石可以改变的
let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

//SQL语句
public final class Statement {
    fileprivate let connection:DBConnection
    //数据库表指针
    fileprivate var handle:OpaquePointer? = nil
    
    //1.实现构造方法
    init(_ connection:DBConnection,_ SQL:String) throws {
        self.connection = connection
        try connection.check(sqlite3_prepare_v2(connection.handle, SQL, -1, &handle, nil))
    }
    
    //析构函数
    deinit {
        //释放表指针
        sqlite3_finalize(self.handle)
    }
    
    //2.绑定参数
    public func bind(_ values:Binding?...) -> Statement {
        return self.bind(values)
    }
    
    public func bind(_ values:[Binding?]) -> Statement {
        if values.isEmpty {
            return self
        }
        //重置缓存
        reset()
        
        //判断参数的个数
        guard values.count == Int(sqlite3_bind_parameter_count(self.handle)) else {
            fatalError("参数列表和数据库表字段的个数不匹配")
        }
        
        for index in 1...values.count {
            bind(values[index - 1],index)
        }
        
        return self;
    }
    
    public func bind(_ values:[String:Binding?]) -> Statement {
        reset()
        
        for (name,value) in values {
            let index = Int(sqlite3_bind_parameter_index(self.handle, name))
            guard index > 0 else {
                fatalError("没有这个字段");
            }
            bind(value,index)
        }
        
        return self
    }
    
    //3.执行SQL语句
    public func run(_ bindings:Binding?...) throws -> Statement{
        guard bindings.isEmpty else {
            return try self.run(bindings)
        }
        
        reset(clearBinding:false)
        
        try step()
        
        return self
    }
    
    public func run(_ bindings:[Binding?]) throws -> Statement{
        return try self.bind(bindings).run()
    }
    
    public func run(_ bindings:[String:Binding?]) throws -> Statement{
        return try self.bind(bindings).run()
    }
    
    
    public func bind(_ value:Binding?,_ index:Int){
        if value == nil {
            sqlite3_bind_null(self.handle, Int32(index))
        }else if let v = value as? Double {
            sqlite3_bind_double(self.handle, Int32(index), v)
        }else if let v = value as? Float {
            sqlite3_bind_double(self.handle, Int32(index), Double(v))
        }else if let v = value as? Int {
            sqlite3_bind_int(self.handle, Int32(index), Int32(v))
        }else if let v = value as? Int32 {
            sqlite3_bind_int(self.handle, Int32(index), Int32(v))
        }else if let v = value as? Int64 {
            sqlite3_bind_int64(self.handle, Int32(index), Int64(v))
        }else if let v = value as? Bool {
            self.bind(v.datatypeValue, index)
        }else if let v = value as? String {
            sqlite3_bind_text(self.handle, Int32(index), v, -1, SQLITE_TRANSIENT);
        }else{
            fatalError("没有这个类型\(String(describing: value))")
        }
    }
    
    @discardableResult public func step() throws -> Bool {
        return try connection.dbSync{
            try self.connection.check(sqlite3_step(self.handle)) == SQLITE_ROW
        }
    }
    
    public func reset(clearBinding shouldClear:Bool = true){
        //还原状态
        sqlite3_reset(self.handle);
        //清空缓存
        if shouldClear {
            sqlite3_clear_bindings(self.handle)
        }
    }
}

extension Statement:CustomStringConvertible {
    public var description: String {
        return String(cString: sqlite3_sql(self.handle))
    }
}
