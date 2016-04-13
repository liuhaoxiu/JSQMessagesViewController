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

#import "JSQMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"


@interface JSQMediaItem ()

@property (strong, nonatomic) UIView *cachedPlaceholderView;

@end


@implementation JSQMediaItem

@synthesize mediaViewOutgoingBubbleMaskImage = _mediaViewOutgoingBubbleMaskImage;
@synthesize mediaViewIncomingBubbleMaskImage = _mediaViewIncomingBubbleMaskImage;

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithMaskAsOutgoing:YES];
}

- (instancetype)initWithMaskAsOutgoing:(BOOL)maskAsOutgoing
{
    self = [super init];
    if (self) {
        _appliesMediaViewMaskAsOutgoing = maskAsOutgoing;
        _cachedPlaceholderView = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarningNotification:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    _appliesMediaViewMaskAsOutgoing = appliesMediaViewMaskAsOutgoing;
    _cachedPlaceholderView = nil;
}

- (void)clearCachedMediaViews
{
    _cachedPlaceholderView = nil;
}

#pragma mark - Notifications

- (void)didReceiveMemoryWarningNotification:(NSNotification *)notification
{
    [self clearCachedMediaViews];
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
    return nil;
}

- (CGSize)mediaViewDisplaySize
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return CGSizeMake(315.0f, 225.0f);
    }
    
    return CGSizeMake(210.0f, 150.0f);
}

- (UIView *)mediaPlaceholderView
{
    if (self.cachedPlaceholderView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIView *view = [JSQMessagesMediaPlaceholderView viewWithActivityIndicator];
        view.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
        self.cachedPlaceholderView = view;
        
        SEL selector = self.appliesMediaViewMaskAsOutgoing ? @selector(mediaViewOutgoingBubbleMaskImage) : @selector(mediaViewIncomingBubbleMaskImage);
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIImage *maskImage = [self performSelector:selector];
#pragma clang diagnostic pop
            if (maskImage) {
                UIImageView *container = [[UIImageView alloc] initWithFrame:view.frame];
                container.image = maskImage;
                [container addSubview:view];
                
                view.frame = CGRectInset(view.frame, 8.0f, 4.0f);
                
                self.cachedPlaceholderView = container;
            }
        }
        else {
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:view isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        }
    }
    
    return self.cachedPlaceholderView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    JSQMediaItem *item = (JSQMediaItem *)object;
    
    return self.appliesMediaViewMaskAsOutgoing == item.appliesMediaViewMaskAsOutgoing;
}

- (NSUInteger)hash
{
    return [NSNumber numberWithBool:self.appliesMediaViewMaskAsOutgoing].hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: appliesMediaViewMaskAsOutgoing=%@>",
            [self class], @(self.appliesMediaViewMaskAsOutgoing)];
}

- (id)debugQuickLookObject
{
    return [self mediaView] ?: [self mediaPlaceholderView];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _appliesMediaViewMaskAsOutgoing = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(appliesMediaViewMaskAsOutgoing))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.appliesMediaViewMaskAsOutgoing forKey:NSStringFromSelector(@selector(appliesMediaViewMaskAsOutgoing))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithMaskAsOutgoing:self.appliesMediaViewMaskAsOutgoing];
}

@end
