//
//  StreamController.m
//  HandoffSample
//
//  Created by sonson on 2014/09/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "StreamController.h"

@interface StreamController() <NSStreamDelegate> {
	NSMutableData *_data;
	NSInputStream *_inputStream;
	NSOutputStream *_outputStream;
}
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@end


@implementation StreamController

+ (instancetype)controllerWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
	StreamController *controller = [[StreamController alloc] init];
	controller.inputStream = inputStream;
	controller.outputStream = outputStream;
	controller.inputStream.delegate = controller;
	controller.outputStream.delegate = controller;
	[controller start];
	return controller;
}

- (void)start {
	[_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_inputStream open];
	[_outputStream open];
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_data = [NSMutableData data];
	}
	return self;
}

//
//NSStreamEventNone  = 0,
//NSStreamEventOpenCompleted  = 1 << 0,
//NSStreamEventHasBytesAvailable  = 1 << 1,
//NSStreamEventHasSpaceAvailable  = 1 << 2,
//NSStreamEventErrorOccurred  = 1 << 3,
//NSStreamEventEndEncountered  = 1 << 4

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	NSLog(@"stream:handleEvent:");
	if (theStream == _inputStream)
		NSLog(@"InputStream");
	if (theStream == _outputStream)
		NSLog(@"OutputStream");
	switch (streamEvent) {
		case NSStreamEventNone:
			NSLog(@"NSStreamEventNone");
			break;
		case NSStreamEventOpenCompleted:
			NSLog(@"NSStreamEventOpenCompleted");
			break;
		case NSStreamEventHasBytesAvailable:
			NSLog(@"NSStreamEventHasBytesAvailable");
			break;
		case NSStreamEventHasSpaceAvailable:
			NSLog(@"NSStreamEventHasSpaceAvailable");
			break;
		case NSStreamEventEndEncountered:
			NSLog(@"NSStreamEventEndEncountered");
			break;
		case NSStreamEventErrorOccurred:
			NSLog(@"NSStreamEventErrorOccurred");
			break;
		default:
			NSLog(@"Unknown");
			break;
	}
}

- (void)read {
	int length = 100;
	uint8_t buffer[length];
	NSInteger bytesRead = [_inputStream read:buffer maxLength:length];
	NSLog(@"%ld", bytesRead);
}

- (void)writeData:(NSData*)data {
	uint8_t *p = (uint8_t*)[data bytes];
	NSInteger r = [_outputStream write:p maxLength:[data length]];
	NSLog(@"%ld", r);
}

@end
