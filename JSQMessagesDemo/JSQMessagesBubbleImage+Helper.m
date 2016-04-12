//
//  JSQMessagesBubbleImage+Helper.m
//  JSQMessages
//
//  Created by DongMeiliang on 4/11/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessagesBubbleImage+Helper.h"

#import "JSQMessagesBubbleImageFactory.h"

@implementation JSQMessagesBubbleImage (Helper)

+ (JSQMessagesBubbleImage *)jsq_outgoingBubbleImage
{
    UIImage *bubbleImage = [UIImage imageNamed:@"Bubble"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(bubbleImage.size.height - 8, 6, 8, 20);
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:bubbleImage capInsets:capInsets];
    
    return [bubbleFactory outgoingMessagesBubbleImageWithColor:nil];
}

+ (JSQMessagesBubbleImage *)jsq_incomingBubbleImage
{
    UIImage *incomingBubbleImage = [UIImage imageNamed:@"IncomingBubble"];
    
    UIEdgeInsets incomingCapInsets = UIEdgeInsetsMake(incomingBubbleImage.size.height - 8, 20, 6, 8);
    
    JSQMessagesBubbleImageFactory *incomingBubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:incomingBubbleImage capInsets:incomingCapInsets];
    
    return [incomingBubbleFactory outgoingMessagesBubbleImageWithColor:nil];
}

@end
