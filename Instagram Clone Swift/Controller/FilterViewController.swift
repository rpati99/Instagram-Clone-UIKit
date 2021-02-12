//
//  FilterViewController.swift
//  Instagram Clone Swift
//
//  Created by Rachit Prajapati on 05/02/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    private let cancelButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        return btn
    }()

    private let doneButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(passImgBack), for: .touchUpInside)
        return btn
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .red
        
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: choosePostPhotoCellID)
        return cv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 10, paddingLeft: 16)
        view.addSubview(doneButton)
        doneButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 16)
        view.addSubview(collectionView)
        collectionView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 10 ,height: 100)
        view.addSubview(imageView)
        imageView.anchor(top: cancelButton.bottomAnchor, left: view.leftAnchor, bottom: collectionView.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 10)
    }
    
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func passImgBack() {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: choosePostPhotoCellID, for: indexPath)
        cell.backgroundColor = .cyan

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
