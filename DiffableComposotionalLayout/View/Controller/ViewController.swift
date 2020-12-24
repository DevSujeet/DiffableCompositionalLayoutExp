//
//  ViewController.swift
//  DiffableComposotionalLayout
//
//  Created by Sujeet.Kumar on 18/12/20.
//
import UIKit

class ViewController: UIViewController {
    
    typealias Section = String

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
//            collectionView.setCollectionViewLayout(self.createLayout(), animated: false)
            //createSectionWiseLayout
            collectionView.register(
              SectionHeaderReusableView.self,
              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
              withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
            )
            
            collectionView.register(
              SectionHeaderReusableView.self,
              forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
              withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
            )
            
            collectionView.register(
              badgeReusableView.self,
              forSupplementaryViewOfKind: "badge",
              withReuseIdentifier: badgeReusableView.reuseIdentifier
            )
            
            //
            collectionView.backgroundColor = .gray
            
            collectionView.setCollectionViewLayout(self.createSectionWiseLayout(), animated: false)
        }
    }
    
    private var dataDictionnary : [String:[DataA]] = [:]
    
    private var datasource : UICollectionViewDiffableDataSource<Section, DataA>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configDatasource()
    }
    
    private func configDatasource() {
        
        datasource = UICollectionViewDiffableDataSource<Section, DataA>(collectionView: collectionView, cellProvider: { (collectionView, indexpath, cellData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexpath) as! ItemCollectionViewCell
            
            if indexpath.section == 0 {
                cell.backgroundColor = .red
            } else {
                cell.backgroundColor = .green
            }
            cell.itemTitle.text = cellData.nameA
            return cell
        })
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            let section = self.datasource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let celldata = self.datasource.snapshot().itemIdentifiers(inSection: section)[indexPath.row]
            
            if kind == UICollectionView.elementKindSectionFooter {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderReusableView
                
                view?.titleLabel.text = section.lowercased()
                return view
            } else if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                    for: indexPath) as? SectionHeaderReusableView
                
                view?.titleLabel.text = section
                return view
                
            } else if kind == "badge" {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: badgeReusableView.reuseIdentifier,
                    for: indexPath) as? badgeReusableView
                
                view?.titleLabel.text = celldata.nameA
                //hide badge at specific index
                if indexPath.row == 3 {
                    view?.isHidden = true
                } else {
                    view?.isHidden = false
                }
                return view
            } else {
                return nil
            }

        }
    }
    
    private func createSnapshot(for data:[String:[DataA]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,DataA>()
        
        let allKeys = data.keys.sorted()
        snapshot.appendSections(allKeys)
        for key in allKeys {
            if let valueForKey = getDataForSection(section: key), valueForKey.count > 0 {
                snapshot.appendItems( valueForKey, toSection: key)
            } else {
                snapshot.deleteSections([key])
            }
            
        }
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    private func getDataForSection(section key:String) -> [DataA]? {
        return self.dataDictionnary[key]
    }
    
    //MARK:- IBActions
    @IBAction func addToSectionB(_ sender: Any) {
        if var sectionBArray = self.dataDictionnary["B"] {
            let dataCount = sectionBArray.count
            let newData = DataA(nameA: "dataB \(dataCount)")
            sectionBArray.append(newData)
            self.dataDictionnary["B"] = sectionBArray
        } else {
            var newArray:[DataA] = []
            let newData = DataA(nameA: "dataB \(newArray.count)")
            newArray.append(newData)
            self.dataDictionnary["B"] = newArray //insert an new array
            
        }
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func addToSectionA(_ sender: Any) {
        if var sectionAArray = self.dataDictionnary["A"] {
            let dataCount = sectionAArray.count
            let newData = DataA(nameA: "dataA \(dataCount)")
            sectionAArray.append(newData)
            self.dataDictionnary["A"] = sectionAArray
        } else {
            var newArray:[DataA] = []
            let newData = DataA(nameA: "dataA \(newArray.count)")
            newArray.append(newData)
            self.dataDictionnary["A"] = newArray //insert an new array
            
        }
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func removefromSectionA(_ sender: Any) {
//        removeRandomFromSectionA()
        
//        updateRandomFromSectionA()
        
        moveItemsWithInSectionA()
    }
    
    //remove random item from Section
    private func removeRandomFromSectionA() {
        
        guard var dataArray = self.dataDictionnary["A"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["A"] = nil
            return
        }
        //get random index from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        dataArray.remove(at: randomInt)
        
        self.dataDictionnary["A"] = dataArray
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    private func updateRandomFromSectionA() {
        guard var dataArray = self.dataDictionnary["A"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["A"] = nil
            return
        }
        //get random index from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        var itemAtIndex = dataArray[randomInt]
        itemAtIndex.nameA = "dasdf\(randomInt)"
        dataArray[randomInt] = itemAtIndex
        
        self.dataDictionnary["A"] = dataArray
        createSnapshot(for: self.dataDictionnary)
    }
    
    func moveItemsWithInSectionA() {
        guard var dataArray = self.dataDictionnary["A"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["A"] = nil
            return
        }
        
        let dataAtOne = dataArray[1]
        let dataAt3 = dataArray[3]
        
        dataArray[3] = dataAtOne
        dataArray[1] = dataAt3
        
        self.dataDictionnary["A"] = dataArray
        createSnapshot(for: self.dataDictionnary)
    }
    
    @IBAction func removefromSectionb(_ sender: Any) {
//        removeRandomFromSectionB()
        
//        updateRandomFromSectionB()
                
        moveItemsWithInSectionB()
    }
    
    private func removeRandomFromSectionB() {
        //remove random item from Section
        guard var dataArray = self.dataDictionnary["B"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["B"] = nil
            return
        }
        //get random index from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        dataArray.remove(at: randomInt)
        
        self.dataDictionnary["B"] = dataArray
        
        createSnapshot(for: self.dataDictionnary)
    }
    
    private func updateRandomFromSectionB() {
        guard var dataArray = self.dataDictionnary["B"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["B"] = nil
            return
        }
        //get random index from 0 to (count - 1)
        let randomInt = Int.random(in: 0..<(count))
        print("random = \(randomInt) & count = \(count)")
        
        var itemAtIndex = dataArray[randomInt]
        itemAtIndex.nameA = "afferq\(randomInt)"
        dataArray[randomInt] = itemAtIndex
        
        self.dataDictionnary["B"] = dataArray
        createSnapshot(for: self.dataDictionnary)
    }
    
    func moveItemsWithInSectionB() {
        guard var dataArray = self.dataDictionnary["B"] else {
            createSnapshot(for: self.dataDictionnary)
            return
        }
        
        let count = dataArray.count
        guard count > 0 else {
            self.dataDictionnary["B"] = nil
            return
        }
        
        let dataAtOne = dataArray[1]
        let dataAt3 = dataArray[3]
        
        dataArray[3] = dataAtOne
        dataArray[1] = dataAt3
        
        self.dataDictionnary["B"] = dataArray
        createSnapshot(for: self.dataDictionnary)
    }
}

extension ViewController {
    
    enum SectionLayoutKind:Int {
        case list,grid3,grid5
        
        func coloumnCount() -> Int {
            switch self {
            
            case .list:
                return 1
            case .grid3:
                return 3
            case .grid5:
                return 5
            }
        }
        
        func coloumnCount(for width:CGFloat) -> Int {
            let widthMode = width > 600
            switch self {
            
            case .list:
                return widthMode ? 2:1
            case .grid3:
                return widthMode ? 6:3
            case .grid5:
                return widthMode ? 10:5
            }
        }
        
        
    }
    /*
     itemSize
     item
     groupSize
     group
     section
     layout
     */
    
    /// TO provide same type of layout in all setion
    /// - Returns: UICollectionViewLayout
    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [item])
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

    
    private func createSectionWiseLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            //bagge
            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top,.trailing], absoluteOffset: CGPoint(x: 0.3, y: -0.3))
            
            let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(40.0),
                                                   heightDimension: .absolute(20.0))
            
            let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                            elementKind: "badge",
                                                            containerAnchor: badgeAnchor)
            //----Items
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: size,
                                              supplementaryItems: [badge])
//            let item = NSCollectionLayoutItem(layoutSize: size)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
            
            //----Groups
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.1))
            
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
    //                                                       subitems: [item])
            guard let layoutKind = SectionLayoutKind(rawValue: sectionIndex) else {
                return nil
            }
            let itemPerGroup = layoutKind.coloumnCount(for: layoutEnvironment.container.effectiveContentSize.width)
           
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: itemPerGroup)
            let spacing = CGFloat(10)
            group.interItemSpacing = .fixed(spacing)
            
            //----Section
            let section = NSCollectionLayoutSection(group: group)
            
            
            //NSCollectionLayoutBoundarySupplementaryItem
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
            
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(40))

            let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                     elementKind: UICollectionView.elementKindSectionFooter,
                                                                     alignment: .bottom)
            

            section.boundarySupplementaryItems = [header,footer] //footer
           
            header.pinToVisibleBounds = true
            
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            if sectionIndex == 1 {
                section.orthogonalScrollingBehavior = .continuous
            }
            
            //adding decoration background to section
            let background = NSCollectionLayoutDecorationItem.background(elementKind: "background")
//            background.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.decorationItems = [background]
            
            return section
        })
        
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "background")
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }
}


