//
//  ViewController.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 18/12/20.
//

import UIKit

struct DataA :Hashable {
    var nameA:String
    var id:Int = Int.random(in: 1...100) //so that the element are always unique hasable
}

struct DataB :Hashable {
    var nameB:String
}

class ViewController: UIViewController {
    
    typealias Section = String

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataDictionnary : [String:[DataA]] = [:]
    
    private var datasource : UICollectionViewDiffableDataSource<Section, DataA>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configDatasource()
    }
    
    private func configDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, DataA>(collectionView: collectionView, cellProvider: { (collectionView, indexpath, cellData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexpath)
            
            if indexpath.section == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .green
            }
            
            return cell
        })
    }
    
    private func createSnapshot(for data:[String:[DataA]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,DataA>()
        
        let allKeys = data.keys.sorted()
        snapshot.appendSections(allKeys)
        
        for key in allKeys {
            snapshot.appendItems(getDataForSection(section: key), toSection: key)
        }
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func getDataForSection(section key:String) -> [DataA] {
        return self.dataDictionnary[key] ?? []
    }
    //MARK:- IBActions
    @IBAction func addToSectionB(_ sender: Any) {
        if var sectionBArray = self.dataDictionnary["B"] {
            let dataCount = sectionBArray.count
            let newData = DataA(nameA: "dataA \(dataCount)")
            sectionBArray.append(newData)
            self.dataDictionnary["B"] = sectionBArray
        } else {
            var newArray:[DataA] = []
            let newData = DataA(nameA: "dataA \(newArray.count)")
            newArray.append(newData)
            self.dataDictionnary["B"] = newArray //insert an new array
            
        }
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func addToSectionA(_ sender: Any) {
        if var sectionAArray = self.dataDictionnary["A"] {
            let dataCount = sectionAArray.count
            let newData = DataA(nameA: "dataB \(dataCount)")
            sectionAArray.append(newData)
            self.dataDictionnary["A"] = sectionAArray
        } else {
            var newArray:[DataA] = []
            let newData = DataA(nameA: "dataB \(newArray.count)")
            newArray.append(newData)
            self.dataDictionnary["A"] = newArray //insert an new array
            
        }
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func removefromSectionA(_ sender: Any) {
        //remove random item from Section
        guard var dataArray = self.dataDictionnary["A"] else {
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            return
        }
        //get random number from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        dataArray.remove(at: randomInt)
        
        self.dataDictionnary["A"] = dataArray
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func removefromSectionb(_ sender: Any) {
        //remove random item from Section
        guard var dataArray = self.dataDictionnary["B"] else {
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            return
        }
        //get random number from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        dataArray.remove(at: randomInt)
        
        self.dataDictionnary["B"] = dataArray
        
        createSnapshot(for: self.dataDictionnary)
    }
}
 
//extension ViewController {
//    fileprivate enum DataSection {
//        case aSection([DataA])
//        case bSection([DataB])
//    }
    
//    fileprivate enum Section : CaseIterable      {
//        case sectionA
//        case sectionB
//    }
//}
