//
//  ViewController.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 18/12/20.
//

import UIKit

struct DataA :Hashable {
    var nameA:String
}

struct DataB :Hashable {
    var nameB:String
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataArray = [DataA]()
    
    private var datasource : UICollectionViewDiffableDataSource<Section, DataA>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configDatasource()
    }
    
    private func configDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, DataA>(collectionView: collectionView, cellProvider: { (collectionView, indexpath, cellData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexpath)
            
            cell.backgroundColor = .red
            return cell
        })
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,DataA>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataArray)
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    //MARK:- IBActions
    @IBAction func AddItenB(_ sender: Any) {
//        let dataCount = self.dataArray.count
//        let newData = DataB(nameB: "data \(dataCount)")
//        dataArray.append(newData)
    }
    
    @IBAction func addItemA(_ sender: Any) {
        let dataCount = self.dataArray.count
        let newData = DataA(nameA: "data \(dataCount)")
        dataArray.append(newData)
        
        createSnapshot()
    }
    
}
 
extension ViewController {
    fileprivate enum DataSection {
        case aSection([DataA])
        case bSection([DataB])
    }
    
    fileprivate enum Section {
        case main
    }
}
