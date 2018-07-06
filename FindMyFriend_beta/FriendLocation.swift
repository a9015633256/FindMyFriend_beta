//
//  FriendLocation.swift
//  FindMyFriend_beta
//
//  Created by 楊文興 on 2018/7/6.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

struct Location: Codable {
    var groupName:String = "groupName"
    var friendName:String = "friendName"
    var lat:String = "lat"
    var lon:String = "lon"
    
}

typealias location = Location
typealias FriendLocationHandler = (Error?, [location]?) -> Void

class AQIDownloader{
    
    let targetURL: URL
    init(rssURL: URL) {
        targetURL = rssURL
    }
    
    func download(doneHandler: @escaping FriendLocationHandler){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: targetURL) { (data, response, error) in
            if let error = error{
                print("Download Fail: \(error)")
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
            }
            guard let data = data else{
                print("Data is nil.")
                let error = NSError(domain: "Data is nil.", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
            }
            //For Json
            let decoder = JSONDecoder()
            let results = try? decoder.decode([location].self, from: data)
            
            if let results = results {
                //parse OK
                DispatchQueue.main.async {
                    doneHandler(nil, results)
                }
            }else{
                //parse Fail
                let error = NSError(domain: "parse Json Fail!", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
            }
        }
        task.resume()
    }
    
}

