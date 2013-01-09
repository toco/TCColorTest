//
//  TCColorTest.m
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

#import "TCColorTest.h"

#import <objc/runtime.h>
#import <objc/message.h>


NSString *const TCColorTestMotionEndedNotification = @"TCColorTestMotionEndedNotification";
NSString *const TCColorTestMotionEventKey = @"TCColorTestMotionEventKey";

typedef NS_ENUM(NSInteger, TCColorTestMode) {
    TCColorTestModeColor = 1,
    TCColorTestModeOpacity
};


@class TCArrowView;

@interface TCColorTestView : UIView

@property (nonatomic, strong) IBOutlet UISlider *redSlider;
@property (nonatomic, strong) IBOutlet UISlider *greenSlider;
@property (nonatomic, strong) IBOutlet UISlider *blueSlider;
@property (nonatomic, strong) IBOutlet UISlider *alphaSlider;

@property (nonatomic, strong) IBOutlet UILabel *colorLabel;
@property (nonatomic, strong) IBOutlet UILabel *classNameLabel;
@property (nonatomic, strong) IBOutlet UIButton *nilButton;
@property (nonatomic, strong) IBOutlet UIButton *methodButton;

@property (nonatomic, assign) BOOL disableHitTest;

- (void) setTransparent:(BOOL) transparent;
@end

@interface TCArrowView : UIView <TCColorTestObject>
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@end

#pragma mark - TCColorTest -

@interface TCColorTest () <UIActionSheetDelegate>
@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, strong) TCColorTestView *view;
@property (nonatomic, strong) TCArrowView *arrow;
@property (nonatomic, assign) CGPoint moveViewStartPoint;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, weak) id currentObject;
@property (nonatomic, strong) NSArray *availableMethods;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) TCColorTestMode currentMode;

@property (nonatomic, strong) NSString *currentMethodString;
@property (nonatomic, strong) NSString *currentObjectName;

@end

@implementation TCColorTest

#pragma mark - setup

static TCColorTest *theSingletonInstance = nil;
+ (id) colorTest {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            theSingletonInstance = [[self alloc] init];
            [self enableShakeSupport];
        });
    }
    return theSingletonInstance;
}


+ (void) colorTestInKeyWindow {
    [self colorTestInView:[[UIApplication sharedApplication] keyWindow]];
}

+ (void)colorTestInView:(UIView*)rootView {
    TCColorTest *aColorTest = [self colorTest];
    [aColorTest setupInView:rootView];
}

- (void) setupInView:(UIView*)rootView{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] addTCHitTest];
    });
    
    self.rootView = rootView;
    
    [self.rootView addSubview:self.view];
    [self.rootView addSubview:self.arrow];
    
    [self.view becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHide) name:TCColorTestMotionEndedNotification object:nil];
}

#pragma mark - view lifecycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TCColorTestMotionEndedNotification object:nil];
}

