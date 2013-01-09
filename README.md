TCColorTest
===========

Change colors within an iOS App without time-killing trial and error using build and run cycles.

###Why:  
Have you ever had the problem that the tint colors the designer gave you looked really different on the device? 

Even if you found the perfect matching tint color for the navigation bar, it looks different when setting it for the segment control?

![Screenshot1](https://raw.github.com/toco/TCColorTest/screenshots/Screenshot1.png) ![Screenshot1](https://raw.github.com/toco/TCColorTest/screenshots/Screenshot2.png)


###Solution:  

Add TCColorTest temporarily to your project and set it up.
To change the color of an element you just have to select the element by dragging from TCColorTest to the element.
Then you can set the color by adjusting the sliders.

Shake the device to hide/reveal TCColorTest.
Tap and hold TCColorTest until it is green – then move it about.

## Installation:

1 Copy add TCColorTest folder to your project

2 Add these imports to your app delegate

	#import "TCColorTest.h"
	#import "TCColorTestBehaviours.h" 
	
3 Add the following code to the end of applicationDidFinishLaunching:
 
 	[TCColorTest colorTestInKeyWindow];
 	[TCColorTestBehaviours addDefaultBehaviours];  


## Sample App

UICatalog is included as a sample app.
Just download the repo, open the project and hit build and run to try TCColorTest.

## Add support for your own UI elements

You can add support for your own custom UI elements by making your class confirm to the TCColorTestObject protocol in your implementation or by using blocks.


```
// Sample for UIButton
    [TCColorTest addClass:[UIButton class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"backgroundColor",@"tintColor",@"titleColor",@"titleShadowColor"];
   }
     colorForMethodBlock:^UIColor *(UIButton* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self backgroundColor];
             case 1:
                 return [_self tintColor];
             case 2:
                 return [_self titleColorForState:UIControlStateNormal];
             case 3:
                 return [_self titleShadowColorForState:UIControlStateNormal];
             default:
                 return nil;
         }
     }
  setColorForMethodBlock:^(UIButton* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setBackgroundColor:color];
              break;
          case 1:
              [_self setTintColor:color];
              break;
          case 2:
              [_self setTitleColor:color forState:UIControlStateNormal];
              break;
          case 3:
              [_self setTitleShadowColor:color forState:UIControlStateNormal];
              break;
          default:
               break;

      }
  }]; 

```

## License

Copyright (c) 2012 Tobias Conradi. All rights reserved.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
