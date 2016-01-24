//
//  RAFNMainViewController.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "RAFNMainViewController.h"
//Preserve double completion blocks for testing
#define RAFN_MAINTAIN_COMPLETION_BLOCKS
#import "RACAFNetworking.h"

@interface RAFNMainViewController ()

@property (nonatomic, strong) UITextView *statusTextView;
@property (nonatomic, strong) UIImageView *afLogoImageView;
@property (nonatomic, strong) UIButton *startTestingButton;
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, assign) BOOL isTesting;

@property (nonatomic, strong) RACDisposable *currentDisposable;
@property (nonatomic, strong) RACSubject *statusSignal;

@end

@implementation RAFNMainViewController 

- (id)init {
	self = [super init];
	
	//Signal for the textview's text
	_statusSignal = [RACSubject subject];

	return self;
}

- (void)viewDidLoad {
	// Do any additional setup after loading the view.
	CGRect slice, remainder;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);

	self.statusTextView = [[UITextView alloc]initWithFrame:remainder];
	self.statusTextView.editable = NO;
	self.statusTextView.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
	[self.statusTextView setTextAlignment:NSTextAlignmentCenter];
	[self.statusTextView rac_liftSelector:@selector(setText:) withSignals:self.statusSignal, nil];
	
	self.afLogoImageView = [[UIImageView alloc]initWithFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
	self.startTestingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.startTestingButton setTitle:@"Start Testing" forState:UIControlStateNormal];
	self.startTestingButton.frame = self.view.bounds;
	
	[[self.startTestingButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *testingButton) {
		self.isTesting = !self.isTesting;
		[testingButton setTitle:(self.isTesting ? @"Cancel Testing..." : @"Start Testing") forState:UIControlStateNormal];
		[UIView animateWithDuration:0.5 animations:^{
			[testingButton setFrame:(self.isTesting ? slice : self.view.bounds)];
		}];
		if (self.isTesting) {
			[self testImageFetch];
		} else {
			[self cancelTheShow];
			
		}
	}];
	
	[self.view addSubview:self.statusTextView];
	[self.view addSubview:self.afLogoImageView];
	[self.view addSubview:self.startTestingButton];
	
	//Get network status
	self.httpClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://www.baidu.com"]];
	self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];

	[self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
		AFNetworkReachabilityStatus networkStatus = [status intValue];
		switch (networkStatus) {
			case AFNetworkReachabilityStatusUnknown:
			case AFNetworkReachabilityStatusNotReachable:
				[self.statusSignal sendNext:@"Cannot Reach Host"];
				[self cancelTheShow];
				break;
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				break;
		}
		
	}];
	
	[super viewDidLoad];
}

- (void)testImageFetch {
	//Fetch the image.  WHen fetched, animate the logo image up, then down and start the next test.
	[self.statusSignal sendNext:@"获取 AFNetworking 图标..."];
	
	RACSubject *imageSubject = [RACSubject subject];
	[self.afLogoImageView rac_liftSelector:@selector(setImage:) withSignals:imageSubject, nil];
	
	NSString *urlStr = @"https://camo.githubusercontent.com/1560be050811ab73457e90aee62cd1cd257c7fb9/68747470733a2f2f7261772e6769746875622e636f6d2f41464e6574776f726b696e672f41464e6574776f726b696e672f6173736574732f61666e6574776f726b696e672d6c6f676f2e706e67";
	self.httpClient.responseSerializer = [AFImageResponseSerializer serializer];

	_currentDisposable = [[[self.httpClient rac_GET:urlStr parameters:nil] map:^id(RACTuple *value) {
		return [value first];
	}] subscribeNext:^(UIImage *image) {
		[imageSubject sendNext:image];
		CGRect slice, remainder;
		CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
		[UIView animateWithDuration:0.5 animations:^{
			[self.afLogoImageView setFrame:remainder];
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
				[self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
			} completion:^(BOOL finished) {
				[self testXMLFetch];
			}];
		}];
	}];
}

- (void)testXMLFetch {
	//Fetch the Flickr feed for groups.
	[self.statusSignal sendNext:@"获取 XML格式的 天气预报..."];

	
	NSString *urlStr = @"http://wthrcdn.etouch.cn/WeatherApi?citykey=101010100";
	self.httpClient.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	_currentDisposable = [[[self.httpClient rac_GET:urlStr parameters:nil]map:^id(RACTuple *value) {
		return [value second];
	}] subscribeNext:^(NSHTTPURLResponse *response) {
		[self.statusSignal sendNext:response.allHeaderFields.description];
		
		[self performSelector:@selector(testError) withObject:nil afterDelay:0.5];
	}];
}

- (void)testError {
	[self.statusSignal sendNext:@"Sending Error-Prone Request..."];
	
	//Send an un-authorized request to show how error blocks work.
	NSString *urlStr = @"http://wthrcdn.etouch.cn/";
	NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *params = @{@"citykey": @"101010101"};
	NSString *path = [[NSString alloc]initWithFormat:@"weather_mini"];
	
	AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	_currentDisposable = [[manager rac_GET:path parameters:params] subscribeError:^(NSError *error) {
		[self.statusSignal sendNext:[error localizedDescription]];
		
		[self performSelector:@selector(finish) withObject:nil afterDelay:0.5];
	}];
}

- (void)finish {
	[self.statusSignal sendNext:@"Finished!"];
	[self.startTestingButton setTitle:@"Restart Tests" forState:UIControlStateNormal];
	self.isTesting = !self.isTesting;
}

- (void)cancelTheShow {
	//Kills the current disposable and removes the image view.
	CGRect slice, remainder;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
	
	[self.statusSignal sendNext:@""];
	[_currentDisposable dispose];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
	}];
}


@end
