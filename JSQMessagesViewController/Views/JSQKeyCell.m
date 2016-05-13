//
//  JSQKeyCell.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/29/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQKeyCell.h"

@interface JSQKeyCell ()

@property (nonatomic) UIView *containerView;

@end

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
        
        _containerView = [UIView new];
        [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _containerView.layer.borderColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0].CGColor;
        _containerView.layer.borderWidth = 1.0;
        _containerView.layer.cornerRadius = 5;
        _containerView.clipsToBounds = YES;
        [self addSubview:_containerView];
        
        [self configureConstraintsForContainerView];
        [self configureConstraintsForKeyImageView];
        [self configureConstraintsForKeyNameLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)configureConstraintsForContainerView
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_keyNameLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

- (void)configureConstraintsForKeyImageView
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:18]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-18]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:18]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_keyImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-18]];
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
