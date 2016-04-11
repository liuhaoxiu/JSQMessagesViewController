//
//  JSQMessagesSoundButton.m
//  JSQMessages
//
//  Created by DongMeiliang on 4/7/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"

#import "JSQMessagesSoundButton.h"

@interface JSQMessagesSoundButton ()

@property (nonatomic) UIImageView *soundImageView;

@end

@implementation JSQMessagesSoundButton

#pragma mark - Initialization

- (instancetype)initWithSoundImages:(NSArray *)images outgoing:(BOOL)outgoing
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
        
        _outgoing = outgoing;
        
        UIImage *outgoingImage = [UIImage jsq_imageFromMessagesAssetBundleWithName:@"sound_wave_3"];
        
        _soundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_soundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

        if (outgoing) {
            _soundImageView.image = outgoingImage;
        }
        else {
            // Note: Mask image with color first, otherwise it doesn't work as desire. Of course, we can improve jsq_messageSoundWaveMediumturquoiseColor when we have time.
            UIImage *incomingImage = [outgoingImage jsq_imageMaskedWithColor:[UIColor jsq_messageSoundWaveMediumturquoiseColor]];

            incomingImage = [UIImage imageWithCGImage:incomingImage.CGImage
                                                         scale:incomingImage.scale
                                                   orientation:UIImageOrientationUpMirrored];
            
            _soundImageView.image = incomingImage;
        }
    
        
        if (images) {
            _soundImageView.animationImages = images;
        }
        else {
            NSArray *defaultImages = @[[UIImage jsq_imageFromMessagesAssetBundleWithName:@"sound_wave_1"], [UIImage jsq_imageFromMessagesAssetBundleWithName:@"sound_wave_2"], outgoingImage];
            
            if (outgoing) {
                _soundImageView.animationImages = defaultImages;
            }
            else {
                
                NSMutableArray *incomingImages = [NSMutableArray arrayWithCapacity:defaultImages.count];
                
                [defaultImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIImage *upMirroredImage = [image jsq_imageMaskedWithColor:[UIColor jsq_messageSoundWaveMediumturquoiseColor]];
                    
                    upMirroredImage = [UIImage imageWithCGImage:upMirroredImage.CGImage
                                                                   scale:upMirroredImage.scale
                                                             orientation:UIImageOrientationUpMirrored];
                    
                    [incomingImages addObject:upMirroredImage];
                }];
                
                _soundImageView.animationImages = incomingImages;
            }
        }
        
        _soundImageView.animationDuration = 4.0 / _soundImageView.animationImages.count;
        
        [self addSubview:_soundImageView];
        
        [self configureConstraintsForSoundImageView];
    }
    return self;
}

- (instancetype)initWithOutgoing:(BOOL)outgoing
{
    return [self initWithSoundImages:nil outgoing:outgoing];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithSoundImages:nil outgoing:YES];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Layout

- (void)configureConstraintsForSoundImageView
{
    if (_outgoing) {
        // Right align sound images
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_soundImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-8.0]];
    }
    else {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_soundImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:8.0]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_soundImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-8.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_soundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:4.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_soundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-4]];
}

#pragma mark - Touch-Event handle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ }


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{ }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[touches anyObject] tapCount] == 1) {
        
        // Notify our target (if we have one) of the change.
        [self sendActionsForControlEvents:UIControlEventValueChanged withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

#pragma mark - Public

- (void)startAnimating
{
    [self.soundImageView startAnimating];
}

- (void)stopAnimating
{
    [self.soundImageView stopAnimating];
}

- (BOOL)isAnimating
{
    return self.soundImageView.isAnimating;
}

#pragma mark - Private

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

- (NSArray *)soundImages
{
    return self.soundImageView.animationImages;
}

- (void)setSoundImages:(NSArray *)soundImages
{
    self.soundImageView.animationImages = soundImages;
}

@end
