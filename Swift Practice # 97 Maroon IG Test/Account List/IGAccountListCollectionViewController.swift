//
//  IGAccountListCollectionViewController.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/20.
//

import UIKit

//指派reuseIdentifier取得後續cell需要使用到的id
private let reuseIdentifier = "IGAccountListCollectionViewCell"

class IGAccountListCollectionViewController: UICollectionViewController {
    
    
    @IBOutlet weak var postDetailsCollectionView: UICollectionView!
    
    //透過變數與初始化變數來做後續使用，並從前一頁的資料可以協助傳入使用
    var ig12PhotoInfo: IgJSONAPI.Graphql.User.Edge_owner_to_timeline_media
    var igAccountUserName : String
    var igAccountHDPhoto: URL
    var indexPath: Int
    var isShow = false
    init?(coder: NSCoder, accountInfo: IgJSONAPI, indexPath: Int) {
        self.ig12PhotoInfo = accountInfo.graphql.user.edge_owner_to_timeline_media
        self.igAccountUserName = accountInfo.graphql.user.username
        self.igAccountHDPhoto = accountInfo.graphql.user.profile_pic_url_hd
        self.indexPath = indexPath
        super.init(coder: coder)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //navigationItem上方的顯示ＩＧ帳號名稱的Fucntion
    func setNavigationItemTitle () {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .black
        let userName = self.igAccountUserName.uppercased()
        label.text = "\(userName)\nPost"
        self.navigationItem.titleView = label
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //執行顯示navigationItem的帳號名稱
        setNavigationItemTitle()
        //print(ig12PhotoInfo.edges.count)

    }
    
    //透過前一頁按下的照片所在array的值，在這一頁直接跳到該照片的位置
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            collectionView.scrollToItem(at: IndexPath(item: self.indexPath, section: 0), at: .top, animated: false)
            isShow = true
        }
        //print(view.frame)
        //print(postDetailsCollectionView.frame)
        //postDetailsCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        //postDetailsCollectionView.contentSize.width = CGFloat(view.frame.width)
    }

    // MARK: UICollectionViewDataSource

    //顯示一個section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //item顯示12個(ig12PhotoInfo.edges.count)
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ig12PhotoInfo.edges.count
    }

    //顯示內容
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? IGAccountListCollectionViewCell else {return UICollectionViewCell()}
       
        //透過CALayer增加上方灰色線條
        //並透過照片網址來顯示照片
        URLSession.shared.dataTask(with: ig12PhotoInfo.edges[indexPath.item].node.display_url) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    let border = CALayer()
                    border.backgroundColor = UIColor.systemGray2.cgColor
                    border.frame = CGRect(x: 0, y: 0, width: cell.postImageView.frame.width, height: 0.3)
                    cell.postImageView.layer.addSublayer(border)
                    cell.postImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    
        //IG大頭貼顯示
        URLSession.shared.dataTask(with: igAccountHDPhoto){
            (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
                    cell.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        //其餘相關需要的資要顯是 照片介紹 多少人按like與日期
        //使用者帳號
        cell.userNameLabel.text = "\(igAccountUserName)"
        
        //按鈕的照片
        cell.likeButton.setImage(UIImage(named: "iconLove"), for: .normal)
        
        //喜歡人數
        cell.likeLabel.text = "Like by you and \(countNum(ig12PhotoInfo.edges[indexPath.item].node.edge_liked_by.count)) others"
        
        //照片介紹
        cell.contantTextView.isEditable = false
        cell.contantTextView.isScrollEnabled = false
        cell.contantTextView.text = ig12PhotoInfo.edges[indexPath.item].node.edge_media_to_caption.edges[0].node.text
        
        //多少留言
        cell.commentLabel.textColor = .gray
        cell.commentLabel.text = "View all \(countNum(ig12PhotoInfo.edges[indexPath.item].node.edge_media_to_comment.count)) comments"
        
        //日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let dateString = dateFormatter.string(from: ig12PhotoInfo.edges[indexPath.item].node.taken_at_timestamp)
        cell.dateLabel.text = "\(dateString)"
        
    
        return cell
    }

}