- (void)loadView {
    TCColorTestView *aTestView = [[TCColorTestView alloc] initWithFrame:CGRectMake(0, 0, 250, 220)];
    aTestView.center = CGPointMake(CGRectGetMidX(self.rootView.bounds), CGRectGetMidY(self.rootView.bounds));
    
    [aTestView.nilButton addTarget:self action:@selector(deleteColor:) forControlEvents:UIControlEventTouchUpInside];
    [aTestView.methodButton addTarget:self action:@selector(selectMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [aTestView.redSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [aTestView.greenSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [aTestView.blueSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [aTestView.alphaSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    aTestView.colorLabel.text = NSLocalizedString(@"-> start dragging here <-", nil);
    aTestView.classNameLabel.text = NSLocalizedString(@"shake device to hide/show", nil);
    
    self.view = aTestView;
    self.arrow = [[TCArrowView alloc] initWithFrame:self.rootView.bounds];
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.longPressGestureRecognizer.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];

}

#pragma mark - find customizable view
- (BOOL) canSetColorOfObject:(id)object {
    return [object respondsToSelector:@selector(tcAllowsColorTest)] && [object tcAllowsColorTest] && ([NSStringFromClass([object class]) rangeOfString:@"_"].location != 0);
}
- (void) findCustomizableView:(id)object {
    id currentObject = object;
    while (currentObject != nil) {
        if ([self canSetColorOfObject:currentObject]) {
            [self setCurrentObject:currentObject];
            break;
        } else {
            if ([currentObject respondsToSelector:@selector(superview)]) {
                currentObject = [currentObject superview];
            }
        }
    }
}



#pragma mark - touch handling

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.arrow.startPoint = [(UITouch*)[touches anyObject] locationInView:self.arrow];
    self.arrow.endPoint = CGPointZero;
    
    [self.view setTransparent:YES];
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!CGPointEqualToPoint(self.moveViewStartPoint, CGPointZero)) {
        CGPoint oldPosition = self.moveViewStartPoint;
        CGPoint newPosition = [[touches anyObject] locationInView:self.view.superview];
        CGPoint newCenter = self.view.center;
        newCenter.x += newPosition.x-oldPosition.x;
        newCenter.y += newPosition.y-oldPosition.y;
        self.view.center = newCenter;
        self.moveViewStartPoint = newPosition;
        return;
    }
    self.view.disableHitTest = YES;
    UITouch *otherTouch = [touches anyObject];
    self.arrow.endPoint = [otherTouch locationInView:self.arrow];
    
    id currentObject;
    UIView *aRootView = self.view.window;
    CGPoint point = [otherTouch locationInView:aRootView];
    if ([aRootView respondsToSelector:@selector(tcHitTest:withEvent:)]) {
        currentObject = [(UIView<TCHitTest>*)aRootView tcHitTest:point withEvent:event];
    } else {
        currentObject = [aRootView hitTest:point withEvent:event];
    }
    [self findCustomizableView:currentObject];
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.view.disableHitTest = NO;
    [self.view setTransparent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.moveViewStartPoint = CGPointZero;
}

- (void) longPress:(UILongPressGestureRecognizer*)gestureRecognizer {
    UIGestureRecognizerState state = [gestureRecognizer state];
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.moveViewStartPoint = [gestureRecognizer locationInView:self.view.superview];
            self.view.backgroundColor = [UIColor greenColor];
            break;
            
        default:
            break;
    }
}

#pragma mark - actions
- (BOOL)isHidden {
    return self.view.hidden;
}
- (void) showHide {
    self.view.disableHitTest = NO;
    BOOL shouldHide = !self.isHidden;
    if (!shouldHide) {
        BOOL aHidden = NO;
        self.view.hidden = aHidden;
        self.arrow.hidden = aHidden;
    }
    [UIView animateWithDuration:0.5
                     animations:^{
                         BOOL aAlpha = shouldHide ? 0.0 : 1.0;
                         self.view.alpha = aAlpha;
                         self.arrow.alpha = aAlpha;
                     }
                     completion:^(BOOL finished) {
                         if(shouldHide) {
                             BOOL aHidden = YES;
                             self.view.hidden = aHidden;
                             self.arrow.hidden = aHidden;
                         }
                     }];
}

- (void)setCurrentMode:(TCColorTestMode)currentMode {
    _currentMode = currentMode;
    
    BOOL initalEnabled = (currentMode == TCColorTestModeColor);
    self.view.redSlider.enabled = initalEnabled;
    self.view.blueSlider.enabled = initalEnabled;
    self.view.greenSlider.enabled = initalEnabled;
    self.view.alphaSlider.enabled = initalEnabled;
    
    if (currentMode == TCColorTestModeOpacity) {
        self.view.alphaSlider.enabled = YES;
    }
    
}
- (void) setEditable:(BOOL) editable {
    self.view.redSlider.enabled = editable;
    self.view.greenSlider.enabled = editable;
    self.view.blueSlider.enabled = editable;
    self.view.alphaSlider.enabled = editable;
    self.view.nilButton.enabled = editable;
    self.view.methodButton.enabled = editable;
}


- (void) updateSliders {
    CGFloat red, green, blue, alpha;
    red = green = blue = 0.0;
    alpha = 1.0;
    if (self.currentMode == TCColorTestModeOpacity) {
        alpha = [self opacityForObject:self.currentObject];
    } else {
        [[self colorForObject:self.currentObject] getRed:&red green:&green blue:&blue alpha:&alpha];
    }
    self.view.redSlider.value = red;
    self.view.greenSlider.value = green;
    self.view.blueSlider.value = blue;
    self.view.alphaSlider.value = alpha;
}
- (void) updateColorLabel {
    NSString *colorString = [NSString stringWithFormat:@"r: %.3f g: %.3f b: %.3f a: %.3f",self.view.redSlider.value, self.view.greenSlider.value, self.view.blueSlider.value, self.view.alphaSlider.value];
    
    self.view.colorLabel.text = colorString;
    NSLog(@"%@ %@ %@",colorString, self.currentObjectName, self.currentMethodString);
}
- (void) updateMethodButton {
    
    NSString *methodString = self.availableMethods[self.currentIndex];
    [self.view.methodButton setTitle:methodString forState:UIControlStateNormal];
    self.currentMethodString = methodString;
}
- (void) deleteColor:(id)sender {
    self.view.redSlider.value = 0.0;
    self.view.greenSlider.value = 0.0;
    self.view.blueSlider.value = 0.0;
    self.view.alphaSlider.value = 1.0;
    [self updateColorLabel];
    
    [self setColor:nil forObject:self.currentObject];
}

- (void) selectMethod:(id)sender {
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:self.availableMethods[self.currentIndex]
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    [self.availableMethods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [menu addButtonWithTitle:obj];
    }];
    [menu showInView:self.view.superview];
}

- (void)valueChanged:(id)sender {
    
    [self updateColorLabel];
    if (self.currentMode == TCColorTestModeOpacity) {
        [self setOpacity:self.view.alphaSlider.value forObject:self.currentObject];
    } else {
        [self setColor:[UIColor colorWithRed:self.view.redSlider.value
                                       green:self.view.greenSlider.value
                                        blue:self.view.blueSlider.value
                                       alpha:self.view.alphaSlider.value]
             forObject:self.currentObject];
    }
}

- (void) setCurrentObject:(id)currentObject {
    
    _currentObject = currentObject;
    self.currentIndex = 0;
    self.availableMethods = [currentObject respondsToSelector:@selector(tcAvailableMethods)] ? [currentObject tcAvailableMethods] : nil;
    if ([currentObject respondsToSelector:@selector(tcOpacity)] && [currentObject respondsToSelector:@selector(tcSetOpacity:)]) {
        self.availableMethods = [self.availableMethods arrayByAddingObject:@"opacity"];
    }
    self.view.methodButton.enabled = [self.availableMethods count];
    
    self.currentObjectName = NSStringFromClass([currentObject class]);
    self.view.classNameLabel.text = self.currentObjectName;

    [self updateMethodButton];
    [self updateSliders];
    [self updateColorLabel];
    [self setEditable: currentObject ? YES : NO];
    
    self.currentMode = TCColorTestModeColor;
}


#pragma mark - color handing
- (CGFloat) opacityForObject:(id)object {
    if ([object respondsToSelector:@selector(tcOpacity)])
        return [object tcOpacity];
    else
        return 1.0;
}
- (void) setOpacity:(CGFloat) opacity forObject:(id)object {
    if ([object respondsToSelector:@selector(tcSetOpacity:)])
        [object tcSetOpacity:opacity];
}
- (UIColor *)colorForObject:(id)object {
    UIColor *color = nil;
    if ([object respondsToSelector:@selector(tcColorForMethodAtIndex:)]) {
        @try {
            color = [object tcColorForMethodAtIndex:self.currentIndex];
        }
        @catch (NSException *exception) {
            NSLog(@"Wasn't able to get color from object %@ but I caugth the exception: %@",object,exception);
            color = nil;
        }
    }
    return color;
}
- (void)setColor:(UIColor *)color forObject:(id)object {
    if ([object respondsToSelector:@selector(tcSetColor:forMethodAtIndex:)]) {
        UIColor __strong *strongColor = color;
        @try {
            [object tcSetColor:strongColor forMethodAtIndex:self.currentIndex];
        }
        @catch (NSException *exception) {
            NSLog(@"Wasn't able to set color %@ for object %@ but I caugth the exception: %@",color,object,exception);
        }
        strongColor = nil;
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.currentIndex = buttonIndex;
    
    TCColorTestMode newMode = TCColorTestModeColor;
    
    if (buttonIndex+1==(NSInteger)[self.availableMethods count] && [self.currentObject respondsToSelector:@selector(tcOpacity)] && [self.currentObject respondsToSelector:@selector(tcSetOpacity:)]) {
        newMode = TCColorTestModeOpacity;
    }
    self.currentMode = newMode;
    
    [self updateMethodButton];
    [self updateSliders];
    [self updateColorLabel];
}



#pragma mark - adding behaviour to classes
+ (void)        addClass:(Class)classToSupport
  availableMethodsBlock:(tcAvailableMethodsBlock)methodsBlock
    colorForMethodBlock:(tcColorForMethodAtIndexBlock)colorForMethodBlock
 setColorForMethodBlock:(tcSetColorForMethodAtIndexBlock)setColorBlock {
    
    NSParameterAssert(classToSupport!=nil);
    NSParameterAssert(methodsBlock!=nil);
    NSParameterAssert(colorForMethodBlock!=nil);
    NSParameterAssert(setColorBlock!=nil);

    
    [self         addClass:classToSupport
    availableMethodsBlock:methodsBlock
      colorForMethodBlock:colorForMethodBlock
   setColorForMethodBlock:setColorBlock
              opacityBlock:nil
           setOpacityBlock:nil];
    
}
+ (void)        addClass:(Class)classToSupport
  availableMethodsBlock:(tcAvailableMethodsBlock)methodsBlock
    colorForMethodBlock:(tcColorForMethodAtIndexBlock)colorForMethodBlock
 setColorForMethodBlock:(tcSetColorForMethodAtIndexBlock)setColorBlock
            opacityBlock:(tcOpacityBlock) opacityBlockOrNil
         setOpacityBlock:(tcSetOpacityBlock) setOpacityBlockOrNil {
    
    NSParameterAssert(classToSupport!=nil);
    NSParameterAssert(methodsBlock!=nil);
    NSParameterAssert(colorForMethodBlock!=nil);
    NSParameterAssert(setColorBlock!=nil);


    //http://www.friday.com/bbum/2011/03/17/ios-4-3-imp_implementationwithblock/
    
    // - (BOOL) tcAllowsColorTest
    SEL tcAllowsColorTestSel = @selector(tcAllowsColorTest);
    IMP tcAllowsColorTestIMP = imp_implementationWithBlock(^(id _self){return YES;});
    class_addMethod(classToSupport, tcAllowsColorTestSel, tcAllowsColorTestIMP, "c@:@");
    
    // - (NSArray*) tcAvailableMethods
    SEL tcAvailableMethodsSel = @selector(tcAvailableMethods);
    IMP tcAvailableMethodsImp = imp_implementationWithBlock(methodsBlock);
    class_addMethod(classToSupport, tcAvailableMethodsSel, tcAvailableMethodsImp, "@@:");
    
    // - (UIColor*) tcColorForMethodAtIndex:(NSUInteger) index;
    SEL tcColorForMethodAtIndexSel = @selector(tcColorForMethodAtIndex:);
    IMP tcColorForMethodAtIndexImp = imp_implementationWithBlock(colorForMethodBlock);
    class_addMethod(classToSupport, tcColorForMethodAtIndexSel, tcColorForMethodAtIndexImp, "@@:i");
    
    // - (void) tcSetColor:(UIColor*)color forMethodAtIndex:(NSUInteger) index;
    SEL tcSetColorForMethodAtIndexSel = @selector(tcSetColor:forMethodAtIndex:);
    IMP tcSetColorForMethodAtIndexImp = imp_implementationWithBlock(setColorBlock);
    class_addMethod(classToSupport, tcSetColorForMethodAtIndexSel, tcSetColorForMethodAtIndexImp, "v@:@i");
    
    if (opacityBlockOrNil && setOpacityBlockOrNil) {
        //- (CGFloat) tcOpacity;
        SEL tcOpacitySel = @selector(tcOpacity);
        IMP tcOpacityImp = imp_implementationWithBlock(opacityBlockOrNil);
        class_addMethod(classToSupport, tcOpacitySel, tcOpacityImp, "d@:");
        
        //- (void) tcSetOpacity:(CGFloat)opacity;
        SEL tcSetOpacitySel = @selector(tcSetOpacity:);
        IMP tcSetOpacityImp = imp_implementationWithBlock(setOpacityBlockOrNil);
        class_addMethod(classToSupport, tcSetOpacitySel, tcSetOpacityImp, "v@:d");
    }
}
+ (void)disableForClass:(Class)classToDisable {
    if (!classToDisable) {
        return;
    }
    // - (BOOL) tcAllowsColorTest
    SEL tcAllowsColorTestSel = @selector(tcAllowsColorTest);
    IMP tcAllowsColorTestIMP = imp_implementationWithBlock(^(id _self){return NO;});
    class_addMethod(classToDisable, tcAllowsColorTestSel, tcAllowsColorTestIMP, "v@:@");
}
+ (void)disableHitTestDescendenceForClass:(Class)blockingClass {
    if (!blockingClass) {
        return;
    }
    SEL tcHitTestSel = @selector(tcHitTest:withEvent:);
    IMP tcHitTestImp = imp_implementationWithBlock(^UIView*(UIView* _self, CGPoint point, UIEvent *event) {
        if ([_self pointInside:point withEvent:event] && ([NSStringFromClass([_self class]) rangeOfString:@"_"].location != 0)) {
            return _self;
        } else {
            return nil;
        }
    });
    class_addMethod(blockingClass, tcHitTestSel, tcHitTestImp, "v@:{CGPoint=dd}@");
}


#pragma mark - additional setup

+ (void) enableShakeSupport {
    SEL motionEndendSel = @selector(motionEnded:withEvent:);
    IMP motionEndendImp = imp_implementationWithBlock(^(id _self, UIEventSubtype motion, UIEvent *event) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TCColorTestMotionEndedNotification object:_self userInfo:@{TCColorTestMotionEventKey : event}];
    });
    class_addMethod([UIWindow class], motionEndendSel, motionEndendImp, "v@:i@");
}
+ (void) addTCHitTest {
    //    struct CGPoint {
    //        CGFloat x;
    //        CGFloat y;
    //    };
    //    typedef struct CGPoint CGPoint;
    //        - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
    
    SEL tcHitTestSel = @selector(tcHitTest:withEvent:);
    IMP tcHitTestImp = imp_implementationWithBlock(^UIView*(UIView* _self, CGPoint point, UIEvent *event) {
        if ([_self pointInside:point withEvent:event] && ([NSStringFromClass([_self class]) rangeOfString:@"_"].location != 0)) {
            __block UIView *hitView = _self;
            [_self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIView *aHitView = nil;
                CGPoint aPoint = [_self convertPoint:point toView:obj];
                if ([obj respondsToSelector:tcHitTestSel]) {
                    aHitView = [(UIView<TCHitTest>*)obj tcHitTest:aPoint withEvent:event];
                } else {
                    aHitView = [obj hitTest:aPoint withEvent:event];
                }
                if (aHitView && ![aHitView isHidden] && aHitView.alpha > 0.01) {
                    hitView = aHitView;
                }
            }];
            return hitView;
        } else {
            return nil;
        }
    });
    class_addMethod([UIView class], tcHitTestSel, tcHitTestImp, "v@:{CGPoint=dd}@");
}

