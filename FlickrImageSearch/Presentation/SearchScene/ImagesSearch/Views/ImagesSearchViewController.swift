//
//  ImagesSearchViewController.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

class ImagesSearchViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var loadingView: UIActivityIndicatorView!
    @IBOutlet private var emptyDataLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var viewModel: ImagesSearchViewModel!
    
    private lazy var searchController = { () -> UISearchController in
        var searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.backgroundColor = .blue
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        definesPresentationContext = true
        return searchController
    }()

    static func create(with viewModel: ImagesSearchViewModel?) -> ImagesSearchViewController {
        let view = ImagesSearchViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionView()
        searchBarContainer.addSubview(searchController.searchBar)
        loadingView.hidesWhenStopped = true
        
        title = viewModel.screenTitle
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func registerCollectionView() {
        containerView.addSubview(collectionView)
       
        
        collectionView.register(UINib(nibName: Constants.imageCellIdentifier.rawValue, bundle: nil),
                                forCellWithReuseIdentifier: Constants.imageCell.rawValue)
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 0.29 * UIScreen.main.bounds.width, height: 160)
        collectionView.collectionViewLayout = layout
    }
    
    private func bind(to viewModel: ImagesSearchViewModel) {
        viewModel.viewModelCellArray.observe(on: self) { [weak self] _ in
            self?.collectionView.dataSource = self
            self?.collectionView.delegate = self
            self?.collectionView.reloadData()
        }
        
        viewModel.isLoading.observe(on: self) { [weak self] value in
            if value {
                // show loader
                self?.loadingView.startAnimating()
                self?.emptyDataLabel.text = nil
            } else {
                // hide loader
                DispatchQueue.main.async { [weak self] in
                    self?.loadingView.stopAnimating()
                }
            }
        }
        
        viewModel.error.observe(on: self) { [weak self] value in
            self?.loadingView.stopAnimating()
            self?.emptyDataLabel.text = value
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
}

extension ImagesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.callTimer(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = true
        viewModel.didSearch(query: searchText)
    }
}

extension ImagesSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCell.rawValue, for: indexPath) as? ImageCollectionViewCell
        let cellVM = viewModel.getCellVM(at: indexPath)
        cell?.cellViewModel = cellVM
        return cell ?? UICollectionViewCell()
    }
}

extension ImagesSearchViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.didLoadNextPage()
    }
}
