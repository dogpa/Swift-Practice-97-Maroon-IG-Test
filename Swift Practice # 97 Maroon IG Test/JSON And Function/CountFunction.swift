//
//  CountFunction.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/19.
//

import Foundation

//自定義參數省略外部參數名稱
//用於貼文數與粉絲數量使用

func countNum(_ index:Int) -> String {
    
    //傳入數字大於一百萬
    //透過逐步除1000的倍數後加入,變成一般常見的金融數字符號
    if index > 1000000 {
        let million = index / 1000000
        let thousands = String(format: "%03d", (index % 1000000) / 1000)
        let fews = String(format: "%03d", index % 1000)
        return "\(million),\(thousands),\(fews)"
    //若大於一千小於一百萬
    //一樣改變成金融數字的寫法
    }else if index > 1000 {
        let thousand = index / 1000
        let fews = String(format: "%03d", index % 1000)
        return "\(thousand),\(fews)"
    //沒超過一千則直接出現數字字串即可
    }else{
        return "\(index)"
    }
    
}
