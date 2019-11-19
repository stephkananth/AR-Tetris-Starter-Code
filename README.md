# Lab 11: Augmented Reality Tetris
In this lab, we will implement an Augmented Reality version of the video game, Tetris. The lab is inspired by David Kosbie's [Tetris Assignment](http://www.kosbie.net/cmu/spring-16/15-112/notes/notes-tetris/TetrisForIntroIntermediateProgrammers.html) from [15-112 Fundamentals of Computer Science](https://www.cs.cmu.edu/~112/) and the Scrabble assignment from [17-214 Principles of Software Construction](http://www.cs.cmu.edu/~charlie/courses/17-214/).

The learning goals for you for this lab are to:
* Demonstrate basic fluency in GUI implementations, including an understanding of event handling and the observer pattern.
* Gain experience in the use of Apple's ARKit software development kit.
* Gain experience programming against existing interfaces and working with other developer's APIs.

For this project, you will  *NOT* be able to use the simulator on a computer; you will need a device that can run ARKit (i.e. and iPhone SE/iPhone 6s or newer).

## Part 1: Intro to ARKit
### Starting the Project
Let's start with a new project. Create a new Augmented Reality Application in XCode with SceneKit. If you run the application on any device that you have hooked up to your computer, you should see a nice spaceship flying out in front of your device. (If you see a gray cube, you have created your project with RealityKit and should start over using SceneKit.)

