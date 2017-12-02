//
//  ModularCollectionController.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 10/6/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreData

class EntryCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CustomCollectionViewCellDelegate {
    
    enum CollectionModes {
        case Emotions
        case WeatherConditions
    }
    
    public var mode: CollectionModes = .Emotions
    
    public var selectedIndexPaths: [IndexPath]? {
        return collectionView.indexPathsForSelectedItems
    }
    
    public var selectedItems: Set<NSManagedObject>?
    
    public var entry: Entry!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - RETURN VALUES
    
    // MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .WeatherConditions:
            return WeatherCondition.Types.array.count
        case .Emotions:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        switch mode {
        case .WeatherConditions:
            let weatherConditionType = WeatherCondition.Types.array[indexPath.row]
            let selectedWeatherConditionItems = selectedItems as! Set<WeatherCondition>
            let selectedWeatherCondition = selectedWeatherConditionItems.first { $0.conditionType.rawValue == weatherConditionType.rawValue } //find MO if cell is selected, else display type info
            
            cell.configure(type: weatherConditionType, weatherCondition: selectedWeatherCondition)
            cell.delegate = self
            //removes long press for types that do not have scalable types
            if weatherConditionType.hasScalableTypes == false {
                if let longPress = cell.gestureRecognizers?.first {
                    cell.removeGestureRecognizer(longPress)
                }
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
        switch mode {
        case .Emotions:
            break
        case .WeatherConditions:
            //
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
    
    //TODO: fix select methond prototype
    
    private func select(_ indexPath: IndexPath) {
        switch mode {
        case .WeatherConditions:
            let conditionType = WeatherCondition.Types.type(for: Int16(indexPath.row))!
            let newCondition = WeatherCondition(conditionType: conditionType, scaleType: nil, for: entry, in: AppDelegate.diaryViewContext)
            let cell = self.collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
            cell.configure(type: conditionType, weatherCondition: newCondition)
            selectedItems!.insert(newCondition)
        case .Emotions:
            break
        }
    }
    
    private func deselect(_ indexPath: IndexPath) {
        switch mode {
        case .WeatherConditions:
            let selectedWeatherConditions = selectedItems as! Set<WeatherCondition>
            let conditionType = WeatherCondition.Types(rawValue: Int16(indexPath.row))!
            let conditionToRemove = selectedWeatherConditions.first { $0.conditionValue == conditionType.rawValue }!
            AppDelegate.diaryViewContext.delete(conditionToRemove)
            selectedItems!.remove(conditionToRemove)
        case .Emotions:
            break
        }
        
    }
    
    // MARK: Collection View Controller
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell? {
            select(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell? {
            cell.configure(type: WeatherCondition.Types(rawValue: Int16(indexPath.row))!)
            deselect(indexPath)
        }
    }
    
    // MARK: Custom Collection Cell Delegate
    
    func custom(cell: CustomCollectionViewCell, didLongPress gesture: UILongPressGestureRecognizer) {
        switch mode {
        case .Emotions:
            break
        case .WeatherConditions:
            let cell = gesture.view! as! CustomCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let alert = UIAlertController(title: "Add a Weather Condition", message: "select a scale", preferredStyle: .actionSheet)
            let scalableWeatherCondition = WeatherCondition.Types(rawValue: Int16(indexPath.row))!
            scalableWeatherCondition.scalableTypes!.forEach({ [weak self] (scale) in
                alert.addAction(UIAlertAction(title: scale.name, style: .default, handler: { [weak self] (action) in
                    let newCondition = WeatherCondition(conditionType: scalableWeatherCondition, scaleType: scale, for: self!.entry, in: AppDelegate.diaryViewContext)
                    self!.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
                    self!.selectedItems!.insert(newCondition)
                    cell.configure(type: scalableWeatherCondition, weatherCondition: newCondition)
                }))
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
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
