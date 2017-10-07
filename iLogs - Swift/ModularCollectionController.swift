//
//  ModularCollectionController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/6/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit

class ModularCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum CollectionModule {
        case WeatherConditions
        case Emotions
    }
    
    public var module: CollectionModule = .Emotions
    
    public var selectedIndexPaths: [IndexPath]?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - RETURN VALUES
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch module {
        case .WeatherConditions:
            return Entry.WeatherConditionValues.count
        case .Emotions:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        switch module {
        case .WeatherConditions:
            let weatherCondition = Entry.WeatherConditionValues.array[indexPath.row]
            cell.imageView.image = weatherCondition.meta.image.icon
            cell.labelTitle.text = weatherCondition.meta.name
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let identifier = segue.identifier {
     switch identifier {
     case <#pattern#>:
     <#code#>
     default:
     break
     }
     }
     }*/
    
    // MARK: Collection View Controller
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
    }

}
