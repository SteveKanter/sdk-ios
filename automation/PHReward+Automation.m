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

 PHReward+Automation.m
 playhaven-sdk-ios

 Created by Jesus Fernandez on 6/7/12.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "PHReward+Automation.h"

static PHReward *LastReward;

@implementation PHReward (Automation)

+ (PHReward *)lastReward
{
    @synchronized ([PHReward class]) {
        return LastReward;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        @synchronized ([PHReward class]) {
            [LastReward release], LastReward = [self retain];
        }
    }

    return  self;
}
@end
