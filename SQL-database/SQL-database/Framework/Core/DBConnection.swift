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
    fileprivate var handle:OpaquePointer? = nil
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
    
}




