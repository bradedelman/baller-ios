# Baller for iOS (Alpha 0.0.2)

Baller is a cross-platform View Framework.  It's not an Application framework, it's just a way to implement a view e.g. a "User Interface Screen".  

Baller Views are written in TypeScript.   The reuslting transpiled JavaScript file can be use in any of the existing Baller runtimes - currently iOS, Android and Web.  

Here's an overview of the functionality.

## View Types:

- Div: basic view container
- Field: text entry field
- Button: button
- Image: image
- Label: text 
- List: easy, but powerful (iOS uses a UICollectionView to implement this)
 
## Services:

- Http: for retrieval of JSON data
- Store: for easy, efficient storage/retrieval of JSON data


## API Documentation

Docs are coming soon.  For now, it's pretty easy to review the Classes and their APIs by looking at the core TypeScript implementation in the git repo [here](https://github.com/bradedelman/baller-core).

## Getting Started on iOS
 
It's really easy to get up and running with Baller in any Swift Application.  Let's walk through the steps to create an Application from scratch:

1. Create a new Swift App
	- launch XCode 12
	- Create New XCode Project (iOS, App, language: Swift, interface: Storyboard, project name: HostApp)
	- Confirm you have a class named ViewController with a method viewDidLoad
	- Confirm it builds, runs in Simulator - you see a white screen...
2. Add the Baller Swift Package to your App
	- File -> Swift Packages -> Add Package Dependency
	- Use this Package https://github.com/bradedelman/baller-ios
	- for Rules, Version -> Exact -> 0.0.2
	- Press Next (download occurs)
	- Pres Finish
	- Baller is now in your porject in a seciton called Swift Package Dependencies
	- Check it out - you'll be able to see all the source cdoe
3. Add a Sample Baller View to your App
	- Open ViewController.swift
	- at the top where you see import UIKit, add import Baller
	- under the comment // Do any additional setup after loading the view, add this source code:

```Swift
        // get a frame that isn't under the status bar
        var r = view.frame
        r.origin.y = r.origin.y + 30
        r.size.height = r.size.height - 30

        // create the baller view, size it, add to hierarchy
        let ballerView = BallerView(scaledWidth: 320); // width is "virtualed"
        ballerView.frame = r
        view.addSubview(ballerView)
        
        // don't do synchronous network requests... this is just to make
        // the example simple, and to make it clear that scripts can come from
        // anywhere e.g. the Web, a cache, the app bundle, etc.
        if let url = URL(string: "https://www.cleverfocus.com/baller/sample.js") {
            do {
                let contents = try String(contentsOf: url)
                
                // load the script into the Baller View
                ballerView.load(scriptContent: contents)
            } catch {
                // contents could not be loaded
            }
        }

```

### That's it!  Run and you'll see the sample view with a scrolling list of 1,000 numbers!   More coming soon on how to create your own views.
