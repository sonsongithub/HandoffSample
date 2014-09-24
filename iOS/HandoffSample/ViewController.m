//
//  ViewController.m
//  HandoffSample
//
//  Created by sonson on 2014/09/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import "StreamController.h"

@interface ViewController () <NSUserActivityDelegate> {
	StreamController *_streamController;
	NSUserActivity *_activity;
	NSUserActivity *_activityForOSX;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	_activity = [[NSUserActivity alloc] initWithActivityType:@"com.sonson.HandoffSample"];
//	_activity.webpageURL = [NSURL URLWithString:@"http://www.apple.com"];
//	_activity.title = @"Browsing";
//	[_activity becomeCurrent];
	
	_activityForOSX = [[NSUserActivity alloc] initWithActivityType:@"com.sonson.OSX.HandoffSample"];
	_activityForOSX.title = @"Browsing";
	_activityForOSX.userInfo = @{@"hoge":@"hoge"};
	_activityForOSX.supportsContinuationStreams = YES;
	_activityForOSX.delegate = self;
	[_activityForOSX becomeCurrent];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)userActivity:(NSUserActivity *)userActivity didReceiveInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
	NSLog(@"userActivity:didReceiveInputStream:outputStream:");
	_streamController = [StreamController controllerWithInputStream:inputStream outputStream:outputStream];
	unsigned char *p = (unsigned char*)malloc(sizeof(unsigned char) * 100);
	NSData *data = [NSData dataWithBytes:p length:100];
	[_streamController writeData:data];
	free(p);
}

- (void)userActivityWasContinued:(NSUserActivity *)userActivity {
	NSLog(@"userActivityWasContinued:");
}

- (void)userActivityWillSave:(NSUserActivity *)userActivity {
	NSLog(@"userActivityWillSave:");
}

@end
