//
//  ViewController.swift
//  CloudKitClass
//
//  Created by Lucas Fernandez Nicolau on 03/03/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var studentsTableView: UITableView!

    var students = [Aluno]()
    let manager = CKManager()
    var alert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        createInputAlertView()
        fillTableView()
    }

    func fillTableView() {
        manager.query(using: NSPredicate(value: true)) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let records = records else { return }

                records.forEach { (record) in
                    guard let nome = record[DBField.nome.rawValue] as? String,
                          let tia = record[DBField.tia.rawValue] as? String,
                          let curso = record[DBField.curso.rawValue] as? String else { return }

                    let student = Aluno(nome: nome, tia: tia, curso: curso)
                    self.students.append(student)
                }

                DispatchQueue.main.async {
                    self.studentsTableView.reloadData()
                }
            }
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.present(alert, animated: true, completion: nil)
    }

    func finishAlertInput() {
        let nome = alert.textFields?[0].text ?? ""
        let tia = alert.textFields?[1].text ?? ""
        let curso = alert.textFields?[2].text ?? ""

        let student = Aluno(nome: nome, tia: tia, curso: curso)

        manager.add(student) { (success) in
            if success {
                self.students.append(student)

                DispatchQueue.main.async {
                    self.studentsTableView.reloadData()
                }
            }
        }
    }

    func createInputAlertView() {
        alert = UIAlertController(title: "Novo Aluno", message: "Digite os dados do aluno:", preferredStyle: .alert)

        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Nome"
        }

        alert.addTextField { (tiaTextField) in
            tiaTextField.placeholder = "TIA"
        }

        alert.addTextField { (cursoTextField) in
            cursoTextField.placeholder = "Curso"
        }

        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        let add = UIAlertAction(title: "Criar Aluno", style: .default) { (_) in

            let nomeTextField = self.alert.textFields?[0]
            let tiaTextField = self.alert.textFields?[1]
            let cursoTextField = self.alert.textFields?[2]

            if nomeTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
                tiaTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
                cursoTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {

                nomeTextField?.text = ""
                tiaTextField?.text = ""
                tiaTextField?.text = ""

                self.alert.dismiss(animated: true, completion: nil)
                self.finishAlertInput()
            }
        }

        alert.addAction(cancel)
        alert.addAction(add)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.studentTableViewCell.rawValue) as? StudentTableViewCell {

            cell.nameLabel.text = students[indexPath.row].nome
            cell.tiaLabel.text = students[indexPath.row].tia
            cell.courseLabel.text = students[indexPath.row].curso

            return cell
        }

        return UITableViewCell()
    }
}
