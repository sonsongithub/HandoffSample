//
//  ViewController.m
//  HandoffSample
//
//  Created by sonson on 2014/09/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
	NSUserActivity *_activity;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_activity = [[NSUserActivity alloc] initWithActivityType:@"com.sonson.HandoffSample"];
	_activity.webpageURL = [NSURL URLWithString:@"http://www.apple.com"];
	_activity.title = @"Browsing";
	[_activity becomeCurrent];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
