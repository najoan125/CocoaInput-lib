//
//  DataManager.h
//  libcocoainput
//
//  Created by Axer on 2019/03/23.
//  Copyright © 2019年 Axer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface DataManager : NSObject

@property BOOL isFocused;

@property NSView* glfwView;
+ (instancetype)sharedManager;
- (void) modifyGLFWView;

//機能上書き
- (void)keyDown:(NSEvent*)theEvent;
- (void)interpretKeyEvents:(NSArray*)eventArray;

//形式上
- (void)org_keyDown:(NSEvent*)theEvent;
- (void)org_interpretKeyEvents:(NSArray*)eventArray;
@end
