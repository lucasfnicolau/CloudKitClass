//
//  CloudKitManager.swift
//  CloudKitClass
//
//  Created by Lucas Fernandez Nicolau on 03/03/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit
import CloudKit

class CKManager {
    private let container = CKContainer(identifier: Container.cloudKitClass.rawValue)
    private let db: CKDatabase

    init() {
        self.db = container.privateCloudDatabase
    }

    func query(using predicate: NSPredicate, completion: @escaping ([CKRecord]?, Error?) -> Void) {

        let query = CKQuery(recordType: DBType.aluno.rawValue, predicate: predicate)

        db.perform(query, inZoneWith: nil) { (records, error) in
            completion(records, error)
        }
    }

    func add(_ student: Aluno, completion: @escaping (Bool) -> Void) {
        let record = CKRecord(recordType: DBType.aluno.rawValue)
        record[DBField.nome.rawValue] = student.nome
        record[DBField.tia.rawValue] = student.tia
        record[DBField.curso.rawValue] = student.curso

        db.save(record) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
