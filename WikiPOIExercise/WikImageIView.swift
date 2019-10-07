//
//  WikImageIView.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 6.10.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import SwiftUI
import Combine
import UIKit
import CommonCrypto



//--------------------------------------

// View to display wiki page images as list

//---------------------------------------


struct WikImageIView: View {
    //var urlString: String
    var images: [WikiImage]?
    
    
    var body: some View {
        
        VStack {
        
            //List all images found on wiki page
            
            List(images!, id: \.title) { wikiimage in
             
                ImageView(withTitle: wikiimage.title!)
                Text(verbatim:  wikiimage.title!)
                
                //TODO: make Image to button to open bigger version ....
            }
        
        }
    }
}
    


//--------------------------------------

// One Image View to display wiki page image

// Downloads Image form url

//---------------------------------------



struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image: UIImage = UIImage()

    init(withTitle:String) {
        imageLoader = ImageLoader(title: withTitle)
    }

    var body: some View {
        VStack {
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height:100)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

//--------------------------------------

// ObservableObject which downloads image. Once done, publishes to image view

//---------------------------------------


class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    
    let startOfURL: String = "https://upload.wikimedia.org/wikipedia/commons/thumb/"
    
    
    init(title: String) {
   
    
        //reverse engineered URL to 100px wiki image. Otherwise trivial BUT midle part is first and second characters of MD5 hashed trimmed fike name.
        
        //Proper solution would be to query URL from WIki API based on imege title. This wasn now a quicker way to get images u and running
        
        var trimmedImageName: String = title.replacingOccurrences(of: " ", with: "_")
        trimmedImageName.removeFirst(5)
        let MD5fromFIleName: String = MD5(trimmedImageName)!
        let firstCharacter: String = String(MD5fromFIleName.prefix(1))
        let first2Character: String = String(MD5fromFIleName.prefix(2))
        var imageURL = String(startOfURL + firstCharacter + "/" + first2Character +  "/" + trimmedImageName  + "/" + "/100px-" + trimmedImageName)
        let fileSuffix = String(trimmedImageName.suffix(3))
        
        if fileSuffix == "svg" {
            imageURL = imageURL + ".png"
        }
        //reverse engineering ends
        
        //Now actual image load
        
        guard let url = URL(string: imageURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
    
    
    //MD5 hash calculation copied form internet
    func MD5(_ string: String) -> String? {
           let length = Int(CC_MD5_DIGEST_LENGTH)
           var digest = [UInt8](repeating: 0, count: length)

           if let d = string.data(using: String.Encoding.utf8) {
               _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                   CC_MD5(body, CC_LONG(d.count), &digest)
               }
           }

           return (0..<length).reduce("") {
               $0 + String(format: "%02x", digest[$1])
           }
       }
       
}

