//
//  WTClient.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-23.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "NSUserDefaults+Addition.h"

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

- (void)setCompletionBlock:(void (^)(WTClient* client))completionBlock;
- (WTCompletionBlock)completionBlock;
// return an autoreleased object, while gets released after one of following calls complete
+ (id)client;

#pragma mark -
#pragma mark user API

- (void)login:(NSString *)num password:(NSString *)password;
- (void)logoff;
- (void)activeUserWithNo:(NSString *) studentNumber
                password:(NSString *) password
                    name:(NSString *) name;

#pragma mark -
#pragma mark course API

- (void)getCourses;

#pragma mark -
#pragma mark calender API

- (void)getCalender;

@end