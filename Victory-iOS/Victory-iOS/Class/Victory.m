//
//  Victory.m
//  Victory-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import "Victory.h"
#import "JSONKit.h"


#pragma mark - VictoryModel
@implementation VictoryModel
@synthesize name = _name;
@synthesize title = _title;
@synthesize description = _description;
@synthesize email = _email;
@synthesize method = _method;
@synthesize parameters = _parameters;
@synthesize url = _url;
@synthesize device = _device;
@synthesize os_version = _osVersion;
@synthesize status = _status;
@synthesize version = _version;
@synthesize access_token = _accessToken;
@synthesize create_time = _createTime;
@synthesize timeout = _timeout;
#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *infoPList = [[NSBundle mainBundle] infoDictionary];
        _version = [NSString stringWithFormat:@"%@ (%@)", [infoPList objectForKey:@"CFBundleShortVersionString"], [infoPList objectForKey:@"CFBundleVersion"]];
        _device = [UIDevice currentDevice].model;
        _osVersion = [UIDevice currentDevice].systemVersion;
        _createTime = [NSDate date];
        
        Victory *instance = [Victory instance];
        if (instance.name)
            _name = instance.name;
        else
            _name = [UIDevice currentDevice].name;
        if (instance.email)
            _email = instance.email;
        if (instance.accessToken)
            _accessToken = instance.accessToken;
    }
    return self;
}
+ (VictoryModel *)modelWithTitle:(NSString *)title description:(NSString *)description
{
    VictoryModel *result = [VictoryModel new];
    result.title = title;
    result.description = description;
    
    return result;
}

#pragma mark - Get dictionary
/**
 Convert VictoryModel to NSDictionary.
 @return: NSDictionary
 */
- (NSDictionary *)dictionary
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        [_formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
        [_formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    if (_name) { [result setObject:_name forKey:@"name"]; }
    else { [result setObject:@"user" forKey:@"name"]; }
    if (_title) { [result setObject:_title forKey:@"title"]; }
    else { [result setObject:@"title" forKey:@"title"]; }
    if (_description) { [result setObject:_description forKey:@"description"]; }
    if (_email) { [result setObject:_email forKey:@"email"]; }
    if (_method) { [result setObject:_method forKey:@"method"]; }
    if (_url) { [result setObject:_url forKey:@"url"]; }
    if (_device) { [result setObject:_device forKey:@"device"]; }
    if (_osVersion) { [result setObject:_osVersion forKey:@"os_version"]; }
    if (_status) { [result setObject:_status forKey:@"status"]; }
    if (_version) { [result setObject:_version forKey:@"version"]; }
    if (_accessToken) { [result setObject:_accessToken forKey:@"access_token"]; }
    if (_createTime) { [result setObject:[_formatter stringFromDate:_createTime] forKey:@"create_time"]; }
    if (_timeout) { [result setObject:_timeout forKey:@"timeout"]; }
    
    return result;
}

@end



#pragma mark - Victory
@implementation Victory

@synthesize name = _name;
@synthesize url = _url;
@synthesize appKey = _appKey;
@synthesize accessToken = _accessToken;
@synthesize email = _email;

static Victory *_instance;


#pragma mark - Init
+ (id)instance
{
    @synchronized (_instance) {
        if (_instance == nil) {
            _instance = [self new];
        }
        return _instance;
    }
}


#pragma mark - Setup
+ (void)setUrl:(NSString *)url andAppKey:(NSString *)appKey
{
    Victory *instance = [Victory instance];
    instance.url = url;
    instance.appKey = appKey;
}
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email
{
    Victory *instance = [Victory instance];
    instance.name = name;
    instance.email = email;
}
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email accessToken:(NSString *)accessToken
{
    Victory *instance = [Victory instance];
    instance.name = name;
    instance.email = email;
    instance.accessToken = accessToken;
}


#pragma mark - Send reports
+ (void)sendExceptionReportWithTitle:(NSString *)title description:(NSString *)description
{
    Victory *instance = [Victory instance];
    VictoryModel *model = [VictoryModel modelWithTitle:title description:description];
    model.type = VictoryReportException;
    [instance sendReport:model];
}
+ (void)sendExceptionReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    Victory *instance = [Victory instance];
    VictoryModel *model = [VictoryModel modelWithTitle:title description:error.description];
    model.type = VictoryReportException;
    
    if (response) {
        model.status = [NSString stringWithFormat:@"%i", response.statusCode];
    }
    if (request) {
        model.url = request.URL.absoluteString;
        model.method = request.HTTPMethod;
        if (request.timeoutInterval > 0)
            model.timeout = [NSString stringWithFormat:@"%.1f", request.timeoutInterval];
        if (request.HTTPBody && request.HTTPBody.length > 0)
            model.parameters = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    }
    [instance sendReport:model];
}
+ (void)sendLogReportWithTitle:(NSString *)title description:(NSString *)description
{
    Victory *instance = [Victory instance];
    VictoryModel *model = [VictoryModel modelWithTitle:title description:description];
    model.type = VictoryReportLog;
    [instance sendReport:model];
}
+ (void)sendLogReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    Victory *instance = [Victory instance];
    VictoryModel *model = [VictoryModel modelWithTitle:title description:error.description];
    model.type = VictoryReportLog;
    
    if (response) {
        model.status = [NSString stringWithFormat:@"%i", response.statusCode];
    }
    if (request) {
        model.url = request.URL.absoluteString;
        model.method = request.HTTPMethod;
        if (request.timeoutInterval > 0)
            model.timeout = [NSString stringWithFormat:@"%.1f", request.timeoutInterval];
        if (request.HTTPBody && request.HTTPBody.length > 0)
            model.parameters = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    }
    [instance sendReport:model];
}


#pragma mark - Instance messages
/**
 Send the report to the Victory server.
 @param model: report data
 */
- (void)sendReport:(VictoryModel *)model
{
    @try {
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        NSURL *url = nil;
        switch (model.type) {
            case VictoryReportException:
                if (_instance.url && _instance.appKey)
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/exception/%@", _instance.url, _instance.appKey]];
                else
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/exception/%@", VICTORY_URL, VICTORY_APP_KEY]];
                break;
            case VictoryReportLog:
            default:
                if (_instance.url && _instance.appKey)
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/log/%@", _instance.url, _instance.appKey]];
                else
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/log/%@", VICTORY_URL, VICTORY_APP_KEY]];
                break;
        }
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:30.0];  // timeout 30.0s
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:VICTORY_USER_AGENT forHTTPHeaderField:@"User-Agent"];
        [request setHTTPBody:model.dictionary.JSONData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue new]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if (error || data.length <= 0 || httpResponse.statusCode != 200) {
#if DEBUG
                                       NSLog(@"Victory send the report failed: %@", error.description);
#endif
                                   }
                                   else {
#if DEBUG
                                       NSLog(@"Victory send the report successful.");
#endif
                                   }
                               }];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"Victory sent the report failed (exception).");
#endif
    }
}


@end
