//
//  ModularCollectionController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/6/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class ModularCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum CollectionModule {
        case Emotions
        case WeatherConditions
    }
    
    public var module: CollectionModule = .Emotions
    
    public var selectedIndexPaths: [IndexPath]? {
        return collectionView.indexPathsForSelectedItems
    }
    
    public var selectedItems: Set<NSManagedObject>?
    
    public var entry: Entry!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - RETURN VALUES
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch module {
        case .WeatherConditions:
            return WeatherCondition.Types.array.count
        case .Emotions:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        switch module {
        case .WeatherConditions:
            let weatherConditionType = WeatherCondition.Types.array[indexPath.row]
            cell.imageView.image = weatherConditionType.meta.image.icon
            cell.labelTitle.text = weatherConditionType.meta.name
            if cell.isSelected {
                let selectedWeatherConditionItems = selectedItems as! Set<WeatherCondition>
                let selectedWeatherCondition = selectedWeatherConditionItems.first { $0.conditionType.rawValue == weatherConditionType.rawValue }!
                cell.labelSubtitle.text = selectedWeatherCondition.name
                cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            } else {
                cell.labelSubtitle.text = nil
                cell.backgroundColor = UIColor.white
            }
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    /**
     Update selected rows from selected items
     converting weather condition values into IndexPaths
     */
    private func updateUI() {
        switch module {
        case .Emotions:
            break
        case .WeatherConditions:
            let indexPathsToSelect = (selectedItems as! Set<WeatherCondition>).map({ weatherCondition -> IndexPath in
                let conditionType = weatherCondition.conditionType
                let index = WeatherCondition.Types.array.index { $0.rawValue == conditionType.rawValue }!
                
                return IndexPath(row: index, section: 0)
            })
            indexPathsToSelect.forEach({ (indexPath) in
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            })
        }
    }
    
    private func select(_ indexPath: IndexPath) {
        switch module {
        case .WeatherConditions:
            let conditionType = WeatherCondition.Types.type(for: Int16(indexPath.row))!
            
            let newCondition = WeatherCondition(conditionType: conditionType, scaleType: WeatherCondition.CloudyScale.Broken, for: entry, in: AppDelegate.diaryViewContext)
            selectedItems!.insert(newCondition)
        case .Emotions:
            break
        }
    }
    
    private func deselect(_ indexPath: IndexPath) {
        switch  module {
        case .WeatherConditions:
            let selectedWeatherConditions = selectedItems as! Set<WeatherCondition>
            let conditionType = WeatherCondition.Types.type(for: Int16(indexPath.row))!
            let conditionToRemove = selectedWeatherConditions.first { $0.conditionType == conditionType }!
            selectedItems!.remove(conditionToRemove)
            AppDelegate.diaryViewContext.delete(conditionToRemove)
        case .Emotions:
            break
        }
        
    }
    
    // MARK: Collection View Controller
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
            select(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = UIColor.white
            deselect(indexPath)
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func pressSave(_ sender: Any) {
        entry.managedObjectContext!.undoManager!.endUndoGrouping()
        presentingViewController!.dismiss(animated: true)
    }
    
    @IBAction func pressDismiss(_ sender: Any) {
        entry.managedObjectContext!.undoManager!.endUndoGrouping()
        entry.managedObjectContext!.undo()
        presentingViewController!.dismiss(animated: true)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        entry.managedObjectContext!.undoManager!.beginUndoGrouping()
    }

}
