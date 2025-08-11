//
//  cocoainput.m
//  libcocoainput
//
//  Created by Axer on 2019/03/23.
//  Copyright © 2019年 Axer. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>
#import "cocoainput.h"
#import "DataManager.h"

void replaceInstanceMethod(Class cls, SEL sel, SEL renamedSel, Class dataCls) {
    Method addMethod = class_getInstanceMethod(cls, sel);
    IMP addImp = method_getImplementation(addMethod);
    const char* addEncoding = method_getTypeEncoding(addMethod);
    BOOL addResult = class_addMethod(cls, renamedSel, addImp, addEncoding);
    if (!addResult) {
        CIDebug([NSString stringWithFormat:@"AddMethod Failed:\"%@\"", NSStringFromSelector(renamedSel)]);
    }

    Method replaceMethod = class_getInstanceMethod(dataCls, sel);
    IMP replaceImp = method_getImplementation(replaceMethod);
    const char* replaceEncoding = method_getTypeEncoding(replaceMethod);
    class_replaceMethod(cls, sel, replaceImp, replaceEncoding);
}

void initialize(LogFunction log,LogFunction error,LogFunction debug){
    initLogPointer(log, error, debug);
    CILog([NSString stringWithFormat:@"Libcocoainput was built on %s %s.", __DATE__, __TIME__]);
    CILog(@"CocoaInput is being initialized.Now running thread for modify GLFWview .");
    NSThread *thread=[[NSThread alloc]initWithTarget:[DataManager sharedManager] selector:@selector(modifyGLFWView) object:nil];
    [thread start];
}

void setFocused(int val) {
    if (val == 1) {
        [DataManager sharedManager].isFocused = YES;
    } else {
        [DataManager sharedManager].isFocused = NO;
    }
}
