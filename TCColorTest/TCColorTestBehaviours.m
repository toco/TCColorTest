//
//  TCColorTestBehaviours.m
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

#import "TCColorTestBehaviours.h"
#import "TCColorTest.h"

@implementation TCColorTestBehaviours

+ (void) addDefaultBehaviours {
    
#pragma mark UIActivityIndicatorView
    //UIActivityIndicatorView color
    [TCColorTest addClass:[UIActivityIndicatorView class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"color"];
   }
     colorForMethodBlock:^UIColor *(UIActivityIndicatorView* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self color];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UIActivityIndicatorView* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setColor:color];
              break;
          default:
              break;
      }
  }];

#pragma mark UIButton
    // UIButton backgroundColor, textColor, shaddowColor
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
    
#pragma mark UILabel
    // UILabel backgroundColor, textColor, shaddowColor
    [TCColorTest addClass:[UILabel class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"backgroundColor",@"textColor",@"shadowColor"];
   }
     colorForMethodBlock:^UIColor *(UILabel* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self backgroundColor];
             case 1:
                 return [_self textColor];
             case 2:
                 return [_self shadowColor];
             default:
                 return nil;
         }
     }
  setColorForMethodBlock:^(UILabel* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setBackgroundColor:color];
              break;
          case 1:
              [_self setTextColor:color];
              break;
          case 2:
              [_self setShadowColor:color];
              break;
          default:
              break;
              
      }
  }];
#pragma mark UINavigationBar
    // UINavigationBar tintColor
    [TCColorTest addClass:[UINavigationBar class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"tintColor"];
   }
     colorForMethodBlock:^UIColor *(UINavigationBar* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self tintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UINavigationBar* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UINavigationBar class]];

#pragma mark UIPageControl (iOS6)
    // UIPageControl backgroundColor, progressTintColor, trackTintColor
    // both properties only available in iOS6
    if ([[UIPageControl new] respondsToSelector:@selector(pageIndicatorTintColor)]) {
        [TCColorTest addClass:[UIPageControl class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"backgroundColor",@"pageIndicatorTintColor",@"currentPageIndicatorTintColor"];
       }
         colorForMethodBlock:^UIColor *(UIPageControl* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self backgroundColor];
                 case 1:
                     return [_self pageIndicatorTintColor];
                     break;
                 case 2:
                     return [_self currentPageIndicatorTintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UIPageControl* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setBackgroundColor:color];
                  break;
              case 1:
                  [_self setPageIndicatorTintColor:color];
                  break;
              case 2:
                  [_self setCurrentPageIndicatorTintColor:color];
                  break;
              default:
                  break;
          }
      }];
    }
#pragma mark UIProgressView
    // UIProgressView progressTintColor, trackTintColor
    [TCColorTest addClass:[UIProgressView class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"progressTintColor",@"trackTintColor"];
   }
     colorForMethodBlock:^UIColor *(UIProgressView* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self progressTintColor];
                 break;
             case 1:
                 return [_self trackTintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UIProgressView* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setProgressTintColor:color];
              break;
          case 1:
              [_self setTrackTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UIProgressView class]];
#pragma mark UIRefreshControl (iOS6)
    // UIRefreshControl tintColor
    if (NSClassFromString(@"UIRefreshControl")) {
        [TCColorTest addClass:[UIRefreshControl class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"tintColor"];
       }
         colorForMethodBlock:^UIColor *(UIRefreshControl* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self tintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UIRefreshControl* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setTintColor:color];
                  break;
              default:
                  break;
          }
      }];

    }
#pragma mark UISearchBar
    // UISearchBar tintColor
    [TCColorTest addClass:[UISearchBar class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"tintColor"];
   }
     colorForMethodBlock:^UIColor *(UISearchBar* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self tintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UISearchBar* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTintColor:color];
              break;
          default:
              break;
      }
  }];
#pragma mark UISegmentedControl
    // UISegmentedControl tintColor
    [TCColorTest addClass:[UISegmentedControl class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"tintColor"];
   }
     colorForMethodBlock:^UIColor *(UISegmentedControl* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self tintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UISegmentedControl* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UISegmentedControl class]];

