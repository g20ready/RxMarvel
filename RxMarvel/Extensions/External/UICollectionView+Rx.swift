//
//  UICollectionView+Rx.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 5/9/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    
    public var backgroundView: Binder<UIView?> {
        return Binder(self.base) { collectionView, backgroundView in
            collectionView.backgroundView = backgroundView
        }
    }
    
}
