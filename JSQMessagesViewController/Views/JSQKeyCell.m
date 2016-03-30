//
//  JSQKeyCell.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQKeyCell.h"

@implementation JSQKeyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _keyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_keyImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_keyImageView];
        
        _keyNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_keyNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _keyNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_keyNameLabel];
        
        [self configureConstraintsForKeyImageView];
        [self configureConstraintsForKeyNameLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)configureConstraintsForKeyImageView
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_keyNameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForKeyNameLabel
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

#pragma mark - Override

- (void)prepareForReuse
{
    self.keyImageView.image = nil;
    self.keyNameLabel.text = nil;
}

@end
