//
//  cocoainput.h
//  libcocoainput
//
//  Created by Axer on 2019/03/23.
//  Copyright © 2019年 Axer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Logger.h"


void initialize(LogFunction log,LogFunction error,LogFunction debug);
void replaceInstanceMethod(Class cls, SEL sel, SEL renamedSel, Class dataCls);

void setFocused(int val);
