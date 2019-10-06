//
//  SlideOverCard.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 3.10.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//

import SwiftUI
import Combine


//------------------------------------------------------------

// Vertically sliding card to display Wiki POI information.

// Note: The  code for sliding feature is copied from internet.


//-----------------------------------------------------------




struct WikiSlideOverCard : View {

    //For sliding efature
    @GestureState private var dragState = DragState.inactive
    @State var position = CardPosition.bottom
   
    //Tells what POI is selected
    @Binding var selectedWikiPOI: WikiPOI?
    
    //Data from wiki API for page comes trough wikipage manager. We observe it to URLSession publish
    @ObservedObject var wikipageManager = WikiPageManager()
    
    var titleString: String?
    //---------------------------------------------
    // Display selected POI info on slidable card
    //---------------------------------------------
    
    
    var body: some View {

        //Trigget the API fetch if not done yet
        if wikipageManager.pageFetched == false {
            wikipageManager.fetchPage(pageid: (selectedWikiPOI?.pageID)!)
        }
        
        //Note: The drag function is stolen from internet
        
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        
        //Here starts my own.....
        
        return Group {
            
            // Here we create a card to display wiki data

            
            ZStack (alignment: .top) {
                ZStack (alignment: .top) {
                                 
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.white)
                    
                    VStack (alignment: .center) {
                    
                        
                        //"Handle"
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray)
                            .frame(width: 40.0, height: 5.0, alignment: .top)
                            .padding(10.0)
                        
                        //Title
                        Text(String(selectedWikiPOI?.title ?? "TODO Localization"))
                     
                        
                        
                        
                        if wikipageManager.page != nil {
                            if wikipageManager.page.description != nil {
                            
                                Text(String(wikipageManager.page.description ?? "TODO Localization"))
                                    .fontWeight(.light)
                                    .multilineTextAlignment(.leading)
                                    .padding()

                            } else {
                                Text("No description for this Wiki POI")
                                    .fontWeight(.ultraLight)
                                    .foregroundColor(.gray)
                                    .padding()

                            }
                            
                        
                            //Link to wiki page
                            if selectedWikiPOI?.title != nil {
                                URLLink(aString: (selectedWikiPOI?.title)!)
                        
                            }

                            //If pictures, view for those
                            if wikipageManager.page.images!.count > 0 {
                                
                                WikImageIView(images: wikipageManager.page.images)
                                
                            }
                        }
                    }
                }
            }.onAppear(perform: doSomethingOnAppear)
            
        
        }
         //"Decorations"
        .frame(height: UIScreen.main.bounds.height)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position.rawValue + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .spring())
        .gesture(drag)
    }
    
    func doSomethingOnAppear() {
        print("Just testing .onApper()")
        
    }
    
    
    //-----------------------------------------------
    // Once the user stops dargging, this idenfies one of the card standard positions, top, middle or bottom and puts card there. Mimics for example Apple's Map app function
    //-----------------------------------------------

    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
        let positionAbove: CardPosition
        let positionBelow: CardPosition
        let closestPosition: CardPosition
        
        if cardTopEdgeLocation <= CardPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }
        
        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
    }
}


//------------------------------------------------------
// URL Link view which opens page when pressed
//------------------------------------------------------

struct URLLink : View {
    var aString: String
    
    var body: some View {
     
        //When link = button is presses it opens the wiki page in browser
        Button(action: {
            let urlString = String("https://en.wikipedia.org/wiki/") + self.aString
            let url: NSURL = URL(string: urlString)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
        })
        {
            Text(verbatim: "https://en.wikipedia.org/wiki/" + aString)
        }
    }
}



// Target positions on screen.
// TODO: Shoul dbe dynamic based on screen size

enum CardPosition: CGFloat {
    case top = 200
    case middle = 500
    case bottom = 700
}


enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}


