//
//  JSQMessagesAudioInputButton.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/28/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "NSBundle+JSQMessages.h"

#import "JSQMessagesAudioInputButton.h"

@interface JSQMessagesAudioInputButton ()

@property (nonatomic) UILabel *placeholderLabel;

@end

@implementation JSQMessagesAudioInputButton

- (instancetype)init
{
    if (self = [super init]) {
        
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.text = [NSBundle jsq_localizedStringForKey:@"hold_to_talk"];
        
        [self addSubview:_placeholderLabel];
        
        [self configureCosntraintsForPlaceholderLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)configureCosntraintsForPlaceholderLabel
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

#pragma mark - Touch-Event Handling 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notify our target (if we have one) of the change.
    [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notify our target (if we have one) of the change.
    [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Notify our target (if we have one) of the change.
    [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
}

#pragma mark - Measuring in Auto Layout

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 30.0);
}

#pragma mark - Private Method

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent*)event
{
    NSSet *allTargets = [self allTargets];
    
    for (id target in allTargets) {
        
        NSArray *actionsForTarget = [self actionsForTarget:target forControlEvent:controlEvents];
        
        // Actions are returned as NSString objects, where each string is the
        // selector for the action.
        for (NSString *action in actionsForTarget) {
            SEL selector = NSSelectorFromString(action);
            [self sendAction:selector to:target forEvent:event];
        }
    }
}

#pragma mark - Getter and Setter

- (UIColor *)titleColor
{
    return self.placeholderLabel.textColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.placeholderLabel.textColor = titleColor;
    [self.placeholderLabel setNeedsDisplay];
}

@end
