//
//  CallNamedMethod.m
//  example
//
//  Created by Brad Edelman on 12/28/20.
//  Copyright © 2020 Brad Edelman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

id CallNamedMethodFunc(NSObject *callOn, NSString *callMethod, NSArray <NSObject *>*callParameters)
{
    // objective-c... even though arguments are unnamed, each argument appnds a : to the method name
    for (int i=0; i<[callParameters count]; i++) {
        callMethod = [NSString stringWithFormat:@"%@:", callMethod];
    }

    // get the method
    Method method = class_getInstanceMethod(callOn.class, NSSelectorFromString(callMethod));
    struct objc_method_description* description = method_getDescription(method);
    NSMethodSignature* signature = [NSMethodSignature signatureWithObjCTypes:description->types];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];

    NSObject *parameters[callParameters.count];
    for (int p = 0; p < callParameters.count; ++p) {
        parameters[p] = [callParameters objectAtIndex:p];
        [invocation setArgument:&parameters[p] atIndex:p + 2]; // 0 is self 1 is SEL
    }
    [invocation setTarget:callOn];
    [invocation setSelector:description->name];
    [invocation invoke];
        
    // v means void and trying to get the return value will crash
    void* result = NULL;
    const char* look = [signature methodReturnType];
    if (strcmp(look, "v") != 0) {
        [invocation getReturnValue:&result];
    }
    return (__bridge id)result;
     
}