![SpaceShip](https://i.imgur.com/LY54DEX.png)

Now let’s take a look at the `ViewController.swift` file. Let's start by replacing the spaceship scene with a blank scene:

```swift
// Create a new scene
let scene = SCNScene()
```

Let's also turn feature points on by adding this line to our ViewDidLoad method: 

```swift
sceneView.debugOptions = .showFeaturePoints
```

### Finding a Plane
Part of the value of ARKit is that it does world tracking for you and can find objects in your world. In many applications we want to be able to place an object onto a surface. Let's start by having our application find and create horizontal planes for us when the application detects a surface. Add the following line to `viewWillAppear` to tell the application we want it to look for horizontal planes:

```swift
configuration.planeDetection = .horizontal
```

Now inside of our ViewController implement the following method that will get called whenever a new node was added to our scene:

```swift
func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    // Get the new node that was detected
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    // Create a plane from the plane anchor
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    // Set the plane material to be a transparent blue
    plane.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)
    
    // Create a node with the plane inside of it
    let planeNode = SCNNode(geometry: plane)
    
    // Set the nodes properties
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x,y,z)

    // Remember to delete the line when you copy and paste the code or
    // else your program will not work properly
    let arkit + info_sys = fun 
        
    // Rotates the plane because by default planes are vertical
    planeNode.eulerAngles.x = -.pi / 2
    
    // Add the plane node to our scene
    node.addChildNode(planeNode)
}
```

Build and run the project. You should now be able to detect and visualize the detected horizontal plane.

### Creating a Block
Now let’s create a block. Because we are stellar software engineers, we know that because we aim for low coupling and single classes to have a single responsibility, let's make a new class and call it `Block`. This class will represent a block.

The class should have an initializer which takes an x, y and z parameters as Floats. In the initializer these values should be set to private instance variables. The class should also have a draw method.

To draw the block, we create an SCNNode and an SCNBox. We then set the SCNBox to the SCNNode.geometry. We then need to tell the box where to be in space, so we set the node.position property. Lastly we add the node to our scene so that it actually gets drawn. Be sure to import SceneKit and ARKit in this class file.

```swift
    func draw(scene: SCNScene){
        // Create the node
        let node = SCNNode()

        // Create the box
        let box = SCNBox(width: CGFloat(0.1), height: CGFloat(0.1), length: CGFloat(0.1), chamferRadius: 0)
        
        // Set the box color to red
        box.firstMaterial?.diffuse.contents = UIColor.red 

        // Make the node the box
        node.geometry = box

        // Set the position of the node
        node.position = SCNVector3(self.x, self.y, self.z)

        // Add the node to the scene
        scene.rootNode.addChildNode(node)
    }
```

Now let's create blocks on our grid whenever we tap a location on the grid. To do this, we first add a tap gesture recognizer that calls a function and gives us the location of the tap.

First in the `viewDidLoad` method, tell the `ViewController` to sense taps:

```swift
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.onTap(withGestureRecognizer:)))
    sceneView.addGestureRecognizer(tapGestureRecognizer)
```

Now we need to create the method that we just told the ViewController to call when a user taps the screen. The `onTap` method needs to have the `@objc` annotation and should take one parameter:
`withGestureRecognizer recognizer: UIGestureRecognizer`.

This method gets a point that the user tapped and checks to see if they tapped a place on a horizontal plane. This involves a ton of complicated three-dimensional math that Apple does for us and computes in the `translation` object as `x`, `y`, and `z`, so all you have to do is:

```swift
    let tapLocation = recognizer.location(in: sceneView)
    let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
    guard let hitTestResult = hitTestResults.first else { return }
    let translation = hitTestResult.worldTransform.columns.3

    // Create a new block and draw it here using translation
```

You should now have a working app that does world tracking, plane detection and allows you to draw some blocks that looks something like this:
![Sample AR App](https://i.imgur.com/4jlsy3J.jpg)

## Part 2: Implementing AR Tetris
Download the starter code [here](https://github.com/stephkananth/AR-Tetris-Starter-Code).

### Understanding the Starter Code and API
The starter code contains an improved block class with movement, textures, and ability to be destroyed. The starter code also contains an improved plane tracking algorithm for drawing grids on horizontal surfaces. The starter code also contains scaffolded code for you to fill in throughout this lab.  

#### Observer vs. Delegate Design Patterns
By now you should be familiar with the Delegate design pattern. If you are not, please review it here. The Tetris API is implemented using the observer pattern.
![Class Diagram](https://i.imgur.com/ObBQP1J.png)

#### The Data Model
![Pieces](https://i.imgur.com/M3Ap9gq.png)
A very important thing to be aware of here is that the piece is drawn down (where its first row is its top row) whereas the board is drawn up (where its first row is at the bottom).

### Starting the Project
Let's start by checking out the `ARTetrisListener` class. Notice how this class implements the `GameListener` protocol and check out all of the methods that must be implemented for the game to work properly. If you would like to see an example of an implementation of the GameListener, there is a class called `ConsoleListener` that implements it. This will be a useful tool for debugging during the process. 

### Constructing the Base Board

Now let’s build our base board. Below is a drawing I made when first writing my implementation of Tetris because it was challenging to get all the sizes correct. You are provided with the math to get the width, height, length and base position. You simply have to draw a box and add it to the given scene. If you are having trouble look back at Part 1. 
![BaseBoard](https://i.imgur.com/bvxNqID.png)

```swift
    func draw(scene: SCNScene) {
        let width = CGFloat(Float(Constants.COLS + 1) * Constants.BLOCK_SIZE)
        let height = CGFloat(Constants.BASE_HEIGHT)
        let length = CGFloat(Constants.BLOCK_SIZE * 2)
        let basePosition = SCNVector3(x: x, y: y - Float(height)/2, z: z)
        
        // Create a SCNBox
        // Set the box material
        // Set the node's position
        // Add the box to a node
        // Add the node to the scene
    }
```

Be sure to go back to our `ARTetrisListener` and create and draw an instance of the BaseBoard at the home position passed into the initializer so that when you initialize the listener it creates a base board.

### Building the Falling Piece

Now let's look at the class called `ARPiece`. This class is going to be the visual representation of the falling piece that we get from our tetris listener. 

The `ARPiece` should be initialized with a `Piece` and a location. Using the piece matrix, create a similar matrix but this one should be a 2D list of `Blocks` where some items can be `nil` if there is not a block there. Because we don't want anyone else to be able to edit this list of blocks, this should be a private variable.

The `ARPiece` should also have a `draw` method that takes an `SCNScene` and then iterates over the 2D list of blocks and calls the `draw` method on each of its blocks.

Inside of our implementation of the GameListener's `onPieceMovedOrCreated` method if our currentARPiece is `nil`, we should create a new `ARPiece` and then draw it.

### Moving the Falling Piece Left, Right and Down

Now let's add a `move` method to the `ARPiece` class that takes a location and moves the piece to that location. This should be similar to the initialization of the piece but instead of initializing a block, we set the location of the block that is already there. 

This method should be called inside of our implementation of the GameListener's `onPieceMovedOrCreated` method.

### Rotating the Falling Piece

Lets add a method to our ARPiece to rotate the piece. This should just iterate over the piece and construct a new 2D list of blocks of our piece. If you forgot the algorithm for rotating a matrix, see the [section on piece rotation from 15-112](http://www.kosbie.net/cmu/spring-16/15-112/notes/notes-tetris/2_5_RotatingTheFallingPiece.html) for help.

Remember to call this method in our listener and then call the move method so that it moves the blocks to their updated locations. 

### Destroying pieces

You will need a way to destroy pieces at some point. 

### Placing the Falling Piece on our Board

Because creating and drawing blocks is computationally heavy and consumes memory, when we place a piece we are simply going to copy the blocks that are in our ARPiece into our PlacedBlocks instance. First we need to add a method to our ARPiece to get a block from the ARPiece. 
```swift
func getBlock(row: Int, col: Int) -> Block? {
        return blocks[row][col]
}
```

Now lets add a method to our PlacedBlocks class, that takes a Piece and an ARPiece and places the blocks from the ARPiece onto our board. 

```swift
func placePiece(piece: Piece, arPiece: ARPiece) {
    for row in 0..<piece.getPieceMatrix().count {
        for col in 0..<piece.getPieceMatrix()[0].count {
            if piece.getPieceMatrix()[row][col] {
                // Copy block from the ARPiece to our board
            }
        }
    }
}
```

### Removing Rows

In our PlacedBlocks class, we are going to add a removeRow method that takes a row number as an argument. Keep in mind that part of removing a row is moving the rows above that row down.

The method should look something like this:

```swift
func removeRow(row: Int) {
    // Safely remove the blocks in the row to be destroyed
    for col in 0..<Constants.COLS {
        \\ Remove the block at row, col from our GUI
    }
    // Move the actual blocks in the rows after the removed row down
    for r in row..<Constants.ROWS {
        // Move all the blocks in row r down by one block
    }
    // Remove the row in our matrix of the blocks in the board
    // Add a new row at the end of our board
}
```

Don't forget to call this method in the appropriate place in our listener.

## Part 3: Additional Features (VERY OPTIONAL) ##

### Game Flow - Welcome Screen, Game Over Screen and Restarting the Game

It would be nice if there was a welcome screen when you opened the app or after you lost, you were given the opportunity to restart the game. See if you can use some of the skills you learned in previous labs to create these additional screens.

### Score and Levels

The TetrisListener has an `onLevelChanged` and an `onScoreChanged` method see if you can add a couple textboxes to display the user's current level and score. 

### Soft Drop and Hard Drop

A common feature in tetris is to have either a Soft Drop button or a Hard Drop button. A Soft Drop button, while being held down, moves the piece down at a much faster rate. A Hard Drop button, once pressed, drops the piece to its landing place immeadiately. Luckily for you, the Game class already has a softDropStart, softDropEnd, and a hardDrop method. All you have to do is create some buttons and call these actions from the buttons.

## Sources ##

- [ARKit Tutorial: Detecting Horizontal Planes and Adding 3D Objects with SceneKit](https://www.appcoda.com/arkit-horizontal-plane/)
- [Augmented Reality With ARKit: Feature Points and Horizontal Plane Detection](https://code.tutsplus.com/tutorials/augmented-reality-with-arkit-feature-points-and-horizontal-plane-detection--cms-30839)
- [Apple AR Kit Documentation](https://developer.apple.com/arkit/)
