//
//  JSQMessagesToolBarMediaContentView.m
//  JSQMessages
//
//  Created by DongMeiliang on 3/28/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessagesToolbarMediaContentView.h"

@interface JSQMessagesToolbarMediaContentView ()

@property (nonatomic) JSQMessagesAudioInputButton *audioInputButton;
@property (nonatomic, copy) NSArray *audioInputButtonConstraints;

@property (nonatomic, copy) NSString *userInputedText;

@end

@implementation JSQMessagesToolbarMediaContentView

#pragma mark - Public Method

- (void)switchMediaContentView
{
    NSLog(@"%s", __func__);
    if (self.audioInputButton.superview) {
        // Switch to text input method
        // Restoring user inputed text
        self.textView.text = self.userInputedText;
        self.rightBarButtonItem.enabled = self.textView.hasText;
        
        self.userInputedText = nil;
        
        [NSLayoutConstraint deactivateConstraints:self.audioInputButtonConstraints];
        
        [self.audioInputButton removeFromSuperview];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
    }
    else {
        // Switch to audio input method
        // Saving user inputed text
        self.userInputedText = self.textView.text;
        
        self.textView.text = nil;
        [self.textView.undoManager removeAllActions];
        self.rightBarButtonItem.enabled = NO;
        
        [self addSubview:self.audioInputButton];
        if (!self.audioInputButtonConstraints) {
            // Left
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.audioInputButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftBarButtonContainerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:8];
            // Right
            NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.audioInputButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rightBarButtonContainerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-8];

            // Top
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.audioInputButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:7];
            
            self.audioInputButtonConstraints = @[leftConstraint, rightConstraint, topConstraint];
        }
        
        [self addConstraints:self.audioInputButtonConstraints];
        
        [self.textView resignFirstResponder];
    }
    
    [self layoutIfNeeded];
}

#pragma mark - Getter

- (JSQMessagesAudioInputButton *)audioInputButton
{
    if (!_audioInputButton) {
        _audioInputButton = [JSQMessagesAudioInputButton new];
        [_audioInputButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _audioInputButton;
}

@end
