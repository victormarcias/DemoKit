//
//  GenericListViewController.swift
//  GenericKit
//
//  Created by Victor Marcias on 2019-04-17.
//  Copyright © 2019 Victor Marcias. All rights reserved.
//

import UIKit

class GenericListViewController<
    M: GenericListViewModel,
    C: GenericListCellViewable,
    L: LoadingView,
    E: GenericListErrorView
    >: UIViewController, UICollectionViewDataSource
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
    var viewModel: M
    
    // Items
    var itemList = [M.ItemModel]()
    
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
    
    // Reuse Id
    private var reuseId: String {
        return NSStringFromClass(C.self)
    }
    
    ///
    /// Initializer
    ///
    init() {
        viewModel = M.init()
        loadingView = L.init()
        errorView = E.init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellSize = CGSize(width: view.frame.width, height: C.itemSize.height)
        collectionView = GenericListCollectionView(frame: view.frame, itemSize: cellSize)
        collectionView?.register(C.self, forCellWithReuseIdentifier: reuseId)
        collectionView?.dataSource = self
//        collectionView?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
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
            // check returned object is valid
            guard let items = items else {
                self.showError(.unknown)
                return
            }
            
            // check there's items in the result and the list
            guard items.count > 0 && self.itemList.count > 0 else {
                self.showError(.empty)
                return
            }
            
            // all succeeded
            self.itemList += items
            self.itemListOffset = self.itemList.count
            self.itemListEnded = items.count == 0
            self.isFetchingItems = false
            self.collectionView?.reloadData()
            self.hideLoading()
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
    func showError(_ type: GenericListErrorType) {
        //
    }
    
    // MARK: - UICollectionViewDatasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: C = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! C
        
        if indexPath.item < itemList.count {
            cell.configure(with: itemList[indexPath.item])
        }
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isPaginated else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = max(contentLoadOffset, scrollView.contentSize.height)
        
        // retrieve more items when we scroll to the bottom
        if offsetY > contentHeight - scrollView.frame.size.height {
            fetchMoreItems()
        }
    }
}
