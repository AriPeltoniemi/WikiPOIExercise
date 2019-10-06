# Exercise to display Wikipedia POIs in map




## Architecture

I chose SwiftUI and Combine as those looks way to go on long term, Apple seems to be committed to those, so I wanted to use opportunity to learn those while doing this.  

However I learned while doing this exercise that those are not yet mature enough.  For this exercise the big issue was it those not yet properly support maps, annotations and location manager. It took a bit time how to use MKMapView, MKAnnotation… on SwiftUI side.

The solution was to use UIViewRepresentable to make those available on SwiftUI. However annotations took even deeper approach and I use UIViewRepresentabled coordinator as Apple is guiding.  Peronally I think it is a bit on hack side.

I chose Apple locations tools as this was iOS exercise. Personally I would go for Google map based solution as it could be used on Android side as well.

## Maturity of SwiftUI & Combine

I would not use those for real app yet. Documentation. Is not up to date, there has been a lot of changes how these work during last months and most of tutorials does not actually work. 

## Basic flow

ContentView is the main view which sets everything.

First we start location manager and ask user location. MKMapView displays location but we also use “userWhereAbouts” ObservableObject to pass data for WIKI API URL coordinates.

While waiting location we initialize map with user centered and appropriate span. 

Once user location is found, we take coordinates and pass those on WikiAPIManager which fetches those from Wiki API. WikiAPIManager is an ObservableObject and publish WIKIPOIs to main view which is observing it.

MKMapView displays those as annotation.

When user selects one POI, “selectedWikiPOI” publishes that and main view opens slidable card for wiki page data.

One wiki page data is fetched on WikiPageManager, another ObservableObject which publishes it when fetched asynchronously.


### Requirements: 

Due to SwiftUi and Combine it takes Mac: Catalina  and Xcode 11.1 to run this.



### Shortcuts

Due the nature as exercise and some limitation on how much time can spend with these,  there is some shorcuts which would need to be properly implemented if real application.

-No localization

-Hardcoded a lot of sizes

-There is no tests. Normally there should be both unit and UI test. However I run out of time to implement any.

### Missing pictures

For some reason my Xcode does complain when creating Image(uiImage: UIImage) eventough accrding Apple documentation it should be like that and so shows few tutorials. Needed to comment out the picture fetching.

### Am I proud?

Not at all :(  I spent way way too much time with some compiler SwithUI oddies that I did not have time to refactor this to be a good quality code.

