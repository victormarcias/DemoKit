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
    M: GenericListViewModel,
    L: LoadingView,
    E: ErrorView
    >: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UISearchResultsUpdating,
    UISearchBarDelegate
{
    //
    // MARK: - Configuration
    //
    public struct Configuration {
        
        // Loads more items at the bottom
        public var isPaginated: Bool = false
        
        // Same functionality but will show headers to see the groups if exist
        public var isGrouped: Bool = false
        
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
        
        // Items per page (fetch)
        public var itemsPerPage: Int = 0
        
        // Items per row (2+ for Grid style)
        public var itemsPerRow: Int = 3
        
        // Shows a loading view when fetching items
        public var shouldShowLoading: Bool = true
        
        // Distance to bottom to fetch more items
        public var contentLoadOffset: CGFloat = 0
    }
    
    public var configuration = Configuration()
    public var loadingView: L
    public var errorView: E
    
    //
    // MARK: - ViewModel
    //
    public var viewModel: M
    public var itemList = [[M.Model]]()
    var itemSize = CGSize.zero
    var itemListOffset: Int = 0
    var itemListEnded: Bool = false
    var isFetchingItems: Bool = false
    var searchText: String?
    
    //
    // MARK: - Life cycle
    //
    public init() {
        viewModel = M.init()
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
    
    //
    // MARK: - CollectionView
    //
    public var collectionView: UICollectionView?
    
    public var collectionViewLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    public var cellReuseId: String {
        return NSStringFromClass(C.self)
    }
    
    func setupCollectionView() {
        // calculate final sizes of the cells
        let width = view.frame.width / CGFloat(configuration.itemsPerRow)
        let height = !C.itemSize.height.isZero ? C.itemSize.height : width
        itemSize = CGSize(width: width, height: height)
        
        collectionView = GenericListCollectionView(frame: view.frame, itemSize: itemSize)
        collectionView?.register(HeaderView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: HeaderView.reuseId)
        collectionView?.register(C.self, forCellWithReuseIdentifier: cellReuseId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
        collectionView?.snap.edges()
    }
    
    //
    // MARK: - Refresh control
    //
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
    }
    
    //
    // MARK: - Search filter
    //
    public var refreshControl = UIRefreshControl()
    
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
    
    //
    // MARK: - Memory
    //
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        UIImageView.ImageCache.clear()
    }
    
    deinit {
        UIImageView.ImageCache.clear()
    }
    
    //
    // MARK: - Fetch
    //
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
    
    func reset() {
        itemList.removeAll()
        itemList = [[M.Model]]()
        itemListEnded = false
        itemListOffset = 0
    }
    
    //
    // MARK: - Loading
    //
    open func showLoading() {
        guard configuration.shouldShowLoading else { return }
        guard !refreshControl.isRefreshing else { return }
        
        loadingView.show(on: view)
    }
    
    open func hideLoading() {
        refreshControl.endRefreshing()
        loadingView.hide()
    }
    
    //
    // MARK: - Error
    //
    open func showError(_ type: ErrorType) {
        errorView.show(type, on: view)
        collectionView?.isHidden = true
    }
    
    open func hideError() {
        errorView.hide()
        collectionView?.isHidden = false
    }
    
    //
    // MARK: - Sections
    //
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemList.count
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerSize = CGSize(width: collectionView.frame.width, height: 30.0)
        return configuration.isGrouped ? headerSize : .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind kind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.reuseId,
                for: indexPath) as? HeaderView {
                    header.titleLabel.text = title(for: indexPath.section)
                    return header
            }
        return UICollectionReusableView()
    }
    
    open func title(for section: Int) -> String {
        return ""
    }
    
    //
    // MARK: - Items
    //
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList[section].count
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: C = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseId,
            for: indexPath) as! C
        
        if let item = item(at: indexPath) {
            cell.configure(with: item)
        }
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                             didSelectItemAt indexPath: IndexPath) {
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
