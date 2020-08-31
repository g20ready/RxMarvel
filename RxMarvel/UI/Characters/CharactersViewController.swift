//
//  ViewController.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

import Nuke

class CharactersViewController: UIViewController {

    fileprivate let disposeBag = DisposeBag()
    
    var viewModel: CharactersViewModel!
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var charactersCollectionViewFlowLayout: UICollectionViewFlowLayout!
    fileprivate let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil, "CharactersViewController's viewModel cannot be nil")
        
        setupCollectionView()
        setupMvvm()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        charactersCollectionViewFlowLayout.footerReferenceSize = CGSize(width: charactersCollectionView.bounds.width,
                                                                        height: 50)
    }
    
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = (collectionView.bounds.width - 10) / 2
        return CGSize(width: dimension, height: dimension)
    }
    
}

fileprivate extension CharactersViewController {
    
    func setupCollectionView() {
        charactersCollectionView.delegate = self
        charactersCollectionView.refreshControl = refreshControl
        charactersCollectionView.register(CharacterCollectionViewCell.self)
        charactersCollectionView.register(UINib(nibName: MoreCollectionReusableView.nibName, bundle: nil),
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                          withReuseIdentifier: "footer")
        charactersCollectionViewFlowLayout.minimumLineSpacing = 10
        charactersCollectionViewFlowLayout.minimumLineSpacing = 10
        charactersCollectionViewFlowLayout.scrollDirection = .vertical
        
    }
    
    func setupMvvm() {
        // Input
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.reset)
            .disposed(by: disposeBag)
        
        // Output
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<CharacterSection>(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            switch item {
            case .loading:
                return cv.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.defaultReuseIdentifier,
                                              for: ip)
            case .character(let data):
                let cell = cv.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.defaultReuseIdentifier,
                for: ip) as! CharacterCollectionViewCell
                cell.nameLabel.text = data.name
                if let avatarImage = data.avatarImage, let avatarImageUrl = URL(string: avatarImage) {
                    Nuke.loadImage(with: avatarImageUrl, into: cell.avatarImageView)
                }
                return cell
            }
        }, configureSupplementaryView: { [weak self] (ds, cv, kind, ip) -> UICollectionReusableView in
            
            let moreView = cv.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: "footer",
                                                               for: ip) as! MoreCollectionReusableView
            if let strongSelf = self {
                moreView.moreButton.rx.tap
                    .bind(to: strongSelf.viewModel.input.more)
                    .disposed(by: moreView.disposeBag)
            }
            return moreView
        })
        
        viewModel.output.characters
            .drive(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        viewModel.output.characters
            .drive(charactersCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

