//
//  ViewController.m
//  HandoffSample
//
//  Created by sonson on 2014/09/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceive:) name:@"didReceive" object:nil];
}

- (void)didReceive:(NSNotification*)notification {
	NSImage *image = notification.userInfo[@"image"];
	_imageView.image = image;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
