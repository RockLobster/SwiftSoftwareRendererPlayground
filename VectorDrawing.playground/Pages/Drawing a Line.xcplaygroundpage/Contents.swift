//: [Back to Table of Contents](@first) | [Previous](@previous)
//: ## Drawing a line
import AppKit

//: Before we are able to draw anything we need to have a render target
import RenderingBase

let bitmap = Bitmap(width: 100, height: 100)
/*:
We also want to be able to show the result.
While playgrounds are able to show Images directly they can no be resized there.
But we want to see ugly and pixely details here so we prepare an image view that can be resized.
*/
let imageView = NSImageView(frame: CGRectMake(0, 0, 400, 400))
imageView.imageScaling = NSImageScaling.ScaleAxesIndependently

//: Lets first make sure that our render target is cleared
bitmap.clearWithBlack()

//: We need someone who is actually able to draw lines to the render target
let lineDrawer = BresenhamLineDrawer(target: bitmap)

/*: 
Now let's draw some lines 
> **Important:**
> A line is here defined by two points in pixel coordinates
>> **Hint:**
>> Feel free to add your own lines
*/
lineDrawer.drawLine(Point(0, 20), end: Point(Float(bitmap.width-1), Float(20)), color: Color.Green())
lineDrawer.drawLine(Point(20, 0), end: Point(Float(20), Float(bitmap.height-1)), color: Color.Green())
lineDrawer.drawLine(Point(0, 0),  end: Point(Float(bitmap.width-1), Float(bitmap.height/2-1)), color: Color.White())
lineDrawer.drawLine(Point(50,60), end: Point(50,60), color: Color.Green())
lineDrawer.drawLine(Point(0, 0),  end: Point(99, 99), color: Color.Blue())
lineDrawer.drawLine(Point(0, 99), end: Point(99, 70), color: Color.Red())

//: And now to see the result of our line drawing:
imageView.image = bitmap.createNSImage()



//: [Next page](@next)
