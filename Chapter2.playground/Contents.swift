//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool

var arrayOfInts: [Int]
var dict: [String:String]
var win: Set<Int>

let number = 42
let fm = 91.1

var countr = ["one", "two"]
let second = countr[1]

let set = [13: "Alice", 26: "Bob"]
set[13]
if let sw = set[14] {
    print("Eh")
}

let strIn = String()
let dec = [Int]()
let ret = Set<Float>()
let r = Int()
let t = Bool()
let mean = String(number)

let av = Set(["a","b","c"])

let f = Float()
let fl = Float(3.14)

let easyPi = 3.14
let fg = Float(easyPi)
let fk: Float = 3.14
av.count
str.isEmpty

countr.append("else")

var ef: Float?
var er: Float?
var et: Float?

ef = 3.5
er = 3.6
et = 3.7

if let e1 = ef,
    let e2 = er,
    let e3 = et {
    let add = (e1 + e2 + e3) / 3
} else {
    let err = "Oh"
}



//for var i = 0; i < count.count; i++ {

//let range = 0..<countr.count
//for i in range {
for sring in countr{
    //let sring = countr[i]
    print(sring)
}

for (i, sring) in countr.enumerate() {
    print(i, sring)
}

for (sp, name) in set {
    print("Age: \(sp), name: \(name)")
}


/////// enum


enum PieType: Int {
    case Apple = 0
    case Cherry
    case Pecan
}

let fav = PieType.Apple

let name:  String
switch fav {
case .Apple:
    name = "A"
case .Cherry:
    name = "C"
case .Pecan:
    name = "P"
}

let os = 2
switch os {
case 0...3:
    print(1)
case 4:
    print(2)
default:
    print(3)
}

let pie = PieType.Pecan.rawValue
if let pi = PieType(rawValue: pie) {
    print("Yes")
}

