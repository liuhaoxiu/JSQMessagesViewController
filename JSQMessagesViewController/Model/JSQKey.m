//
//  JSQKey.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQKey.h"

@implementation JSQKey

@synthesize keyImage = _keyImage;
@synthesize keyName = _keyName;

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name
{
    if (self = [super init]) {
        _keyImage = image;
        _keyName = [name copy];
    }
    return self;
}


@end
