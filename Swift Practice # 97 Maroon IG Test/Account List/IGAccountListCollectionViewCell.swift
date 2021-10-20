//
//  IGAccountListCollectionViewCell.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/20.
//

import UIKit

class IGAccountListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!       //大頭照
    
    @IBOutlet weak var userNameLabel: UILabel!              //帳號名稱
    
    @IBOutlet weak var postImageView: UIImageView!          //貼文照片
    
    @IBOutlet weak var likeLabel: UILabel!                  //喜歡
    
    @IBOutlet weak var contantTextView: UITextView!         //照片介紹
    
    @IBOutlet weak var commentLabel: UILabel!               //留言數量
    
    @IBOutlet weak var dateLabel: UILabel!                  //日期
    
    @IBOutlet weak var likeButton: UIButton!                //喜歡的button
    
    //照片按下後顯示紅色愛心
    var likeButtonStatus = false
    @IBAction func likeButtonPush(_ sender: Any) {
        likeButtonStatus = !likeButtonStatus
        if likeButtonStatus {
            likeButton.setImage(UIImage(named: "iconRedLove"), for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "iconLove"), for: .normal)
        }
    }
    
}
