//
//  JSQAudioMediaItem.m
//

#import "JSQAudioMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesSoundButton.h"

#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"
#import "UIView+JSQMessages.h"

@interface JSQAudioMediaItem ()

@property (strong, nonatomic) UIView *          cachedMediaView;

@property (strong, nonatomic) UILabel *         progressLabel;

@property (strong, nonatomic) AVAudioPlayer *   audioPlayer;

@property (strong, nonatomic) JSQMessagesSoundButton *soundButton;

@end

@implementation JSQAudioMediaItem

#pragma mark - Initialization

- (instancetype)initWithData:(NSData *)audioData audioViewConfiguration:(JSQAudioMediaViewConfiguration *)config
{
    self = [super init];
    if (self) {
        _cachedMediaView = nil;
        _audioData = [audioData copy];
        _audioViewConfiguration = config;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)audioData
{
    return [self initWithData:audioData audioViewConfiguration:[[JSQAudioMediaViewConfiguration alloc] init]];
}

- (instancetype)initWithAudioViewConfiguration:(JSQAudioMediaViewConfiguration *)config
{
    return [self initWithData:nil audioViewConfiguration:config];
}

- (instancetype)init
{
    return [self initWithData:nil audioViewConfiguration:[[JSQAudioMediaViewConfiguration alloc] init]];
}

- (void)dealloc
{
    _audioData = nil;
    [self clearCachedMediaViews];
}

- (void)clearCachedMediaViews
{
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    _progressLabel = nil;
    
    _cachedMediaView = nil;
    [super clearCachedMediaViews];
}

#pragma mark - Setters and Getters

- (void)setAudioData:(NSData *)audioData
{
    _audioData = [audioData copy];
    [self clearCachedMediaViews];
}

- (void)setAudioDataWithUrl:(NSURL *)audioURL
{
    _audioData = [NSData dataWithContentsOfURL:audioURL];
    [self clearCachedMediaViews];
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedMediaView = nil;
}

- (AVAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        if (_audioData) {
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:_audioData error:nil];
        }
        else {
            _audioPlayer = [AVAudioPlayer new];
        }
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

#pragma mark - Private

- (void)onPlayButton:(id)sender {
    
    NSString * category = [AVAudioSession sharedInstance].category;
    AVAudioSessionCategoryOptions options = [AVAudioSession sharedInstance].categoryOptions;
    
    if (category != _audioViewConfiguration.audioCategory ||
        options != _audioViewConfiguration.audioCategoryOptions) {
        NSError * error;
        [[AVAudioSession sharedInstance] setCategory:_audioViewConfiguration.audioCategory
                                         withOptions:_audioViewConfiguration.audioCategoryOptions
                                               error:&error];
        if (self.delegate) {
            [self.delegate audioMediaItem:self didChangeAudioCategory:category options:options error:error];
        }
    }
    
    if (_audioPlayer.playing) {
        [self.soundButton stopAnimating];
        [_audioPlayer stop];
    } else {
        [self.soundButton startAnimating];
        [_audioPlayer play];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    
    // set progress to full, then fade back to the default state
    [self.soundButton stopAnimating];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioMediaItemDidFinishPlaying:sucessfully:)]) {
        [self.delegate audioMediaItemDidFinishPlaying:self sucessfully:flag];
    }
}

#pragma mark - JSQMessageMediaData protocol

- (CGSize)mediaViewDisplaySize
{
    CGFloat maxWidth = 210.0f;
    CGFloat minWidth = 46.0f + _audioViewConfiguration.soundWaveImage.size.width; // 26.0f is the text lenght of 120"; 20 is a standar value between UI elements
    CGFloat finalWidth;
    if (self.audioPlayer.duration > 120) {
        finalWidth = maxWidth;
    }
    else {
        finalWidth = self.audioPlayer.duration * 210.0f / 120.0f;
        finalWidth = MAX(minWidth, finalWidth);
    }
    
    return CGSizeMake(finalWidth, _audioViewConfiguration.soundWaveImage.size.height + _audioViewConfiguration.controlInsets.top + _audioViewConfiguration.controlInsets.bottom);
}

