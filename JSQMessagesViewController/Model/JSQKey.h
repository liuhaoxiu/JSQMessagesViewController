//
//  JSQKey.h
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JSQKey <NSObject>

@required

@property (nonatomic) UIImage *keyImage;
@property (nonatomic, copy) NSString *keyName;

@end

@interface JSQKey : NSObject<JSQKey>

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;

@end
