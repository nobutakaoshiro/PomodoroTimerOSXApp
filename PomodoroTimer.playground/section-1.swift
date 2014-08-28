// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

println(str)

let number: Int = 1234

class Hello {
    func world(str: String) -> String {
        return("Hello, World! \(str)")
    }
}

let hello = Hello()

println("%@", hello.world("hogehoge"))
