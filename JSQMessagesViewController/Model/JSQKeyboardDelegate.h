//
//  JSQKeyboardDelegate.h
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSQKeyboardDelegate <NSObject>

@optional

- (CGSize)keyboard:(UIView *)keyboard sizeForKeyAtIndexPath:(NSIndexPath *)indexPath;

- (void)keyboard:(UIView *)keyboard didTapKeyAtIndexPath:(NSIndexPath *)indexPath;

@end
