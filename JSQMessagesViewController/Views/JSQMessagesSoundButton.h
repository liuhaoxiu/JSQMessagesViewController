//
//  JSQMessagesSoundButton.h
//  JSQMessages
//
//  Created by DongMeiliang on 4/7/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSQMessagesSoundButton : UIControl

- (instancetype)initWithSoundImages:(NSArray *)images outgoing:(BOOL)outgoing NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithOutgoing:(BOOL)outgoing;

@property (nonatomic) NSArray *soundImages;

@property (nonatomic) BOOL outgoing;

- (void)startAnimating;

- (void)stopAnimating;

- (BOOL)isAnimating;

@end
