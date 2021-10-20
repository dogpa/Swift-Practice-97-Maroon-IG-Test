//
//  IG API JSON Decodable.swift
//  Swift Practice # 97 Maroon IG Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/19.
//

import Foundation


//網路前輩寫法
struct InstagramResponse: Codable{
    let graphql: Graphql
    
    struct Graphql: Codable {
        let user: User
        struct User: Codable {
            let biography: String
            let profile_pic_url_hd: URL
            let username: String
            let full_name: String
            let edge_followed_by: Edge_followed_by
            struct Edge_followed_by:Codable {
                let count: Int
            }
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let edge_media_to_caption: Edge_media_to_caption
                        struct Edge_media_to_caption: Codable {
                            let edges: [Edges]
                            struct Edges: Codable {
                                var node: Node
                                struct Node: Codable {
                                    var text: String
                                }
                            }
                        }
                        let edge_media_to_comment: Edge_media_to_comment
                        struct Edge_media_to_comment: Codable {
                            let count: Int
                        }
                        let edge_liked_by: Edge_liked_by
                        struct Edge_liked_by: Codable {
                            let count: Int
                        }
                        let taken_at_timestamp: Date
                    }
                }
            }
            let edge_felix_video_timeline: Edge_felix_video_timeline
            struct Edge_felix_video_timeline: Codable {
                let edges: [Edges]
                struct Edges: Codable {
                    var node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let video_url: URL
                    }
                }
            }
            let edge_follow: Edge_follow
            struct Edge_follow: Codable {
                let count: Int
            }
        }
    }
}




//自己的寫法

struct IgJSONAPI: Codable {
    let graphql: Graphql
    struct Graphql: Codable {
        let user: User
        struct User: Codable {
            let external_url: String?                                          //自介內網路連結
            let edge_followed_by: FollowerCount                                 //被追蹤人數
            let edge_follow : Follow                                            //追蹤的人數
            let full_name: String                                               //IG名稱
            let highlight_reel_count: Int                                       //自介下方的hightlight數量
            let biography: String                                               //IG介紹
            let profile_pic_url_hd : URL                                        //大頭貼來源
            let username: String                                                //使用者帳號
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media      //發文的內容
            struct FollowerCount: Codable {
                let count: Int
            }
            struct Follow : Codable {
                let count: Int
            }

            struct Edge_owner_to_timeline_media : Codable {
                let count: Int
                let edges: [Edges]
                struct Edges : Codable {
                    let node: Node
                    struct Node: Codable {
                        let display_url: URL                                        //貼文縮圖網址可能是影片但是放縮圖
                        let edge_media_to_caption: edge_media_to_captionEdges       //發文標題
                        let edge_liked_by : Edge_liked_by                           //按喜歡的人數
                        let taken_at_timestamp: Date                                //發文日期 IG格式
                        let edge_media_to_comment: Edge_media_to_comment            //留言人數
                        struct edge_media_to_captionEdges: Codable {
                            let edges : [Edge_media_to_captionNode]
                            struct Edge_media_to_captionNode:Codable {
                                let node: Edge_media_to_captionText
                                struct Edge_media_to_captionText : Codable {
                                    let text: String
                                }

                            }

                        }
                        struct Edge_liked_by: Codable {
                            let count: Int
                        }
                        
                        struct Edge_media_to_comment: Codable {
                            let count: Int
                        }
                    }
                }
            }
        }
    }
}


/*
struct Graphql: Codable {
    let user: User
}
 
 struct User: Codable {
     let external_url: URL?                                          //自介內網路連結
     let edge_followed_by: FollowerCount                             //被追蹤人數
     let edge_follow : Follow                                        //追蹤的人數
     let full_name: String                                           //IG名稱
     let highlight_reel_count: Int                                   //自介下方的hightlight數量
     let profile_pic_url_hd : URL?                                   //大頭貼來源
     let username: String                                            //使用者帳號
     let edge_owner_to_timeline_media: Edge_owner_to_timeline_media  //發文的內容

 }
 
 struct FollowerCount: Codable {
     let count: Int
 }
 
 
 
 struct Follow : Codable {
     let count: Int
 }

 
 struct Edge_owner_to_timeline_media : Codable {
     let count: Int
     let edges: [Edges]
 }

 
 
 struct Edges : Codable {
       let node: Node
 }
 
 
 struct Node: Codable {
     let display_url: URL                                        //貼文縮圖網址可能是影片但是放縮圖
     let edge_media_to_caption: edge_media_to_captionEdges       //發文標題
     let edge_liked_by : Edge_liked_by                           //按喜歡的人數
     let taken_at_timestamp: Date                                //發文日期 IG格式
     let edge_media_to_comment: Edge_media_to_comment            //留言人數
 }
 
 
 struct edge_media_to_captionEdges: Codable {
     let edges : [Edge_media_to_captionNode]
 }

 
 struct Edge_media_to_captionNode:Codable {
     let node: Edge_media_to_captionText
 }

 
 struct Edge_media_to_captionText : Codable {
     let text: String
 }

 
 struct Edge_media_to_comment: Codable {
     let count: Int
 }
 
 
 struct Edge_liked_by: Codable {
     let count: Int
 }
*/






















