//
//  TCColorTest.h
//
//  Created by Tobias Conradi on 21.12.12.
//  Copyright (c) 2012 Tobias Conradi. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/********* QUICK AND EASY *********
 * copy TCColorTest.h+.m and TCColorTestBehaviours.h+.m to your Xcode project
 * add following imports to your app delegate
 *
 * #import "TCColorTest.h"
 * #import "TCColorTestBehaviours.h"
 *
 * add the following lines to the end of applicationDidFinishLaunching:
 *
 * [TCColorTest colorTestInKeyWindow];
 * [TCColorTestBehaviours addDefaultBehaviours];
 *
 * shake the device to show/hide TCColorTest
 * tap and hold until TCColorTest is green to move TCColorTest
 */


/*
 * TCColorTest requires view classes to conform to the TCColorTestObject protocol.
 * This can be archieved by:
 * - Implementing the protocol directly
 * - Adding a category which conforms to TCColorTestObject
 * - using the class methods of TCColorTest
 *
 * [TCColorTestBehaviours addDefaultBehaviours] can be used to add support for all UIKit views
 *
 */
@protocol TCColorTestObject <NSObject>
/*
 * return NO to disable TCColorTest for this class even when a superclass supports TCColorTest
 */
- (BOOL) tcAllowsColorTest;
@optional
/*
 * required if tcAllowsColorTest returns YES
 */
// returns array of with available method name strings
- (NSArray*) tcAvailableMethods;
// returns color for method at index index
- (UIColor*) tcColorForMethodAtIndex:(NSUInteger) index;
// sets the color for method at index index
- (void) tcSetColor:(UIColor*)color forMethodAtIndex:(NSUInteger) index;

/*
 * optional methods to enable opacity support
 */
// returns opacity of the object
-(CGFloat) tcOpacity;
// sets opacity of the object
- (void) tcSetOpacity:(CGFloat)opacity;
@end


typedef BOOL(^tcAllowsColorTestBlock)(id _self);
typedef NSArray* (^tcAvailableMethodsBlock)(id _self);
typedef UIColor* (^tcColorForMethodAtIndexBlock)(id _self, NSUInteger index);
typedef void(^tcSetColorForMethodAtIndexBlock)(id _self, UIColor *color, NSUInteger index);
typedef CGFloat(^ tcOpacityBlock)(id _self);
typedef void(^tcSetOpacityBlock) (id _self, CGFloat opacity);


@interface TCColorTest : UIViewController

@property (nonatomic, readonly, getter = isHidden) BOOL hidden;

// singleton instance
+ (id) colorTest;
// setup the singleton TCColorTest in the keyWindow (shake to show/hide)
+ (void) colorTestInKeyWindow;
// setup the singleton TCColorTest in an specific view (shake to show/hide)
+ (void) colorTestInView:(UIView*)rootView;

// setup an instance of TCColorTest in an specific view (no automatic show/hide)
- (void) setupInView:(UIView*)rootView;

// show/hide the TCColorTest
- (void) showHide;


// configure support for existing classes
+ (void)        addClass:(Class)classToSupport
  availableMethodsBlock:(tcAvailableMethodsBlock)methodsBlock
    colorForMethodBlock:(tcColorForMethodAtIndexBlock)colorForMethodBlock
 setColorForMethodBlock:(tcSetColorForMethodAtIndexBlock)setColorBlock;


+ (void)        addClass:(Class)classToSupport
   availableMethodsBlock:(tcAvailableMethodsBlock)methodsBlock
     colorForMethodBlock:(tcColorForMethodAtIndexBlock)colorForMethodBlock
  setColorForMethodBlock:(tcSetColorForMethodAtIndexBlock)setColorBlock
            opacityBlock:(tcOpacityBlock) opacityBlockOrNil
         setOpacityBlock:(tcSetOpacityBlock) setOpacityBlockOrNil;

+ (void) disableForClass:(Class)classToDisable;

// stops the tcHitTest at the class (use for some classes like UIProgessView, UITabBar or UINavigationBar)
+ (void) disableHitTestDescendenceForClass:(Class)blockingClass;

@end

@protocol TCHitTest <NSObject>
// Method like -[UIView hitTest:withEvent:] but it ignores the userInteractionEnabled property.
- (UIView*) tcHitTest:(CGPoint)point withEvent:(UIEvent*)event;
@end