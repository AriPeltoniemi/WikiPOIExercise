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

struct WikImageIView: View {
    //var urlString: String
    var images: [Image]?
    
    
    var body: some View {
        
        VStack {
        
            
            List(images!, id: \.title) { image in
             
               
                //
                
                //ImageView(withURL: image.title!)
                
               Text(verbatim:  image.title!)
                    
            }
        
        }
    }
}
    


/*


struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image: UIImage = UIImage()

    //TODO: Now just image title, needs to create proper url from that...
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            
            //For some reason I cannot create an Image from uiImage: eventough all exaples and Apple documentation says so....
            //So I commented
            
            Image(uiImage: image)
               // .resizable()
               // .aspectRatio(contentMode: .fit)
               // .frame(width:100, height:100)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
*/
