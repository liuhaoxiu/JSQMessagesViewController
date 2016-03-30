//
//  JSQMessageMediaInputToolbar.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/28/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessagesMediaInputToolbar.h"
#import "JSQMessagesToolbarMediaContentView.h"

@implementation JSQMessagesMediaInputToolbar

- (JSQMessagesToolbarContentView *)loadToolbarContentView
{    
    NSArray *nibViews = [[NSBundle bundleForClass:[JSQMessagesToolbarMediaContentView class]] loadNibNamed:NSStringFromClass([JSQMessagesToolbarMediaContentView class])
                                                                                          owner:nil
                                                                                        options:nil];
    return nibViews.firstObject;
}

@end
