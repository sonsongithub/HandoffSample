//
//  AppDelegate.m
//  HandoffSample
//
//  Created by sonson on 2014/09/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AppDelegate.h"
#import "StreamController.h"

@interface AppDelegate () {
	StreamController *_streamController;
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
			_streamController = [StreamController controllerWithInputStream:inputStream outputStream:outputStream];
			[_streamController read];
		}
		else {
			NSLog(@"%@", [error localizedDescription]);
		}
	}];
	restorationHandler(@[]);
	return YES;
}

@end
