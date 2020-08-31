//
//  MoreCollectionReusableView.swift
//  RxMarvel
//
//  Created by Tzatzo, Marsel, Vodafone Greece on 31/08/2020.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import UIKit

import RxSwift

class MoreCollectionReusableView: UICollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        moreButton.isHidden = false
        loadingIndicator.stopAnimating()
        setupButton()
    }
    
}

fileprivate extension MoreCollectionReusableView {
    
    func setupButton() {
        moreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.moreButton.isHidden = true
                self?.loadingIndicator.startAnimating()
            }).disposed(by: disposeBag)
    }
    
}

extension MoreCollectionReusableView: ReusableView, NibLoadableView { }
