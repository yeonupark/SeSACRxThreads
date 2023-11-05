//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by Yeonu Park on 2023/11/05.
//

import Foundation

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        title = "\(Int.random(in: 1...100))"
    }
}

class SearchViewController: UIViewController {
     
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()
        setSearchController()
    }
     
    func bind() {
        
        // cellforRowAt
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell ) in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .green
                
                //cell.bind()
                cell.downloadButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print("다운로드버튼 탭")
                        owner.navigationController?.pushViewController(SampleViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // didSelectRowAt
//        tableView
//            .rx
//            .itemSelected
//            .subscribe(with: self) { owner, indexPath in
//                print("itemSelected - ", indexPath)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView
//            .rx
//            .modelSelected(String.self)
//            .subscribe(with: self) { owner, value in
//                print("modelSelected - ", value)
//            }
//            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map { "indexPath - \($0), value - \($1)" }
            .subscribe(with: self) { owner, value in
                //owner.searchBar.text = value
                print(value)
            }
            .disposed(by: disposeBag)
        
        // SearchBar text를 배열에 추가. 리턴키 클릭시
        // text 옵셔널 바인딩 처리 -> append -> reloadData
        // SearchBarDelegate searchButtonClicked
        
        searchBar
            .rx
            .searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty) { void, text in
                return text
            }
            .subscribe(with: self) { owner, text in
                owner.viewModel.data.insert(text, at: 0)
                owner.viewModel.items.onNext(owner.viewModel.data)
            }
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .debounce(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                
                let result = value == "" ? owner.viewModel.data : owner.viewModel.data.filter { $0.contains(value) }
                owner.viewModel.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        self.navigationItem.titleView = searchBar
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
