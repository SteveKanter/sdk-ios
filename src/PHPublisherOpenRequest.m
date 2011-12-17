//
//  PHPublisherOpenRequest.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/30/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherOpenRequest.h"
#import "PHConstants.h"
#import "SDURLCache.h"
#import "SBJsonParser.h"

static BOOL initialized = NO;

@implementation PHPublisherOpenRequest

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/open/);
}

+(void)phCacheInitialize
{
    if (initialized)
        return;

    initialized = YES;

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024             // 1MB mem cache
                                               diskCapacity:1024*1024*5                     // 5MB disk cache
                                               diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    //[urlCache release]; // NOTE: Move to property and release in dealloc? or just release here?
}

-(void)storePrefetchUrls:(NSDictionary *)urls directory:(NSString *)cacheDirectory
{
    NSEnumerator *keyEnum = [urls keyEnumerator];
    id key;
    while ((key = [keyEnum nextObject]))
    {
        if (![(NSString *)key isEqualToString:@"id"])
        {
            NSString *urlString = [urls objectForKey:key];
            NSLog(@"Downloading url = %@", urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if (urlData)
            {
                NSString *filename = [[url path] lastPathComponent];
                NSLog(@"file name = %@", [filename stringByDeletingPathExtension]);
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, [filename stringByDeletingPathExtension]];
                [urlData writeToFile:filePath atomically:YES];
            }
        }
    }
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{

    if ([responseData count] > 0){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [paths objectAtIndex:0];  

        NSString *cacheInfoPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, @"prefetchCache.plist"];
        NSLog(@"Writing pre-fetch cache plist = %@", cacheInfoPath);

        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:cacheInfoPath]){
            [responseData writeToFile:cacheInfoPath atomically:YES];
            [self storePrefetchUrls:responseData directory:cacheDirectory];
        }
        else{
            NSDictionary *localPrefetchInfo = [[NSDictionary alloc] initWithContentsOfFile:cacheInfoPath];
            NSString *localId = [localPrefetchInfo objectForKey:@"id"];
            NSString *networkId = [responseData objectForKey:@"id"];
            if (![localId isEqualToString:networkId])
                [self storePrefetchUrls:responseData directory:cacheDirectory];
        }
        [fileManager release];
    }

    if ([self.delegate respondsToSelector:@selector(request:didSucceedWithResponse:)]) {
        [self.delegate performSelector:@selector(request:didSucceedWithResponse:) withObject:self withObject:responseData];
    }
}

@end
