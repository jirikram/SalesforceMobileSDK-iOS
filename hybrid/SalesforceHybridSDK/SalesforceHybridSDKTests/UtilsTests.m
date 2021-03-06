/*
 Copyright (c) 2012, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UtilsTests.h"
#import "NSURL+SFStringUtils.h"

@implementation UtilsTests

#pragma mark - NSURL+SFStringUtils tests

- (void)testNoQueryString
{
    NSString *inUrlString = @"https://www.myserver.com/path.html";
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSString *outUrlString = [url redactedAbsoluteString:nil];
    STAssertEquals(inUrlString, outUrlString,
                   @"'%@' and '%@' should be the same, with no querystring.",
                   inUrlString,
                   outUrlString);
}

- (void)testNoParams
{
    NSString *inUrlString = @"https://www.myserver.com/path?param1=val1&param2=val2";
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSString *outUrlString = [url redactedAbsoluteString:nil];
    STAssertEquals(inUrlString, outUrlString,
                   @"'%@' and '%@' should be the same, with no arguments.",
                   inUrlString,
                   outUrlString);
}

- (void)testNoMatchingParams
{
    NSString *inUrlString = @"https://www.myserver.com/path?param1=val1&param2=val2";
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSArray *redactParams = [NSArray arrayWithObjects:@"param3", @"param4", nil];
    NSString *outUrlString = [url redactedAbsoluteString:redactParams];
    STAssertTrue([inUrlString isEqualToString:outUrlString],
                 @"'%@' and '%@' should be the same, with no matching arguments.",
                 inUrlString,
                 outUrlString);
}

- (void)testOneMatchingParam
{
    NSString *inUrlString = @"https://www.myserver.com/path?param1=val1&param2=val2";
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSArray *redactParams = [NSArray arrayWithObjects:@"param1", nil];
    NSString *expectedOutUrlString = [NSString stringWithFormat:@"https://www.myserver.com/path?param1=%@&param2=val2",
                                      kSFRedactedQuerystringValue];
    NSString *actualOutUrlString = [url redactedAbsoluteString:redactParams];
    STAssertTrue([expectedOutUrlString isEqualToString:actualOutUrlString],
                 @"'%@' should turn into '%@'.  Got '%@' instead.",
                 inUrlString,
                 expectedOutUrlString,
                 actualOutUrlString);
}

- (void)testMultipleMatchingParams
{
    NSString *inUrlString = @"https://www.myserver.com/path?param1=val1&param2=val2";
    NSURL *url = [NSURL URLWithString:inUrlString];
    NSArray *redactParams = [NSArray arrayWithObjects:@"param1", @"param2", nil];
    NSString *expectedOutUrlString = [NSString stringWithFormat:@"https://www.myserver.com/path?param1=%@&param2=%@",
                                      kSFRedactedQuerystringValue,
                                      kSFRedactedQuerystringValue];
    NSString *actualOutUrlString = [url redactedAbsoluteString:redactParams];
    STAssertTrue([expectedOutUrlString isEqualToString:actualOutUrlString],
                 @"'%@' should turn into '%@'.  Got '%@' instead.",
                 inUrlString,
                 expectedOutUrlString,
                 actualOutUrlString);
}

@end
