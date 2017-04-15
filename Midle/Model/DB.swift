//
//  DB.swift
//  1542248_BT04
//
//  Created by Than Hoang Xuan Nghiep on 4/7/17.
//  Copyright © 2017 Than Hoang Xuan Nghiep. All rights reserved.
//

import UIKit

extension UIViewController {
    func createDB() -> OpaquePointer?{
        //create db in document dir
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = docURL.appendingPathComponent("QLHS.db").path
        
        var dbTempPointer : OpaquePointer?
        if sqlite3_open(dataPath, &dbTempPointer) == SQLITE_OK{
            print("DB was created!")
            print(dataPath)
            return dbTempPointer
        }else{
            print("Failed")
            return nil
        }
    }
    func createTable_Student(database : OpaquePointer?){
        let query = "create table Student(id integer primary key autoincrement, full_name varchar(50), grade integer, dob date, other_info varchar(200))"
        //let query = "drop table Student"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Table was created!")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(database))
                print(errmsg)
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
        }
    }
    func createTable_Grade(database : OpaquePointer?){
        let query = "create table Grade(id integer primary key autoincrement, name integer)"
        //let query = "drop table Grade"
        var statement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            if(sqlite3_step(statement) == SQLITE_DONE){
                print("created!")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(database))
                print(errmsg)
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
        }
    }
    func insert(database: OpaquePointer?, query: String?) -> Bool{
        var insertStatement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &insertStatement, nil) == SQLITE_OK{
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Inserted")
                return true
            }else{
                print("Failed")
                return false
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
            return false
        }
    }
    func getData(database: OpaquePointer?, query: String?) -> OpaquePointer?{
        var selectStatement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &selectStatement, nil) == SQLITE_OK{
            return selectStatement
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
            return nil
        }
    }
    func update(database: OpaquePointer?, query: String?) -> Bool{
        var updateStatement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &updateStatement, nil) == SQLITE_OK{
            if(sqlite3_step(updateStatement) == SQLITE_DONE){
                print("updated!")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(database))
                print(errmsg)
                return false
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
            return false
        }
    }
    func delete(database: OpaquePointer?, query: String?)-> Bool{
        var deleteStatement : OpaquePointer?
        if sqlite3_prepare_v2(database, query, -1, &deleteStatement, nil) == SQLITE_OK{
            if(sqlite3_step(deleteStatement) == SQLITE_DONE){
                print("Deleted!")
                return true
            }else{
                let errmsg = String(cString: sqlite3_errmsg(database))
                print(errmsg)
                return false
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(database))
            print(errmsg)
            return false
        }
    }
}
