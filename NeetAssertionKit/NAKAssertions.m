//
//  NAKAssertions.m
//  NeetAssertionKit
//
//  Created by mtmta on 2013/12/10.
//  Copyright (c) 2013 covelline, LLC. All rights reserved.
//

#import "NAKAssertions.h"

#if DEBUG

/// 警告を無視して dispatch_get_current_queue() を実行する.
dispatch_queue_t _NAK_dispatch_get_current_queue() {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    dispatch_queue_t queue = dispatch_get_current_queue();
    
    #pragma clang diagnostic pop
    
    return queue;
}

/// キャストできない時にエラー
id _NAKAssertCast(id obj, Class expectedClass, id self, SEL _cmd, const char *file, int line, const char *function) {
    
    if (obj == nil) {
        return nil;
    }
    
    if ([obj isKindOfClass:expectedClass]) {
        return obj;
    }
    
    NAKFail(@"%@ is must be subclass of %@. %s:%d %s",
           obj, NSStringFromClass(expectedClass), file, line, function);
    
    return nil;
}

#endif
