//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "UIView+JSQMessages.h"

@implementation UIView (JSQMessages)

- (void)jsq_pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:subview
                                                     attribute:attribute
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (void)jsq_pinAllEdgesOfSubview:(UIView *)subview
{
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeBottom];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeTop];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeLeading];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}

- (void)jsq_maskWithImage:(UIImage *)image
{
    NSParameterAssert(image != nil);
    CGRect baseFrameForMask = self.frame;
    baseFrameForMask.origin = CGPointZero;
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(baseFrameForMask, 2.0f, 2.0f);
    
    self.layer.mask = imageViewMask.layer;
}

@end
