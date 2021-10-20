//
//  IGAccountCollectionViewController.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/19.
//

import UIKit

//指派reuseIdentifier存入之後需要使用到的collectionViewCell的ID
private let reuseIdentifier = "IGAccountCollectionViewCell"

class IGAccountCollectionViewController: UICollectionViewController {

    //指派 accountInfoFromIG取得自定義IG JSON格式
    //twelvePhotoFromIG則為顯示12個照片資料Array的類型
    var accountInfoFromIG: IgJSONAPI?
    var twelvePhotoFromIG = [IgJSONAPI.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //執行取得JSON資料格式的Function
        getIGInfoFromAssets()
        
    }

    //透過網路抓JSON IG會容易失敗暫時不用
    func getIGDataFromAPI () {
        let urlIGAPI = "https://www.instagram.com/maroon5/?__a=1"

        if let urlString = urlIGAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            if let igJSONUrl = URL(string: urlString){
                
                URLSession.shared.dataTask(with: igJSONUrl) { data, response, error in
                    
                    if let date = data {
                        
                        let decoder = JSONDecoder()
                        
                        decoder.dateDecodingStrategy = .secondsSince1970
                        
                        do {
                            let igSearchResponse = try decoder.decode(IgJSONAPI.self , from: date)
                            self.accountInfoFromIG = igSearchResponse
                            DispatchQueue.main.async {
                                self.twelvePhotoFromIG = igSearchResponse.graphql.user.edge_owner_to_timeline_media.edges
                                self.collectionView.reloadData()
                            }
                          
                            print(igSearchResponse)
                            print("成功")
                        }catch{
                            
                            print(error)
                            print("失敗")
                        }
                    }
                }.resume()
            }
        }
    }


    //透過JSON檔案存入ASSets抓取IG JSON檔案
    func getIGInfoFromAssets () {
        if let sunData = NSDataAsset(name: "maroon5")?.data {
                  let decoder = JSONDecoder()
                  decoder.dateDecodingStrategy = .secondsSince1970
                  do {
                      let igSearchResponse = try decoder.decode(IgJSONAPI.self, from: sunData)
                    self.accountInfoFromIG = igSearchResponse
                    DispatchQueue.main.async {
                        self.twelvePhotoFromIG = igSearchResponse.graphql.user.edge_owner_to_timeline_media.edges
                        self.collectionView.reloadData()
                    }
                      
                      print("Assest成功")
                  } catch  {
                      print(error)
                      print("Assest錯誤")
                  }
              }
    }
    
    
    
    

    // MARK: UICollectionViewDataSource
    
    //回傳一個Section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //顯示總數為twelvePhotoFromIG Array總數
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return twelvePhotoFromIG.count
    }
    
    //顯示的內容
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //透過guard let來取得IGAccountCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? IGAccountCollectionViewCell else {
            return UICollectionViewCell () }
        
        //指派item取得twelvePhotoFromIG Array的指定數字
        let item = twelvePhotoFromIG[indexPath.item]
        
        //透過網路抓資料方式取得每一個Array內照片網址進顯示後執行
        URLSession.shared.dataTask(with: item.node.display_url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.AccountCoPhoto.image = UIImage(data: data)
                }
            }
            
        }.resume()
        
        
        return cell
    }
    
    //header內需要顯示內容，透過UICollectionReusableView協助顯示
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //透過guard let來取得IGAccountCollectionReusableView的路徑
        guard let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "IGAccountCollectionReusableView", for: indexPath) as? IGAccountCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        //if let來取得大頭貼的照片
        //並透過layer.cornerRadius將照片變成圓形
        if let profileHDPicUrl = self.accountInfoFromIG?.graphql.user.profile_pic_url_hd {
            URLSession.shared.dataTask(with: profileHDPicUrl) { (data, response, error) in
                if let data = data {
                    do {
                        DispatchQueue.main.async {
                            resuableView.profileHDPicImageView.layer.cornerRadius = resuableView.profileHDPicImageView.frame.height / 2
                            resuableView.profileHDPicImageView.image = UIImage(data: data)
                        }
                    }catch{
                        print(error)
                    }
                }
                
            }.resume()
        }
        
        //if let協助取得accountInfoFromIG?.graphql.user後存入accountInfoToShow
        //resuableView內的已經拉好outlet的元件則協助各自顯示成自己要的資料(透過IG顯示)，並使用自定義Function來出現數字格式
        if let accountInfoToShow = accountInfoFromIG?.graphql.user {
            resuableView.fullNameLabel.text = accountInfoToShow.full_name
            resuableView.postLabel.text = countNum(accountInfoToShow.edge_owner_to_timeline_media.count)
            resuableView.follwersFansLabel.text = countNum(accountInfoToShow.edge_followed_by.count)
            resuableView.follwerLabel.text = countNum(accountInfoToShow.edge_follow.count)
            
            
            //因為有些IG自介有藏網址，透過檢查來確定有沒有網址
            //有網址就加入網址，沒有的話單純顯示自介內容即可
            resuableView.intrTextView.isEditable = false
            if accountInfoToShow.external_url != nil {
                let urlString = accountInfoToShow.external_url
                resuableView.intrTextView.text = "\(accountInfoToShow.biography)\n\(urlString!)"
                
            }else{
                resuableView.intrTextView.text = accountInfoToShow.biography
            }
            
        }
        
        return resuableView
    }
    
    
    //透過IB Segue Action將資料傳給下一頁顯示
    @IBSegueAction func showIGListImage(_ coder: NSCoder) -> IGAccountListCollectionViewController? {
        
        //透過guard let檢查點到的indexPathsForSelectedItems的值
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else {
            return nil
        }
        //並回傳下一頁需要的資料(accountInfo與indexPath)
        return IGAccountListCollectionViewController.init(coder: coder, accountInfo: accountInfoFromIG!, indexPath: row)
    }
    

    // MARK: UICollectionViewDelegate



}