@end

#pragma mark - TCColorTestView -

@implementation TCColorTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.redSlider = [UISlider new];
        [self addSubview:self.redSlider];
        self.redSlider.minimumTrackTintColor = [UIColor redColor];
        self.redSlider.maximumTrackTintColor = nil;
        self.redSlider.thumbTintColor = [UIColor redColor];
        
        self.greenSlider = [UISlider new];
        [self addSubview:self.greenSlider];
        self.greenSlider.minimumTrackTintColor = [UIColor greenColor];
        self.greenSlider.maximumTrackTintColor = nil;
        self.greenSlider.thumbTintColor = [UIColor greenColor];
        
        self.blueSlider = [UISlider new];
        [self addSubview:self.blueSlider];
        self.blueSlider.minimumTrackTintColor = [UIColor blueColor];
        self.blueSlider.maximumTrackTintColor = nil;
        self.blueSlider.thumbTintColor = [UIColor blueColor];
        
        self.alphaSlider = [UISlider new];
        [self addSubview:self.alphaSlider];
        self.alphaSlider.minimumTrackTintColor = [UIColor whiteColor];
        self.alphaSlider.maximumTrackTintColor = nil;
        self.alphaSlider.thumbTintColor = nil;
        
        self.colorLabel = [UILabel new];
        self.colorLabel.adjustsFontSizeToFitWidth = YES;
        self.colorLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.colorLabel];
        
        self.classNameLabel = [UILabel new];
        self.classNameLabel.adjustsFontSizeToFitWidth = YES;
        self.classNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.classNameLabel];
        
        self.nilButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.nilButton setTitle:@"Nil" forState:UIControlStateNormal];
        [self addSubview:self.nilButton];
        
        self.methodButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.methodButton setTitle:@"Method" forState:UIControlStateNormal];
        
        self.methodButton.enabled = NO;
        [self addSubview:self.methodButton];
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        
        [self layoutSubviews];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *aBezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    aBezierPath.lineWidth = 1.0;
    [[UIColor blackColor] set];
    [aBezierPath stroke];
}