#pragma mark UISlider
    // UISlider minimumTrackTintColor, maximumTrackTintColor, thumbTintColor
    [TCColorTest addClass:[UISlider class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"minimumTrackTintColor",@"maximumTrackTintColor",@"thumbTintColor"];
   }
     colorForMethodBlock:^UIColor *(UISlider* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self minimumTrackTintColor];
             case 1:
                 return [_self maximumTrackTintColor];
             case 2:
                 return [_self thumbTintColor];
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UISlider* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setMinimumTrackTintColor:color];
              break;
          case 1:
              [_self setMaximumTrackTintColor:color];
              break;
          case 2:
              [_self setThumbTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UISlider class]];
#pragma mark UIStepper (iOS6)
    // UIStepper tintColor
    // property available in iOS 6
    if ([[UIStepper new] respondsToSelector:@selector(tintColor)]) {
        [TCColorTest addClass:[UIStepper class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"tintColor"];
       }
         colorForMethodBlock:^UIColor *(UIStepper* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self tintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UIStepper* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setTintColor:color];
                  break;
              default:
                  break;
          }
      }];

    }
#pragma mark UISwitch (iOS5+iOS6)
    // UISwitch onTintColor iOS5
    // onTintColor, tintColor thumbTintColor iOS6
    if ([[UISwitch new] respondsToSelector:@selector(tintColor)]) {
        [TCColorTest addClass:[UISwitch class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"onTintColor", @"tintColor",@"tumbTintColor"];
       }
         colorForMethodBlock:^UIColor *(UISwitch* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self onTintColor];
                     break;
                 case 1:
                     return [_self tintColor];
                     break;
                 case 2:
                     return [_self thumbTintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UISwitch* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setOnTintColor:color];
                  break;
              case 1:
                  [_self setTintColor:color];
                  break;
              case 2:
                  [_self setThumbTintColor:color];
                  break;
              default:
                  break;
          }
      }];
        
    } else {
        [TCColorTest addClass:[UISwitch class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"onTintColor"];
       }
         colorForMethodBlock:^UIColor *(UISwitch* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self onTintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UISwitch* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setOnTintColor:color];
                  break;
              default:
                  break;
          }
      }];

    }
#pragma mark UITabBar
    // UITabBar tintColor, selectedImageTintColor
    [TCColorTest addClass:[UITabBar class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"tintColor",@"selectedImageTintColor"];
   }
     colorForMethodBlock:^UIColor *(UITabBar* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self tintColor];
                 break;
             case 1:
                 return [_self selectedImageTintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UITabBar* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTintColor:color];
              break;
          case 1:
              [_self setSelectedImageTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UITabBar class]];
#pragma mark UITableView (iOS5+iOS6)
    //UITableView separatorColor (iOS5)
    // separatorColor, sectionIndexColor, sectionIndexTrackingBackgroundColor
    
    if([[UITableView new] respondsToSelector:@selector(sectionIndexColor)]) {
        [TCColorTest addClass:[UITableView class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"separatorColor",@"sectionIndexColor",@"sectionIndexTrackingBackgroundColor"];
       }
         colorForMethodBlock:^UIColor *(UITableView* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self separatorColor];
                     break;
                 case 1:
                     return [_self sectionIndexColor];
                     break;
                 case 2:
                     return [_self sectionIndexTrackingBackgroundColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UITableView* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setSeparatorColor:color];
                  break;
              case 1:
                  [_self setSectionIndexColor:color];
                  break;
              case 2:
                  [_self setSectionIndexTrackingBackgroundColor:color];
                  break;
              default:
                  break;
          }
      }];
    } else {
        [TCColorTest addClass:[UITableView class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"separatorColor"];
       }
         colorForMethodBlock:^UIColor *(UITableView* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self separatorColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UITableView* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setSeparatorColor:color];
                  break;
              default:
                  break;
          }
      }];
    }
    

