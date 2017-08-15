//
//  Helpers.swift
//  Dream_Architect_SQLiteFramework
//
//  Created by Dream on 2017/6/29.
//  Copyright © 2017年 Tz. All rights reserved.
//


//扩展字符串
extension String {

    //拼接->\"字符
    func quote(_ mark: Character = "\"") -> String {
        let escaped = characters.reduce("") { string, character in
            string + (character == mark ? "\(mark)\(mark)" : "\(character)")
        }
        print(escaped)
        print("\(mark)\(escaped)\(mark)")
        return "\(mark)\(escaped)\(mark)"
    }

    //加入
    func join(_ expressions: [Expressible]) -> Expressible {
        var (template, bindings) = ([String](), [Binding?]())
        for expressible in expressions {
            let expression = expressible.expression
            template.append(expression.template)
            bindings.append(contentsOf: expression.bindings)
        }
        //通过将序列的元素连接起来，返回一个新的字符串，在每个元素之间添加给定的分隔符。
        return Expression<Void>(template.joined(separator: self), bindings)
    }

    //前缀(单个)
    func prefix(_ expressions: Expressible) -> Expressible {
        return "\(self) ".wrap(expressions) as Expression<Void>
    }

    //包装(单个)
    func wrap<T>(_ expression: Expressible) -> Expression<T> {
        return Expression("\(self)(\(expression.expression.template))", expression.expression.bindings)
    }
    //包装(多个)
    func wrap<T>(_ expressions: [Expressible]) -> Expression<T> {
        return wrap(", ".join(expressions))
    }

}

func transcode(_ literal: Binding?) -> String {
    guard let literal = literal else {
        return "NULL"
    }

    switch literal {
    case let string as String:
        return string.quote("'")
    case let binding:
        return "\(binding)"
    }
}

