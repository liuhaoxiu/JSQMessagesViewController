//
//  JSQMessagesToolBarMediaContentView.h
//  JSQMessages
//
//  Created by DongMeiliang on 3/28/16.
//  Copyright © 2016 Hexed Bits. All rights reserved.
//

#import "JSQMessagesToolbarContentView.h"
#import "JSQMessagesAudioInputButton.h"

@interface JSQMessagesToolbarMediaContentView : JSQMessagesToolbarContentView

@property (nonatomic, readonly) JSQMessagesAudioInputButton *audioInputButton;

- (void)switchMediaContentView;

@end
