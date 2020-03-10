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
    @IBOutlet private var moviesListContainer: UIView!
    @IBOutlet private var suggestionsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var loadingView: UIActivityIndicatorView!
    @IBOutlet private var emptyDataLabel: UILabel!
    
    private(set) var viewModel: ImagesSearchViewModel!
    
    private var moviesQueriesSuggestionsView: UIViewController?
    private var imagesCollectionVC: ImagesListViewController?
    
    private lazy var searchController = { () -> UISearchController in
        var searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
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
        
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        setupSearchController()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: ImagesSearchViewModel) {
//        viewModel.route.observe(on: self) { [weak self] in self?.handle($0) }
//        viewModel.items.observe(on: self) { [weak self] in self?.moviesTableViewController?.items = $0 }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchController(query: $0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.loadingType.observe(on: self) { [weak self] _ in self?.updateViewsVisibility() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    private func updateSearchController(query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
//        showAlert(title: viewModel.errorTitle, message: error)
    }
    
    private func updateViewsVisibility() {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        moviesListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        
        switch viewModel.loadingType.value {
        case .none: updateMoviesListVisibility()
        case .fullScreen: loadingView.isHidden = false
        case .nextPage: moviesListContainer.isHidden = false
        }
        updateQueriesSuggestionsVisibility()
    }
    
    private func updateMoviesListVisibility() {
//        guard !viewModel.isEmpty else {
//            emptyDataLabel.isHidden = false
//            return
//        }
//        moviesListContainer.isHidden = false
    }
    
    private func updateQueriesSuggestionsVisibility() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ImagesSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
//        moviesTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ImagesSearchViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
    
    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestionsVisibility()
    }
}
// MARK: - Setup Search Controller

extension ImagesSearchViewController {
    private func setupSearchController() {
        searchBarContainer.addSubview(searchController.searchBar)
    }
}
