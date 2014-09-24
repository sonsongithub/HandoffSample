//
//  StreamController.h
//  HandoffSample
//
//  Created by sonson on 2014/09/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamController : NSObject
+ (instancetype)controllerWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;
- (void)writeData:(NSData*)data;
- (void)read;
@end
