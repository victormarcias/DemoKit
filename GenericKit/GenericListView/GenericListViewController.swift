//
//  GenericListViewController.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

open class GenericListViewController<
    C: GenericListViewCell,
    D: GenericListViewModel,
    L: LoadingView,
    E: ErrorView
    >: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UISearchResultsUpdating,
    UISearchBarDelegate
{
    ///
    /// Configuration properties
    ///
    public struct Configuration {
        
        // Loads more items at the bottom
        public var isPaginated: Bool = false
        
        // Can filter/search items
        public var isSearchable: Bool {
            get { return _isSearchable }
            set {
                if #available(iOS 11, *) {
                    _isSearchable = newValue
                } else {
                    _isSearchable = false
                }
            }
        }
        fileprivate var _isSearchable: Bool = false
        
        // Items per page
        public var itemsPerPage: Int = 0
        
        // Items per row (2+ for Grid style)
        public var itemsPerRow: Int = 3
        
        // Shows a loading view when fetching items
        public var shouldShowLoading: Bool = true
        
        // Distance to bottom to fetch more items
        public var contentLoadOffset: CGFloat = 0
    }
    
    ///
    /// Configuration
    ///
    public var configuration = Configuration()
    
    ///
    /// ViewModel
    ///
    public var viewModel: D
    
    // Items
    public var itemList = [[D.Model]]()
    
    // Item fixed size
    var itemSize = CGSize.zero
    
    // Item offset
    var itemListOffset: Int = 0
    
    // Stop loading items after last fetch
    var itemListEnded: Bool = false
    
    // Is loading
    var isFetchingItems: Bool = false
    
    // Search filter
    var searchText: String?
    
    ///
    /// Views
    ///
    public var collectionView: UICollectionView?
    public var loadingView: L
    public var errorView: E
    
    // CollectionViewLayout getter
    public var collectionViewLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // Pull down refresh control
    public var refreshControl = UIRefreshControl()
    
    // Reuse Id
    public var reuseId: String {
        return NSStringFromClass(C.self)
    }
    
    ///
    /// Initializer
    ///
    public init() {
        viewModel = D.init()
        loadingView = L()
        errorView = E()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialization through IB is not supported.")
    }
    
    open func configure() {
        // override
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupCollectionView()
        setupRefreshControl()
        setupSearchFilter()
        
        fetchItems()
    }
    
    ///
    /// CollectionView
    ///
    func setupCollectionView() {
        // calculate final sizes of the cells
        let width = view.frame.width / CGFloat(configuration.itemsPerRow)
        let height = !C.itemSize.height.isZero ? C.itemSize.height : width
        itemSize = CGSize(width: width, height: height)
        
        collectionView = GenericListCollectionView(frame: view.frame, itemSize: itemSize)
        collectionView?.register(C.self, forCellWithReuseIdentifier: reuseId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
        collectionView?.snap.edges()
    }
    
    ///
    /// Pull-down refresh control
    ///
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
    }
    
    ///
    /// Search filter
    ///
    func setupSearchFilter() {
        guard configuration._isSearchable else { return }
        
        if #available(iOS 11.0, *) {
            let search = UISearchController(searchResultsController: nil)
            search.searchResultsUpdater = self
            search.searchBar.delegate = self
            search.obscuresBackgroundDuringPresentation = false
            navigationItem.searchController = search
        }
    }
    
    func reset() {
        itemList.removeAll()
        itemList = [[D.Model]]()
        itemListEnded = false
        itemListOffset = 0
    }
    
    ///
    /// Memory clearing
    ///
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        UIImageView.ImageCache.clear()
    }
    
    deinit {
        UIImageView.ImageCache.clear()
    }
    
    ///
    /// Fetch items methods
    ///
    func fetchItems(offset: Int = 0, search: String? = nil) {
        guard !isFetchingItems && !itemListEnded else { return }
        
        showLoading()
        itemListOffset = offset
        isFetchingItems = true
        
        viewModel.getItems(
            filter: (search, itemListOffset, configuration.itemsPerPage),
            success: { items in
                // remove overlay views
                self.hideLoading()
                self.hideError()
                self.isFetchingItems = false
                
                // check there's items in the result and the list
                guard items.count > 0 || self.itemList.count > 0 else {
                    self.showError(.empty)
                    return
                }
                
                // all succeeded
                self.itemList.append(contentsOf: items)
                self.itemListOffset = self.itemList.flatMap{ $0 }.count
                self.itemListEnded = items.last?.count == 0
                self.fetchComplete()
                
            }, failure: { _ in
                self.showError(.unknown)
            })
    }
    
    open func fetchComplete() {
        self.collectionView?.reloadData()
    }
    
    open func fetchMoreItems() {
        fetchItems(offset: itemListOffset, search: searchText)
    }
    
    @objc func refresh() {
        reset()
        fetchItems()
    }
    
    ///
    /// Loading
    ///
    open func showLoading() {
        guard configuration.shouldShowLoading else { return }
        guard !refreshControl.isRefreshing else { return }
        
        loadingView.show(on: view)
    }
    
    open func hideLoading() {
        refreshControl.endRefreshing()
        loadingView.hide()
    }
    
    ///
    /// Error
    ///
    open func showError(_ type: ErrorType) {
        errorView.show(type, on: view)
        collectionView?.isHidden = true
    }
    
    open func hideError() {
        errorView.hide()
        collectionView?.isHidden = false
    }
    
    // MARK: - UICollectionViewDatasource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemList.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList[section].count
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: C = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! C
        
        if let item = item(at: indexPath) {
            cell.configure(with: item)
        }
        return cell
    }
    
    //
    // MARK: - UICollectionViewDelegate
    //
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = item(at: indexPath) {
            didSelect(item: item, at: indexPath)
        }
    }
    
    open func didSelect(item: C.Model, at indexPath: IndexPath) {
        // override
    }
    
    open func item(at indexPath: IndexPath) -> C.Model? {
        let section = indexPath.section
        let item = indexPath.item
        
        if section >= itemList.count || item >= itemList[section].count {
            return nil
        }
        return itemList[section][item] as? C.Model
    }
    
    //
    // MARK: - UIScrollViewDelegate
    //
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard configuration.isPaginated else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.height
        
        guard contentHeight > 0 else { return }
        
        // retrieve more items when we scroll to the bottom
        if offsetY + configuration.contentLoadOffset > contentHeight - scrollHeight {
            fetchMoreItems()
        }
    }
    
    //
    // MARK: - UISearchResultsUpdating
    //
    public func updateSearchResults(for searchController: UISearchController) {
        guard configuration._isSearchable else { return }
        
        reset()
        searchText = searchController.searchBar.text
        fetchItems(offset: 0, search: searchText)
    }
    
    //
    // MARK: - UISearchBarDelegate
    //
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard configuration._isSearchable else { return }
        
        reset()
        searchText = nil
        fetchItems(offset: 0, search: searchText)
    }
}
