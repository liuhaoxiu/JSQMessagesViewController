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

#import "JSQPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


@interface JSQPhotoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedImageView;
@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) NSLayoutConstraint *progressViewHeightConstraint;
@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation JSQPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _image = [image copy];
        _cachedImageView = nil;
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Override

- (CGSize)mediaViewDisplaySize
{
    if (self.image) {
        // If size less than (40, 40), zoom in to (40, 40); If size great than (210, 150), zoom out to (210, 150)
        CGSize size = self.image.size;
        size.width = MAX(size.width, 40.0);
        size.width = MIN(size.width, 210.0);
        
        size.height = MAX(size.height, 40.0);
        size.height = MIN(size.height, 150.0);
        
        return size;
    }
    
    return [super mediaViewDisplaySize];
}

#pragma mark - Public

- (void)updateSendingProgress:(CGFloat)progress
{
    if (progress < 0) {
        return;
    }
    
    progress = MIN(progress, 1); // Range [0, 1]
    
    if (self.progressViewHeightConstraint) {
        self.progressViewHeightConstraint.constant = CGRectGetHeight(self.imageView.frame) * (1 - progress);
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.imageView layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (fabs(progress - 1) < 0.01) {
                [_progressView removeFromSuperview];
                [_progressLabel removeFromSuperview];
            }
        }];
    }
    
    // Create progress view if need
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor blackColor];
        _progressView.alpha = 0.3;
        [_progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageView addSubview:_progressView];
        
        [self.imageView jsq_pinSubview:_progressView toEdge:NSLayoutAttributeLeft];
        [self.imageView jsq_pinSubview:_progressView toEdge:NSLayoutAttributeRight];
        [self.imageView jsq_pinSubview:_progressView toEdge:NSLayoutAttributeTop];
        
        self.progressViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetHeight(self.imageView.frame) * (1 - progress)];
        [self.imageView addConstraint:self.progressViewHeightConstraint];
        
        [self.imageView layoutIfNeeded];
    }
    
    // Create progress label
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.font = [UIFont systemFontOfSize:24.0];
        _progressLabel.textColor = [UIColor whiteColor];
        
        [_progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageView addSubview:_progressLabel];
        [self.imageView jsq_centerSubview:_progressLabel];
        
        [self.imageView layoutIfNeeded];
    }
    
    _progressLabel.text = [NSString stringWithFormat:@"%.f%%", progress * 100];
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - Getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        CGSize size = [self mediaViewDisplaySize];
        _imageView = [[UIImageView alloc] initWithImage:self.image];
        _imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.image == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        
        self.cachedImageView = self.imageView;

        SEL selector = self.appliesMediaViewMaskAsOutgoing ? @selector(mediaViewOutgoingBubbleMaskImage) : @selector(mediaViewIncomingBubbleMaskImage);
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIImage *maskImage = [self performSelector:selector];
#pragma clang diagnostic pop
            if (maskImage) {
                UIImageView *mediaViewContainer = [[UIImageView alloc] initWithFrame:self.imageView.frame];
                mediaViewContainer.image = maskImage;
                
                self.imageView.frame = CGRectInset(self.imageView.frame, 10.0f, 4.0f);
                
                [mediaViewContainer addSubview:self.imageView];
                
                self.cachedImageView = mediaViewContainer;
            }
        }
        else {
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:self.imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        }        
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQPhotoMediaItem *copy = [[JSQPhotoMediaItem allocWithZone:zone] initWithImage:self.image];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    copy.mediaViewOutgoingBubbleMaskImage = self.mediaViewOutgoingBubbleMaskImage.copy;
    copy.mediaViewIncomingBubbleMaskImage = self.mediaViewIncomingBubbleMaskImage.copy;
    return copy;
}

@end
