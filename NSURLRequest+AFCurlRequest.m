//
//  NSURLRequest+AFCurlRequest.m
//  AFCurlRequest
//
//  Created by Alan Francis on 21/12/2012.
//  Copyright (c) 2012 Alan Francis. All rights reserved.
//

#define kCurlCommand        @"curl"
#define kCurlFlagVerbsity   @" --verbose"
#define kCurlFlagHeader     @" --header \"%@:%@\""
#define kCurlFlagRequest    @" --request %@ %@"
#define kCurlFlagData       @" --data '%@'"

#import "NSURLRequest+AFCurlRequest.h"

@implementation NSURLRequest (AFCurlRequest)
- (NSString*)af_curlRequest {
    return [self af_curlRequestWithVerbose:NO];
}

- (NSString*)af_curlRequestWithVerbose:(BOOL)verbose {
    NSString* verboseString = verbose ? kCurlFlagVerbsity : @"";
    NSString* command = [NSString stringWithFormat:@"%@%@",
                              kCurlCommand,
                              verboseString];
    NSString* headerString = @"";
    
    for( NSString* header in self.allHTTPHeaderFields.allKeys ) {
        if ( [header isEqualToString:@"Accept-Language"] != YES )
            headerString = [headerString stringByAppendingFormat:kCurlFlagHeader, header, [self.allHTTPHeaderFields objectForKey:header]];
    }
    
    NSString* commandWithHeaders =  [command stringByAppendingString:headerString];
    
    NSString* dataString = @"";
    if( self.HTTPBody ) {
        dataString = [NSString stringWithFormat:kCurlFlagData, [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    NSString* request = [NSString stringWithFormat:kCurlFlagRequest, self.HTTPMethod, [NSString stringWithFormat:@"\"%@\"", self.URL.absoluteString]];

    return [[commandWithHeaders stringByAppendingString:dataString] stringByAppendingString:request];
}


@end