- (UIView *)mediaView
{
    if (self.audioData && self.cachedMediaView == nil) {
        
        // create container view for the various controls
        CGSize size = [self mediaViewDisplaySize];
        UIView * playView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];

        playView.backgroundColor = _audioViewConfiguration.backgroundColor;
        playView.contentMode = UIViewContentModeCenter;
        playView.clipsToBounds = YES;

        // create a label to show the duration
        NSString *durationString = [NSString stringWithFormat:@"%.f\"", _audioPlayer.duration];
        CGFloat maximumTextWidth = size.width - _audioViewConfiguration.soundWaveImage.size.width;
        
        CGRect stringRect = [durationString boundingRectWithSize:CGSizeMake(maximumTextWidth, CGFLOAT_MAX)
                                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                          attributes:@{ NSFontAttributeName : _audioViewConfiguration.labelFont }
                                                             context:nil];
        
        CGSize stringSize = CGRectIntegral(stringRect).size;
        
        CGRect labelFrame = CGRectMake(8, (size.height - stringSize.height) * 0.5, stringSize.width, stringSize.height);
        
        if (!self.appliesMediaViewMaskAsOutgoing) {
            labelFrame.origin.x = size.width - stringSize.width - 8;
        }
        
        _progressLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = _audioViewConfiguration.labelFont;
        _progressLabel.text = [NSString stringWithFormat:@"%.f\"", _audioPlayer.duration];
        [playView addSubview:_progressLabel];
        
        // create the play button
        CGRect buttonFrame = CGRectMake(4, _audioViewConfiguration.controlInsets.top, size.width - CGRectGetWidth(labelFrame) - 12, _audioViewConfiguration.soundWaveImage.size.height);
        if (self.appliesMediaViewMaskAsOutgoing) {
            buttonFrame.origin.x = CGRectGetMaxX(labelFrame) + 4;
        }
        _soundButton = [[JSQMessagesSoundButton alloc] initWithOutgoing:self.appliesMediaViewMaskAsOutgoing];
        _soundButton.frame = buttonFrame;
        [_soundButton addTarget:self action:@selector(onPlayButton:) forControlEvents:UIControlEventValueChanged];
        [playView addSubview:_soundButton];
        
        SEL selector = self.appliesMediaViewMaskAsOutgoing ? @selector(mediaViewOutgoingBubbleMaskImage) : @selector(mediaViewIncomingBubbleMaskImage);
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIImage *maskImage = [self performSelector:selector];
#pragma clang diagnostic pop
            if (maskImage) {
                
                UIImageView *container = [[UIImageView alloc] initWithFrame:_soundButton.frame];
                container.image = maskImage;
                
                _soundButton.frame = CGRectInset(_soundButton.frame, 8.0f, 4.0f);
                
                [playView insertSubview:container belowSubview:_soundButton];
            }
        }
        else {
            [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:_soundButton isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        }

        self.cachedMediaView = playView;
    }
    
    return self.cachedMediaView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    JSQAudioMediaItem *audioItem = (JSQAudioMediaItem *)object;
    if (self.audioData && ![self.audioData isEqualToData:audioItem.audioData]) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash
{
    return super.hash ^ self.audioData.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: audioData=%ld bytes, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], (unsigned long)[self.audioData length],
            @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSData * data = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(audioData))];
    return [self initWithData:data];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.audioData forKey:NSStringFromSelector(@selector(audioData))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQAudioMediaItem *copy;
    copy = [[[self class] allocWithZone:zone] initWithData:self.audioData
                                        audioViewConfiguration:_audioViewConfiguration];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    copy.mediaViewOutgoingBubbleMaskImage = self.mediaViewOutgoingBubbleMaskImage.copy;
    copy.mediaViewIncomingBubbleMaskImage = self.mediaViewIncomingBubbleMaskImage.copy;
    
    return copy;
}

@end

@implementation JSQAudioMediaViewConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controlPadding = 6;
        
        _controlInsets = UIEdgeInsetsZero;
        
        _labelFont = [UIFont systemFontOfSize:12];
        
        _showFractionalSeconds = NO;

        _backgroundColor = [UIColor whiteColor];

        _tintColor = [UIButton buttonWithType:UIButtonTypeSystem].tintColor;
        
        _soundWaveImage = [UIImage jsq_imageFromMessagesAssetBundleWithName:@"sound_wave_3"];
                
        _audioCategory = @"AVAudioSessionCategoryPlayback";
        
        _audioCategoryOptions = AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth;
    }
    
    return self;
}

@end