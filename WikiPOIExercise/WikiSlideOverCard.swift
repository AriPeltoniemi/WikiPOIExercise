//
//  SlideOverCard.swift
//  WikiPOIExercise
//
//  Created by Ari Peltoniemi on 3.10.2019.
//  Copyright © 2019 Ari Peltoniemi. All rights reserved.
//






import SwiftUI


//-----------------------------------------------

//Vertically sliding card to display Wiki POI information.

// Note: The  code for sliding feature is copied from internet. Just modified it to dipslay wiki content


//-----------------------------------------------


struct WikiSlideOverCard : View {

    @GestureState private var dragState = DragState.inactive
    @State var position = CardPosition.bottom
    @Binding var selectedWikiPOI: WikiPOI?
    
   // var content: () -> Content
    var body: some View {
        
        
        //Note: The drag function is stolen from internet
        
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        
        //Here starts my own.....
        
        
        return Group {
            Handle()
            
            ZStack (alignment: .top) {
                ZStack (alignment: .top) {
                    RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.white)
                    
                    VStack (alignment: .center) {
                    
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray)
                            .frame(width: 40.0, height: 5.0, alignment: .top)
                            .padding(10.0)
                        
                        Text(String(selectedWikiPOI?.title ?? "TODO Localization"))
                
                    }
                }
            }
        
            //self.content()
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position.rawValue + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .spring())
        .gesture(drag)
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

// Target positions on screen.
// TODO: Shoul dbe dynamic based on screen size

enum CardPosition: CGFloat {
    case top = 200
    case middle = 500
    case bottom = 750
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

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
          }
}
