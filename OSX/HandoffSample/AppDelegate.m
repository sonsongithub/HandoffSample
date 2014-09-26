//
//  AppDelegate.m
//  HandoffSample
//
//  Created by sonson on 2014/09/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
	NSOutputStream *_outputStream;
	NSInputStream *_inputStream;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (BOOL)application:(NSApplication *)application willContinueUserActivityWithType:(NSString *)activityType {
	NSLog(@"application:willContinueUserActivityWithType:");
	if ([activityType isEqualToString:@"com.sonson.OSX.HandoffSample"])
		return YES;
	return NO;
}

- (void)application:(NSApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
	NSLog(@"application:didFailToContinueUserActivityWithType:error:");
	NSLog(@"%@", error);
}

- (BOOL)application:(NSApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray *restorableObjects))restorationHandler {
	NSLog(@"application:continueUserActivity:restorationHandler:");
	[userActivity getContinuationStreamsWithCompletionHandler:^(NSInputStream *inputStream, NSOutputStream *outputStream, NSError *error) {
		NSLog(@"getContinuationStreamsWithCompletionHandler:");
		if (error == nil) {
			NSNumber *num = userActivity.userInfo[@"ImageSize"];
			NSInteger dataSize = num.integerValue;
			_inputStream = inputStream;
			_outputStream = outputStream;
			
			[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[_outputStream open];
			[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[_inputStream open];
			
			NSInteger receivedBytes = 0;
			NSInteger length = 256;
			uint8_t buffer[length];
			
			NSMutableData *readData = [NSMutableData data];
			
			while (1) {
				NSInteger bytesRead = [_inputStream read:buffer maxLength:length];
				if (bytesRead <= 0)
					break;
				
				[readData appendBytes:buffer length:bytesRead];
				
				receivedBytes += bytesRead;
				
				if (receivedBytes >= dataSize)
					break;
				
				NSLog(@"%ld", receivedBytes);
			}
			NSImage *image = [[NSImage alloc] initWithData:readData];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"didReceive" object:nil userInfo:@{@"image":image}];
			
			[_outputStream close];
			[_inputStream close];
			_outputStream = nil;
			_inputStream = nil;
		}
		else {
			NSLog(@"%@", [error localizedDescription]);
		}
	}];
	restorationHandler(@[]);
	return YES;
}

@end