- (void)layoutSubviews {
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width-2;
    CGFloat heightPerElement = floor((height-2.0)/18); // 6*2+2*3
    CGFloat normalHeight = heightPerElement+heightPerElement;
    CGFloat buttonHeight = heightPerElement+heightPerElement+heightPerElement;
    CGFloat currentOriginY = 1.0;
    CGFloat currentOriginX = 1.0;
    
    self.redSlider.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.greenSlider.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.blueSlider.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.alphaSlider.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.nilButton.frame = CGRectMake(currentOriginX, currentOriginY, width, buttonHeight);
    currentOriginY += buttonHeight;
    
    self.colorLabel.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.classNameLabel.frame = CGRectMake(currentOriginX, currentOriginY, width, normalHeight);
    currentOriginY += normalHeight;
    
    self.methodButton.frame = CGRectMake(currentOriginX, currentOriginY, width, buttonHeight);
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - touch
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [super pointInside:point withEvent:event] && !self.disableHitTest;
}

#pragma mark - visibility
- (void) setTransparent:(BOOL) transparent {
    self.alpha = transparent ? 0.5 : 1.0;
}

#pragma mark -
- (BOOL) tcAllowsColorTest {
    return NO;
}
@end

#pragma mark - TCArrowView -

@implementation TCArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    [self setNeedsDisplay];
}
- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    [self setNeedsDisplay];
}
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};
CGFloat angleBetweenPoints(CGPoint first, CGPoint second);
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return rads;
}

