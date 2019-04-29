//
//  GenericListViewController.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

public class GenericListViewController<
    C: GenericListCellView,
    D: GenericListViewModel,
    L: LoadingView,
    E: ErrorView
    >: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    ///
    /// Configuration properties
    ///
    
    // Loads more items at the bottom
    var isPaginated: Bool = false
    
    // Items per page
    var itemsPerPage: Int = 0
    
    // Shows a loading view when fetching items
    var shouldShowLoading: Bool = true
    
    // Is loading
    var isFetchingItems: Bool = false
    
    // Distance to bottom to fetch more items
    var contentLoadOffset: CGFloat = 0
    
    ///
    /// ViewModel
    ///
    var viewModel: D
    
    // Items
    var itemList = [D.Model]()
    
    // Item offset
    var itemListOffset: Int = 0
    
    // Stop loading items after last fetch
    var itemListEnded: Bool = false
    
    ///
    /// Views
    ///
    var collectionView: UICollectionView?
    var loadingView: L
    var errorView: E
    
    var collectionViewLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // Reuse Id
    private var reuseId: String {
        return NSStringFromClass(C.self)
    }
    
    ///
    /// Initializer
    ///
    init() {
        viewModel = D.init()
        loadingView = L()
        errorView = E()
        
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    func configure() {
        // override
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let cellSize = CGSize(width: view.frame.width, height: C.itemSize.height)
        collectionView = GenericListCollectionView(frame: view.frame, itemSize: cellSize)
        collectionView?.register(C.self, forCellWithReuseIdentifier: reuseId)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
        collectionView?.snap.edges()
        
        fetchItems()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Initialization through IB is not supported.")
    }
    
    ///
    /// Fetch items methods
    ///
    func fetchItems(offset: Int = 0) {
        guard !isFetchingItems && !itemListEnded else { return }
        
        showLoading()
        itemListOffset = offset
        isFetchingItems = true
        
        viewModel.getItems(itemListOffset, itemsPerPage) { items in
            // loading off
            self.hideLoading()
            
            // check returned object is valid
            guard let items = items else {
                self.showError(.unknown)
                return
            }
            
            // check there's items in the result and the list
            guard items.count > 0 || self.itemList.count > 0 else {
                self.showError(.empty)
                return
            }
            
            // all succeeded
            self.itemList += items
            self.itemListOffset = self.itemList.count
            self.itemListEnded = items.count == 0
            self.isFetchingItems = false
            self.collectionView?.reloadData()
        }
    }
    
    func fetchMoreItems() {
        fetchItems(offset: itemListOffset)
    }
    
    ///
    /// Loading
    ///
    func showLoading() {
        guard shouldShowLoading else { return }
        
        loadingView.show(on: view)
    }
    
    func hideLoading() {
        loadingView.hide()
    }
    
    ///
    /// Error
    ///
    func showError(_ type: ErrorType) {
        errorView.show(type, on: view)
    }
    
    func hideError() {
        errorView.hide()
    }
    
    // MARK: - UICollectionViewDatasource
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: C = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! C
        
        if indexPath.item < itemList.count, let item = itemList[indexPath.item] as? C.Model {
            cell.configure(with: item)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < itemList.count, let item = itemList[indexPath.item] as? C.Model {
            didSelect(item: item, at: indexPath)
        }
    }
    
    public func didSelect(item: C.Model, at indexPath: IndexPath) {
        // override
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isPaginated else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = max(contentLoadOffset, scrollView.contentSize.height)
        
        // retrieve more items when we scroll to the bottom
        if offsetY > contentHeight - scrollView.frame.size.height {
            fetchMoreItems()
        }
    }
}
