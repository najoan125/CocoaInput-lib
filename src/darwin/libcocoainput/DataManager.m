//
//  DataManager.m
//  libcocoainput
//
//  Created by Axer on 2019/03/23.
//  Copyright © 2019年 Axer. All rights reserved.
//

#import "DataManager.h"
#import "cocoainput.h"
#import "Logger.h"

#define SPLIT_NSRANGE(x) (int)(x.location), (int)(x.length)

static DataManager* instance = nil;

@implementation DataManager

@synthesize isFocused;

+ (instancetype)sharedManager {
    if (!instance) {
        instance = [[DataManager alloc] init];
    }
    return instance;
}

- (id)init {
    CIDebug(@"Textfield table has been initialized.");
    self = [super init];
    self.isFocused=NO;
    return self;
}

- (void) modifyGLFWView {
    NSView *view;
    while(1) {
        view = [[NSApp keyWindow] contentView];
        if ([[view className]isEqualToString:@"GLFWContentView"] == YES) {
            break;
        }
    }

    [[DataManager sharedManager] setGlfwView:view];

    Class viewClass = [view class];
    Class dataClass = [[DataManager sharedManager] class];
    replaceInstanceMethod(viewClass, @selector(keyDown:), @selector(org_keyDown:), dataClass);
    replaceInstanceMethod(viewClass, @selector(interpretKeyEvents:), @selector(org_interpretKeyEvents:), dataClass);

    CIDebug([NSString stringWithFormat:@"SetView:\"%@\"", [view.class description]]);
    CILog(@"Complete to modify GLFWView");
}

static NSDictionary<NSString*, NSString*>* hangulToEnglishMap = nil;

+ (void)initializeHangulToEnglishMap {
    if (hangulToEnglishMap == nil) {
        hangulToEnglishMap = @{
            // 자음 (초성/종성)
            @"ㄱ": @"r", @"ㄲ": @"R", @"ㄴ": @"s", @"ㄷ": @"e", @"ㄸ": @"E",
            @"ㄹ": @"f", @"ㅁ": @"a", @"ㅂ": @"q", @"ㅃ": @"Q", @"ㅅ": @"t",
            @"ㅆ": @"T", @"ㅇ": @"d", @"ㅈ": @"w", @"ㅉ": @"W", @"ㅊ": @"c",
            @"ㅋ": @"z", @"ㅌ": @"x", @"ㅍ": @"v", @"ㅎ": @"g",

            // 모음 (중성)
            @"ㅏ": @"k", @"ㅐ": @"o", @"ㅑ": @"i", @"ㅒ": @"O", @"ㅓ": @"j",
            @"ㅔ": @"p", @"ㅕ": @"u", @"ㅖ": @"P", @"ㅗ": @"h", @"ㅛ": @"y",
            @"ㅜ": @"n", @"ㅠ": @"b", @"ㅡ": @"m", @"ㅣ": @"l",
        };
    }
}

- (void)keyDown:(NSEvent*)theEvent {//GLFWContentView改変用
    [DataManager initializeHangulToEnglishMap];

    if ([DataManager sharedManager].isFocused) {
        CIDebug(@"New keyEvent came and sent to textfield.");
        [self org_interpretKeyEvents:@[ theEvent ]];
    } else {
        NSString* baseChars = [theEvent charactersIgnoringModifiers];

        if (baseChars != nil && [baseChars length] > 0) {
            unichar firstChar = [baseChars characterAtIndex:0];
            if ((firstChar >= 0xAC00 && firstChar <= 0xD7A3) ||
                (firstChar >= 0x1100 && firstChar <= 0x11FF) ||
                (firstChar >= 0x3130 && firstChar <= 0x318F)) {
                baseChars = [hangulToEnglishMap objectForKey:baseChars]; // korean to english
            }

            NSString* finalChars = baseChars;

            // Shift/Capslock
            if (theEvent.modifierFlags & NSEventModifierFlagCapsLock) {
                if (!(theEvent.modifierFlags & NSEventModifierFlagShift)) {
                    finalChars = [baseChars uppercaseString];
                }
            } else if (theEvent.modifierFlags & NSEventModifierFlagShift) {
                finalChars = [baseChars uppercaseString];
            }

            CIDebug(@"Forcing keyEvent to ASCII and sending to original keyDown.");
            NSEvent* asciiEvent = [NSEvent keyEventWithType:theEvent.type
                                                   location:theEvent.locationInWindow
                                              modifierFlags:theEvent.modifierFlags
                                                  timestamp:theEvent.timestamp
                                               windowNumber:theEvent.windowNumber
                                                    context:nil // context is deprecated
                                                 characters:finalChars // 최종적으로 변환된 문자를 사용합
                                charactersIgnoringModifiers:finalChars // 여기도 일관성을 위해 동일하게
                                                  isARepeat:theEvent.isARepeat
                                                    keyCode:theEvent.keyCode];
            [self org_interpretKeyEvents:@[ asciiEvent ]];
        }
    }

    CIDebug(@"New keyEvent came and sent to original keyDown.");
    [self org_keyDown:theEvent];
}

- (void)interpretKeyEvents: (NSArray*)eventArray { // GLFWContentView改変用
}


// 警告消しのためのダミーメソッド
- (void)org_keyDown:(NSEvent*)theEvent{}
- (void)org_interpretKeyEvents:(NSArray*)eventArray{}


@end
