//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 박상욱 on 2020/01/14.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {
   
   var viewModel: MemoListViewModel!
   @IBOutlet private weak var listTableView: UITableView!
   @IBOutlet private weak var addButton: UIBarButtonItem!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
   
   func bindViewModel() {
      viewModel.title
         .drive(navigationItem.rx.title)
         .disposed(by: rx.disposeBag)
      
      viewModel.memoList
         .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
            cell.textLabel?.text = memo.content
      }
      .disposed(by: rx.disposeBag)
   }
}