//
//  Memo.swift
//  RxMemo
//
//  Created by 박상욱 on 2020/01/14.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxDataSources
import CoreData
import RxCoreData

struct Memo: Equatable, IdentifiableType {
   var content: String
   var insertDate: Date
   var identity: String
   
   init(content: String, insertDate: Date = Date()) {
      self.content = content
      self.insertDate = insertDate
      self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
   }
   
   init(original: Memo, updateContent: String) {
      self = original
      self.content = updateContent
   }
}

extension Memo: Persistable {
   public static var entityName: String {
      return "Memo"
   }
   
   static var primaryAttributeName: String {
      return "identity"
   }
   
   init(entity: NSManagedObject) {
      content = entity.value(forKey: "content") as! String
      insertDate = entity.value(forKey: "insertDate") as! Date
      identity = "\(insertDate.timeIntervalSinceReferenceDate)"
   }
   
   func update(_ entity: NSManagedObject) {
      entity.setValue(content, forKey: "content")
      entity.setValue(insertDate, forKey: "insertDate")
      entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
      
      do {
         try entity.managedObjectContext?.save()
      } catch {
         print(error)
      }
   }
}