- (UIBezierPath*)arrowFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
    if (CGPointEqualToPoint(startPoint, CGPointZero) || CGPointEqualToPoint(endPoint, CGPointZero))
        return nil;
    
    CGFloat distance = distanceBetweenPoints(startPoint, endPoint);
    CGFloat angle = angleBetweenPoints(startPoint, endPoint)+M_PI_2;
    if (0<=(startPoint.x-endPoint.x))
        angle += M_PI;
    
    CGFloat arrowWidth_2 = 2;
    CGFloat tipSideWidth = 10; // (b.x-c.x) && (e.x-f.x)
    CGFloat tipHeight = 15; // (d.y-b.y)
    /*
     *       a---g
     *       |   |
     *       |   |
     *       |   |
     *     c-b   f-e
     *      \     /
     *       \   /
     *        \ /
     *         d
     */
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGPoint currentPoint = startPoint;
    
    currentPoint.x-=arrowWidth_2; // a
    [bezierPath moveToPoint:currentPoint]; //startPoint
    currentPoint.y+=distance-tipHeight; //b
    [bezierPath addLineToPoint:currentPoint]; //b
    currentPoint.x-=tipSideWidth; // c
    [bezierPath addLineToPoint:currentPoint]; //c
    currentPoint = startPoint; // d
    currentPoint.y+=distance; // d
    [bezierPath addLineToPoint:currentPoint]; //d
    currentPoint.x+=arrowWidth_2+tipSideWidth; //e
    currentPoint.y-=tipHeight; //e
    [bezierPath addLineToPoint:currentPoint]; //e
    currentPoint.x-=tipSideWidth; //f
    [bezierPath addLineToPoint:currentPoint]; //f
    currentPoint.y = startPoint.y; //g
    [bezierPath addLineToPoint:currentPoint]; //g
    [bezierPath closePath];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, startPoint.x, startPoint.y);
    transform = CGAffineTransformRotate(transform, -angle);
    transform = CGAffineTransformTranslate(transform, -startPoint.x, -startPoint.y);
    [bezierPath applyTransform:transform];
    
    return bezierPath;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *arrow = [self arrowFromPoint:self.startPoint toPoint:self.endPoint];
    [[UIColor blackColor] set];
    [arrow fill];
    [[UIColor whiteColor] set];
    [arrow stroke];
}

- (BOOL)tcAllowsColorTest {
    return NO;
}
@end
