//
//  WTClient.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-23.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

typedef enum {
    GetActivitySortTypeBeginAsc,
    GetActivitySortTypeBeginDesc,
    GetActivitySortTypeLikeDesc,
} GetActivitySortType;

@class WTClient;

typedef void (^WTCompletionBlock)(WTClient *client);

@interface WTClient : NSObject <ASIHTTPRequestDelegate> {
    WTCompletionBlock _completionBlock;
}

@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, copy) NSString* errorDesc;
// Status code generated by server side application
@property (nonatomic, assign) int responseStatusCode;
// NSDictionary or NSArray
@property (nonatomic, retain) NSDictionary *responseData;

+(void) test3;

- (void)setCompletionBlock:(void (^)(WTClient* client))completionBlock;
- (WTCompletionBlock)completionBlock;
// return an autoreleased object, while gets released after one of following calls complete
+ (id)client;
- (void)login:(NSString *)num password:(NSString *)password;

@end
