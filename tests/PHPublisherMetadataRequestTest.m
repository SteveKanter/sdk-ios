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

 PHPublisherMetadataRequestTest.m
 playhaven-sdk-ios

 Created by Jesus Fernandez on 3/30/11.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <SenTestingKit/SenTestingKit.h>
#import "PHPublisherMetadataRequest.h"
#import "PHConstants.h"
#import "SenTestCase+PHAPIRequestSupport.h"

@interface PHPublisherMetadataRequestTest : SenTestCase
@end

@implementation PHPublisherMetadataRequestTest

- (void)testInstance
{
    PHPublisherMetadataRequest *request = [PHPublisherMetadataRequest requestForApp:@"" secret:@"" placement:@"" delegate:self];
    STAssertNotNil(request, @"expected request instance, got nil");
}
- (void)testRequestParameters
{
    NSString *token  = @"PUBLISHER_TOKEN",
             *secret = @"PUBLISHER_SECRET";

    [PHAPIRequest setCustomUDID:nil];

    PHPublisherMetadataRequest *request = [PHPublisherMetadataRequest requestForApp:token secret:secret];

    NSURL *theRequestURL = [self URLForRequest:request];
    NSDictionary *signedParameters  = [request signedParameters];
    NSString     *requestURLString  = [theRequestURL absoluteString];

//#define PH_USE_MAC_ADDRESS 1
#if PH_USE_MAC_ADDRESS == 1
    if (PH_SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        NSString *mac   = [signedParameters valueForKey:@"mac"];
        STAssertNotNil(mac, @"MAC param is missing!");
        STAssertFalse([requestURLString rangeOfString:@"mac="].location == NSNotFound, @"MAC param is missing!");
    }
#else
    NSString *mac   = [signedParameters valueForKey:@"mac"];
    STAssertNil(mac, @"MAC param is present!");
    STAssertTrue([requestURLString rangeOfString:@"mac="].location == NSNotFound, @"MAC param exists when it shouldn't.");
#endif
}

@end
