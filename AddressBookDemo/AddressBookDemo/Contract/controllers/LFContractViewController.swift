//
//  LFContractViewController.swift
//  AddressBookDemo
//
//  Created by useradmin on 2018/11/22.
//  Copyright © 2018年 francis. All rights reserved.
//

import UIKit
import AddressBook

class Person: NSObject {
    
    @objc var name: String?
    @objc var phone: String?
    @objc var pinyin: String?
}


class LFContractViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    typealias contactClosures = ([Person]) -> Void
    var contactCallBack:contactClosures?
    func contactCallBackBlock(block:@escaping contactClosures) {
        contactCallBack = block
    }
    
    private var indexedCollation = UILocalizedIndexedCollation.current()
    /// 数据源
    private var dataArray = [[Person]]()
    /// 每个 section 的标题
    private var sectionTitleArray = [String]()
    private var tipArray = [String]()
    
    var selectArray = [Person]()
    
    
    private lazy var addressBook: ABAddressBook = {
        let ab: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        return ab;
    }()
    
    private var navigationView:UIView?
    private var navigationTitle:UILabel?
    private var cancelLabel:UILabel?
    private var cancelControl:UIControl?
    private var sureButton:UIButton?
    private var contactTable:UITableView?
    private var tipCollection:UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.configNavigation()
        self.getSystemContact()
        self.configTableView()
        self.configTipCollection()
    }
    
    func configNavigation(){
        
        navigationView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationHeight))
        navigationView?.backgroundColor = UIColor.blue
        navigationView?.isUserInteractionEnabled = true
        self.view.addSubview(navigationView!)
        
        navigationTitle = UILabel.init(frame: CGRect(x: kScreenWidth/2-70, y: kStatusBarHeight, width: 140, height: 44))
        navigationTitle?.text = "选择联系人"
        navigationTitle?.font = UIFont.systemFont(ofSize: 17)
        navigationTitle?.textColor = UIColor.white
        navigationTitle?.textAlignment = NSTextAlignment.center
        
        navigationView?.addSubview(navigationTitle!)
        
        cancelLabel = UILabel.init(frame: CGRect(x: kScreenWidth-18-40, y: kStatusBarHeight, width: 40, height: 44));
        cancelLabel?.text = "取消"
        cancelLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelLabel?.textAlignment = NSTextAlignment.right
        cancelLabel?.textColor = UIColor.white
        
        navigationView?.addSubview(cancelLabel!)
        
        cancelControl = UIControl.init(frame: CGRect(x: kScreenWidth-58, y: kStatusBarHeight, width: 58, height: 44))
        cancelControl?.addTarget(self, action:#selector(dismissSelf) , for: UIControl.Event.touchUpInside)
        navigationView?.addSubview(cancelControl!)
        
        sureButton = UIButton.init(type: .custom)
        sureButton?.setTitle("确定", for: .normal)
        sureButton?.adjustsImageWhenHighlighted = false
        sureButton?.setTitleColor(UIColor.white, for: .normal)
        sureButton?.addTarget(self, action: #selector(sureAction(button:)), for: .touchUpInside)
        sureButton?.frame = CGRect(x: kScreenWidth-58-58, y: kStatusBarHeight, width: 58, height: 44)
        sureButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        navigationView?.addSubview(sureButton!)
    }
    
    @objc func sureAction(button:UIButton){
        if self.contactCallBack != nil{
            self.contactCallBack!(self.selectArray)
        }
        dismissSelf()
    }
    
    @objc func dismissSelf(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configTipCollection(){
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:20,height:15)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        tipCollection = UICollectionView.init(frame: CGRect(x: kScreenWidth-20, y: kScreenHeight/2-202.5, width: 20, height: 405), collectionViewLayout: layout)
        tipCollection!.register(LFTipCollectionCell.self, forCellWithReuseIdentifier:"LFTipCollectionCell")
        tipCollection?.isScrollEnabled = false
        tipCollection?.delegate = self
        tipCollection?.dataSource = self
        tipCollection?.backgroundColor = UIColor.clear
        self.view.addSubview(tipCollection!)
    }
    
    func configTableView() {
        
        contactTable = UITableView.init(frame:CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight-kNavigationHeight) , style: .plain)
        contactTable?.delegate = self
        contactTable?.dataSource = self
        contactTable?.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        contactTable?.register(LFContactTableCell.self, forCellReuseIdentifier: "LFContactTableCell")
        contactTable?.showsVerticalScrollIndicator = false
        contactTable?.rowHeight = 50
        contactTable?.sectionFooterHeight = 0
        contactTable?.sectionHeaderHeight = 30
        contactTable?.tableFooterView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(contactTable!)
        
        contactTable?.setEditing(true, animated: true)
    }
    
    func getSystemContact(){
        let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as Array
        var contactArray = [Person]()
        for record in allContacts {
            let currentContact: ABRecord = record
            
            
            let currentContactName = ABRecordCopyCompositeName(currentContact)?.takeRetainedValue() as String?
            //            print("\(String(describing: currentContactName))")
            if let name = currentContactName {
                let currentContactPhones: ABMultiValue = ABRecordCopyValue(currentContact, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValue
                
                for index in 0..<ABMultiValueGetCount(currentContactPhones){
                    let teleNum = ABMultiValueCopyValueAtIndex(currentContactPhones, index).takeRetainedValue() as! String
                    //                let contact = (name, ABMultiValueCopyValueAtIndex(currentContactPhones, index).takeRetainedValue() as! String)
                    //                    print("\(teleNum)")
                    let contactModel = Person()
                    contactModel.name = name
                    let newNum = filterPhoneNum(phoneNum: teleNum)
                    contactModel.phone = newNum
                    let namePinYin = LFCommonTools().transChinese(name)
                    contactModel.pinyin = namePinYin
                    if ((newNum as NSString).length == 11){
                        contactArray.append(contactModel)
                    }
                }
            }
        }
        
        // 获得索引数, 这里是27个（26个字母和1个#）
        let indexCount = indexedCollation.sectionTitles.count
        
        // 每一个一维数组可能有多个数据要添加，所以只能先创建一维数组，到时直接取来用
        for _ in 0..<indexCount {
            let array = [Person]()
            dataArray.append(array)
        }
        
        // 将数据进行分类，存储到对应数组中
        for person in contactArray {
            
            // 根据 person 的 name 判断应该放入哪个数组里
            // 返回值就是在 indexedCollation.sectionTitles 里对应的下标
            //            let sectionNumber = indexedCollation.section(for: person, collationStringSelector: #selector(getter: Person.name))
            let sectionNumber = indexedCollation.section(for: person, collationStringSelector: #selector(getter: Person.pinyin))
            
            // 添加到对应一维数组中
            dataArray[sectionNumber].append(person)
        }
        
        // 对每个已经分类的一维数组里的数据进行排序，如果仅仅只是分类可以不用这步
        for i in 0..<indexCount {
            
            // 排序结果数组
            let sortedPersonArray = indexedCollation.sortedArray(from: dataArray[i], collationStringSelector: #selector(getter: Person.name))
            // 替换原来数组
            dataArray[i] = sortedPersonArray as! [Person]
        }
        
        // 用来保存没有数据的一维数组的下标
        var tempArray = [Int]()
        for (i, array) in dataArray.enumerated() {
            if(i > 26){
                continue
            }
            tipArray.append(indexedCollation.sectionTitles[i])
            if array.count == 0 {
                tempArray.append(i)
            } else {
                // 给标题数组添加数据
                sectionTitleArray.append(indexedCollation.sectionTitles[i])
                //                print("\(indexedCollation.sectionTitles[i])")
            }
        }
        
        // 删除没有数据的数组
        for i in tempArray.reversed() {
            dataArray.remove(at: i)
        }
    }
    
    func filterPhoneNum(phoneNum:String) -> String {
        if phoneNum.isEmpty {
            return ""
        }else{
            var newPhoneNum = phoneNum
            
            if phoneNum.hasPrefix("+86"){
                newPhoneNum = (phoneNum as NSString).replacingOccurrences(of: "+86", with: "")
            }
            //正则匹配替换字符
            let pattern = "\\D"
            let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.init(rawValue: 0))
            let res = regex.matches(in: phoneNum, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: phoneNum.count))
            
            if res.count > 0{
                var specialArr = [String]()
                
                for checkResult in res{
                    specialArr.append((phoneNum as NSString).substring(with: checkResult.range))
                }
                if specialArr.count > 0{
                    let specialSet = NSSet.init(array: specialArr)
                    for specialStr in specialSet{
                        newPhoneNum = (newPhoneNum as NSString).replacingOccurrences(of: specialStr as! String, with: "")
                    }
                }
            }
            return newPhoneNum
        }
    }
    
    // MARK: - uitableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LFContactTableCell = tableView.dequeueReusableCell(withIdentifier: "LFContactTableCell", for: indexPath) as! LFContactTableCell
        cell.nameLabel?.text = dataArray[indexPath.section][indexPath.row].name
        cell.teleLabel?.text = dataArray[indexPath.section][indexPath.row].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30))
        headerView.backgroundColor = UIColor.gray
        let tipLabel = UILabel.init(frame: CGRect(x: 18, y: 0, width: kScreenWidth-70, height: 30))
        tipLabel.text = sectionTitleArray[section]
        tipLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tipLabel.textColor = UIColor.black
        headerView.addSubview(tipLabel)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle(rawValue: UITableViewCell.EditingStyle.insert.rawValue | UITableViewCell.EditingStyle.delete.rawValue) ?? UITableViewCell.EditingStyle.insert
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if self.contactCallBack != nil{
        //            self.contactCallBack!(dataArray[indexPath.section][indexPath.row])
        //            self.dismissSelf()
        //        }
        let person = dataArray[indexPath.section][indexPath.row]
        if selectArray.contains(person) {
        }else{
            selectArray.append(person)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let person = dataArray[indexPath.section][indexPath.row]
        if selectArray.contains(person) {
            if let index = selectArray.firstIndex(of: person){
                selectArray.remove(at: index)
            }
        }
    }
    
    // MARK: - collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tipArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LFTipCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LFTipCollectionCell", for: indexPath) as! LFTipCollectionCell
        cell.backgroundColor = UIColor.clear
        cell.titleLabel?.text = tipArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sectionTitleArray.count < 1 {
            return
        }
        let tipStr = tipArray[indexPath.row]
        if sectionTitleArray.contains(tipStr) {
            let index = sectionTitleArray.index(of: tipStr)
            let tableIndex = IndexPath.init(item: 0, section: index!)
            contactTable?.scrollToRow(at: tableIndex, at: UITableView.ScrollPosition.top, animated: false)
        }else{
            if tipStr == "#"{
                let targetStr = sectionTitleArray.last
                let index = sectionTitleArray.index(of: targetStr!)
                let tableIndex = IndexPath.init(item: 0, section: index!)
                contactTable?.scrollToRow(at: tableIndex, at: UITableView.ScrollPosition.top, animated: false)
            }else{
                let firstStr = sectionTitleArray.first
                var strNum = LFCommonTools().getNumWithChar(tipStr)
                
                if LFCommonTools().getNumWithChar(tipStr) > LFCommonTools().getNumWithChar(firstStr){
                    for _ in 0..<sectionTitleArray.count{
                        strNum -= 1
                        let beforeStr = LFCommonTools().getStringWith(strNum)
                        if sectionTitleArray.contains(beforeStr!){
                            let index = sectionTitleArray.index(of: beforeStr!)
                            let tableIndex = IndexPath.init(item: 0, section: index!)
                            contactTable?.scrollToRow(at: tableIndex, at: UITableView.ScrollPosition.top, animated: false)
                            break
                        }
                    }
                }else{
                    let tableIndex = IndexPath.init(item: 0, section: 0)
                    contactTable?.scrollToRow(at: tableIndex, at: UITableView.ScrollPosition.top, animated: false)
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