#pragma mark UITableViewHeaderFooterView (iOS6)
    if (NSClassFromString(@"UITableViewHeaderFooterView")) {
        // UITableViewHeaderFooterView tintColor
        [TCColorTest addClass:[UITableViewHeaderFooterView class]
       availableMethodsBlock:^NSArray *(id _self) {
           return @[@"tintColor"];
       }
         colorForMethodBlock:^UIColor *(UITableViewHeaderFooterView* _self, NSUInteger index) {
             switch (index) {
                 case 0:
                     return [_self tintColor];
                     break;
                 default:
                     return nil;
                     break;
             }
         }
      setColorForMethodBlock:^(UITableViewHeaderFooterView* _self, UIColor *color, NSUInteger index) {
          switch (index) {
              case 0:
                  [_self setTintColor:color];
                  break;
              default:
                  break;
          }
      }];
    }
#pragma mark UITextField
    // UITextField textColor
    [TCColorTest addClass:[UITextField class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"textColor"];
   }
     colorForMethodBlock:^UIColor *(UITextField* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self textColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UITextField* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTextColor:color];
              break;
          default:
              break;
      }
  }];
#pragma mark UITextView
    // UITextView backgroundColor, textColor
    [TCColorTest addClass:[UITextView class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"backgroundColor",@"textColor"];
   }
     colorForMethodBlock:^UIColor *(UITextView* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self backgroundColor];
             case 1:
                 return [_self textColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UITextView* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setBackgroundColor:color];
          case 1:
              [_self setTextColor:color];
              break;
          default:
              break;
      }
  }];
#pragma mark UIToolbar
    // UIToolbar tintColor
    [TCColorTest addClass:[UIToolbar class]
   availableMethodsBlock:^NSArray *(id _self) {
       return @[@"tintColor"];
   }
     colorForMethodBlock:^UIColor *(UIToolbar* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self tintColor];
                 break;
             default:
                 return nil;
                 break;
         }
     }
  setColorForMethodBlock:^(UIToolbar* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
              [_self setTintColor:color];
              break;
          default:
              break;
      }
  }];
    [TCColorTest disableHitTestDescendenceForClass:[UIToolbar class]];
#pragma mark UIView
    // UIView backgroundColor
    [TCColorTest addClass:[UIView class]
   availableMethodsBlock:^NSArray *(id _self) {
        return @[@"backgroundColor"];
    }
     colorForMethodBlock:^UIColor *(UIView* _self, NSUInteger index) {
         switch (index) {
             case 0:
                 return [_self backgroundColor];
                 break;
             default:
                 return nil;
                 break;
         }
    }
  setColorForMethodBlock:^(UIView* _self, UIColor *color, NSUInteger index) {
      switch (index) {
          case 0:
            [_self setBackgroundColor:color];
              break;
          default:
            break;
      }
  }
     opacityBlock:^CGFloat(UIView* _self) {
         return _self.alpha;
     } setOpacityBlock:^(UIView* _self, CGFloat opacity) {
         _self.alpha = opacity;
     }];
    
#pragma mark - NOT CHANGED -
#pragma mark UIControl
#pragma mark UICollectionReusableView (iOS6)
#pragma mark UICollectionView (iOS6)
#pragma mark UICollectionViewCell (iOS6)
#pragma mark UIDatePicker
#pragma mark UIImageView
#pragma mark UIPickerView
    [TCColorTest disableHitTestDescendenceForClass:[UIPickerView class]];
#pragma mark UIPopoverBackgroundView
#pragma mark UIScrollView
#pragma mark UITableViewCell
#pragma mark UIWebView
    
#pragma mark - DISABLED -
#pragma mark UIActionSheet
    [TCColorTest disableForClass:[UIActionSheet class]];
#pragma mark UIAlertView
    [TCColorTest disableForClass:[UIAlertView class]];
#pragma mark UIWindow
    [TCColorTest disableForClass:[UIWindow class]];
    
#pragma mark - private disabled -
    [TCColorTest disableForClass:NSClassFromString(@"UILayoutContainerView")];
    [TCColorTest disableForClass:NSClassFromString(@"UISearchBarBackground")];
    [TCColorTest disableForClass:NSClassFromString(@"UITableViewCellContentView")];
    [TCColorTest disableForClass:NSClassFromString(@"UITextFieldBorderView")];
    [TCColorTest disableForClass:NSClassFromString(@"UIWebBrowserView")];
    [TCColorTest disableForClass:NSClassFromString(@"UIWebDocumentView")];

    

}

@end
