//
//  ViewController.m
//  HandoffSample
//
//  Created by sonson on 2014/09/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSUserActivityDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	NSUserActivity *_activity;
	NSUserActivity *_activityForOSX;
	NSOutputStream *_outputStream;
	NSData *_imageBinary;
	IBOutlet UIImageView *_imageView;
}
@end

@implementation ViewController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	_imageView.image = image;
	_imageBinary = UIImageJPEGRepresentation(image, 0.2);
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pusuButton:(id)sender {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)check:(NSTimer*)timer {
	if (_imageBinary) {
		if (_activityForOSX == nil) {
			_activityForOSX = [[NSUserActivity alloc] initWithActivityType:@"com.sonson.OSX.HandoffSample"];
			_activityForOSX.title = @"Browsing";
			_activityForOSX.userInfo = @{@"ImageSize":@(_imageBinary.length)};
			_activityForOSX.supportsContinuationStreams = YES;
			_activityForOSX.delegate = self;
			[_activityForOSX becomeCurrent];
		}
	}
	else {
		[_activityForOSX invalidate];
		_activityForOSX.delegate = nil;
		_activityForOSX = nil;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(check:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)userActivity:(NSUserActivity *)userActivity didReceiveInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
	NSLog(@"userActivity:didReceiveInputStream:outputStream:");
	_outputStream = outputStream;
	NSInteger dataSize = _imageBinary.length;
	NSInteger sendSize = 0;
	
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream open];
	
	uint8_t *p = (uint8_t*)[_imageBinary bytes];
	
	while (1) {
		NSInteger bytesToSend = (dataSize - sendSize) > 100 ? 100 : (dataSize - sendSize);
		NSInteger result = [_outputStream write:p + sendSize maxLength:bytesToSend];
		
		if (result < 0) {
			NSLog(@"Error - %ld", result);
			break;
		}
		
		sendSize += result;
		if (sendSize >= dataSize)
			break;
		NSLog(@"%ld", sendSize);
	}
	_imageBinary = nil;
}

- (void)userActivityWasContinued:(NSUserActivity *)userActivity {
	NSLog(@"userActivityWasContinued:");
}

- (void)userActivityWillSave:(NSUserActivity *)userActivity {
	NSLog(@"userActivityWillSave:");
}

@end
