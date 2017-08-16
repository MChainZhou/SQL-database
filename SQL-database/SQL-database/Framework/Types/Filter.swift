//
//  Filter.swift
//  SQL-database
//
//  Created by apple on 2017/8/16.
//  Copyright © 2017年 apple. All rights reserved.
//

import Foundation

//过滤器where语句
extension QueryType {
    //编写条件语句
    var whereStatement: Expressible? {
        guard let filters = manager.filters else {
            return nil
        }
        
        return " ".join([
            Expression<Void>(literal: "WHERE"),
            filters
            ])
    }
    
    public func filter(_ iswhere:Expression<Bool>)->Self{
        return filter(iswhere)
    }
    
    public func filter(_ isWhere:Expression<Bool?>)->Self{
        //拼接条件语句
        var query = self
        query.manager.filters = self.manager.filters.map{$0 && isWhere} ?? isWhere
        
        return query
    }
    
}
