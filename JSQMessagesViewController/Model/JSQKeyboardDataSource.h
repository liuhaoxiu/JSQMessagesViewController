//
//  JSQKeyboardDataSource.h
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JSQKey;

@protocol JSQKeyboardDataSource <NSObject>

@required

- (NSInteger)numberOfKeysInKeyboard:(UIView *)keyboard;

- (id<JSQKey>)keyboard:(UIView *)keyboard keyAtIndexPath:(NSIndexPath *)indexPath;

@end
