/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright 2013 Medium Entertainment, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 PushNotificationRegistrationViewController.h
 playhaven-sdk-ios

 Created by Anton Fedorchenko on 4/12/13.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PushNotificationRegistrationViewController.h"

@interface PushNotificationRegistrationViewController ()

@end

@implementation PushNotificationRegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = nil;
	
	[[PHPushProvider sharedInstance] addObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[PHPushProvider sharedInstance] removeObserver:self];
	
	[super dealloc];
}

- (IBAction)registerForPushNotifications:(id)aSender
{
	[self startTimers];
	[self addMessage:@"Sending Registration Request to PNs Provider..."];

	[[PHPushProvider sharedInstance] registerForPushNotifications];
}

- (IBAction)unregisterForPushNotifications:(id)aSender
{
	[self startTimers];
	[self addMessage:@"Sending Unregistration Request to PNs Provider..."];
	
	[[PHPushProvider sharedInstance] unregisterForPushNotifications];
}

#pragma mark - PushRegistrationObserver

- (void)provider:(PHPushProvider *)aProvider
			didSucceedWithResponse:(NSDictionary *)aResponse
{
    NSString *theMessage = [NSString stringWithFormat:@"[OK] Success with response: %@",
				aResponse];
    [self addMessage:theMessage];

    [self finishRequest];
}

- (void)provider:(PHPushProvider *)aProvider
			didFailWithError:(NSError *)anError
{
    NSString *theMessage = [NSString stringWithFormat:@"[ERROR] Failed with error: %@",
				anError];
    [self addMessage:theMessage];

    [self finishRequest];
}

@end
