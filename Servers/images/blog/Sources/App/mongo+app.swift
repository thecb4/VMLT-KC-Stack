//    Copyright (c) 2020 Razeware LLC
//
//    Permission is hereby granted, free of charge, to any person
//    obtaining a copy of this software and associated documentation
//    files (the "Software"), to deal in the Software without
//    restriction, including without limitation the rights to use,
//    copy, modify, merge, publish, distribute, sublicense, and/or
//    sell copies of the Software, and to permit persons to whom
//    the Software is furnished to do so, subject to the following
//    conditions:
//
//    The above copyright notice and this permission notice shall be
//    included in all copies or substantial portions of the Software.
//
//    Notwithstanding the foregoing, you may not use, copy, modify,
//    merge, publish, distribute, sublicense, create a derivative work,
//    and/or sell copies of the Software in any work that is designed,
//    intended, or marketed for pedagogical or instructional purposes
//    related to programming, coding, application development, or
//    information technology. Permission for such use, copying,
//    modification, merger, publication, distribution, sublicensing,
//    creation of derivative works, or sale is expressly withheld.
//
//    This project and source code may use libraries or frameworks
//    that are released under various Open-Source licenses. Use of
//    those libraries and frameworks are governed by their own
//    individual licenses.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//    DEALINGS IN THE SOFTWARE.

import Vapor
import MongoKitten

// 1
private struct MongoDBStorageKey: StorageKey {
    typealias Value = MongoDatabase
}

extension Application {
    // 2
    public var mongoDB: MongoDatabase {
        get {
            // Not having MongoDB would be a serious programming error
            // Without MongoDB, the application does not function
            // Therefore force unwrapping is used
            return storage[MongoDBStorageKey.self]!
        }
        set {
            storage[MongoDBStorageKey.self] = newValue
        }
    }
    
    // 3
    public func initializeMongoDB(connectionString: String) throws {
        self.mongoDB = try MongoDatabase.connect(connectionString, on: self.eventLoopGroup).wait()
    }

    public var mongDBConnectionString: String {
      
      let user = Environment.get("DB_USER") ?? "generic"
      let password = Environment.get("DB_USER_PASSWORD") ?? "generic"
      let server = Environment.get("DB_SERVER") ?? "generic"
      let database = Environment.get("DATABASE") ?? "generic"

      let string = "mongodb://\(user):\(password)@\(server):27017/\(database)"
      print(string)
      return string
    }
}

extension Request {
    // 4
    public var mongoDB: MongoDatabase {
        // 5
        return application.mongoDB.hopped(to: eventLoop)
    }
}
