//
//  DBConnection.swift
//  SQL-database
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

public final class DBConnection {
    //1.定义数据库的存储方式
    public enum Location: CustomStringConvertible {
        
        case inMemory
        
        case temporary
        
        case uri(String)
        
        public var description: String {
            switch self {
            case .inMemory:
                return ":memory:"
            case .temporary:
                return ""
            case .uri(let path):
                return path
            }
        }
    }
    //2.定义数据库操作
    public enum Operation {
        case insert
        case update
        case delete
        case select
        
        
        fileprivate init(value:Int32) {
            switch value {
            case SQLITE_INSERT:
                self = .insert
            case SQLITE_UPDATE:
                self = .update
            case SQLITE_SELECT:
                self = .select
            case SQLITE_DELETE:
                self = .delete
            default:
                fatalError("没有这个类型\(value)");
            }
        }
    }
    
    //3.构建数据库连接
    var handle:OpaquePointer? = nil
    fileprivate var queue = DispatchQueue(label: "sqlite")
    fileprivate static let queueKey = DispatchSpecificKey<Int>()
    
    fileprivate lazy var queueContent: Int = unsafeBitCast(self, to: Int.self)
    
    init(_ location:Location = .inMemory,_ readOnly:Bool = false) throws {
        
        let flags = readOnly ? SQLITE_OPEN_READONLY : SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        sqlite3_open_v2(location.description, &handle, flags | SQLITE_OPEN_FULLMUTEX, nil);
        
        queue.setSpecific(key: DBConnection.queueKey, value: queueContent)
    }
    
    convenience init(_ fileName:String,_ readOnly:Bool = false) throws {
        try self.init(.uri(fileName),readOnly)
    }
    
    //4.处理数据库的异常信息
    @discardableResult func check(_ resultCode:Int32) throws -> Int32 {
        guard let error = DBResult(errorCode: resultCode, connection: self) else {
            return resultCode
        }
        
        throw error
    }
    //5.检测数据库操作
    //5.1获取数据库的操作权限
    public var readonly: Bool {
        return sqlite3_db_readonly(self.handle, nil) == 1
    }
    //5.2当前数据库插入最近一条数据id
    public var changes:Int {
        return Int(sqlite3_changes(self.handle))
    }
    //5.3获取数据库受影响的行数
    public var totalChanges:Int {
        return Int(sqlite3_total_changes(self.handle))
    }
    
    //6.执行SQL语句
    public func execute(_ sql:String) throws {
        _ = try dbSync({
            try self.check(sqlite3_exec(self.handle, sql, nil, nil, nil))
        })
    }
    
    @discardableResult public func run(_ statement:String,_ bindings:Binding?...) throws-> Statement{
        return try self.run(statement, bindings)
    }
    
    @discardableResult public func run(_ statement:String,_ bindings:[Binding?]) throws-> Statement{
        return try self.prepare(statement).run(bindings)
    }
    
    @discardableResult public func run(_ statement:String,_ bindings:[String:Binding?]) throws-> Statement{
        return try self.prepare(statement).run(bindings)
    }
    
    //参数绑定
    public func prepare(_ statement:String,_ bindings:Binding?...) throws -> Statement{
        if !bindings.isEmpty {
            return try self.prepare(statement, bindings)
        }
        
        return try Statement(self, statement)
    }
    
    public func prepare(_ statement:String,_ bindings:[Binding?]) throws -> Statement{
        return try self.prepare(statement).bind(bindings)
    }
    
    public func prepare(_ statement:String,_ bindings:[String:Binding?]) throws -> Statement{
        return try self.prepare(statement).bind(bindings)
    }
    
    //保证数据库同步执行
    public func dbSync<T>(_ callback:@escaping () throws -> (T)) rethrows -> T {
        var success: T?
        var failure:Error?
        
        let box: ()->(Void) = {
            do {
                success = try callback()
            } catch {
                failure = error
            }
            
        }
        
        //当前队列
        if DispatchQueue.getSpecific(key: DBConnection.queueKey) == queueContent {
            box()
        }else{
            queue.sync(execute: box)
        }
        
        if let fail = failure {
            try {
                () -> Void in
                throw fail
            }()
        }
        
        return success!
    }
    
}

//枚举定义数据库的异常信息
public enum DBResult:Error {
    fileprivate static let successCode = [SQLITE_OK,SQLITE_ROW,SQLITE_DONE]
    
    case error(message:String,code:Int32)
    
    init?(errorCode:Int32,connection:DBConnection) {
        guard !DBResult.successCode.contains(errorCode) else {
            return nil
        }
        let message = String(cString:sqlite3_errmsg(connection.handle))
        self = .error(message: message, code: errorCode)
        
    }
}




