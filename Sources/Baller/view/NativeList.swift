//
//  NativeCollection.swift
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

import Foundation
import UIKit

open class NativeList : NativeDiv, UICollectionViewDataSource, UICollectionViewDelegate  {

    var _viewTypeId: String = "";
    var _viewWidth: Int = 0;
    var _viewHeight: Int = 0;
    var _count: Int = 0;
    var _bHorizontal: Bool = false;
    
    class MyCollectionViewCell : UICollectionViewCell {

        var bCreated: Bool = false
        var nv: NativeView?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        func create(native:Native, viewTypeId:String, w: Int, h: Int)
        {
            if (!bCreated) {
                bCreated = true;
                nv =  native.jsCreate(jsTypeId: viewTypeId)!;
                let _ = nv?.jsCall("doLayout", NSNumber(value:w), NSNumber(value:h));
                nv?.setBounds(NSNumber(value:0), NSNumber(value:0), NSNumber(value:w), NSNumber(value:h));
                addSubview(nv!._e!);
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _count;
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _viewTypeId, for: indexPath as IndexPath) as! MyCollectionViewCell
        cell.create(native:_native!, viewTypeId:_viewTypeId, w:_viewWidth, h:_viewHeight);

        let i:NSInteger = indexPath.row;
        let _:Any? = cell.nv?.jsCall("onPopulate", i, _id);

        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

    override func create() -> UIView
    {
        let v = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        return v;
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func setViewType(_ s: NSString) {
        _viewTypeId = String(s);
        let v = _e as! UICollectionView
        v.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: _viewTypeId)
    }

    // methods that are callable from JavaScript must be declared with @objc and take NSObject style parameters
    @objc func ready() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = _bHorizontal ? .horizontal : .vertical;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSize(width: _viewWidth, height: _viewHeight)
        
        let v = _e as! UICollectionView
        v.backgroundColor = UIColor.clear;
        v.setCollectionViewLayout( layout, animated: false )
        v.delegate = self;
        v.dataSource = self;
    }

    @objc func setHorizontal(_ bHorizontal: NSNumber) {
        _bHorizontal = bHorizontal.boolValue
    }

    @objc func setViewSize(_ width: NSNumber, _ height: NSNumber) {
        _viewWidth = width.intValue
        _viewHeight = height.intValue
    }

    @objc func setCount(_ count: NSNumber) {
        _count = count.intValue
    }

}


