//
//  Takanashi.m
//  Takanashi-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import "Takanashi.h"
#import "JSONKit.h"


#pragma mark - TakanashiModel
@implementation TakanashiModel
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
        _name = [UIDevice currentDevice].name;
        _osVersion = [UIDevice currentDevice].systemVersion;
        _createTime = [NSDate date];
    }
    return self;
}
+ (TakanashiModel *)modelWithTitle:(NSString *)title description:(NSString *)description
{
    TakanashiModel *result = [TakanashiModel new];
    result.title = title;
    result.description = description;
    
    return result;
}

#pragma mark - Get dictionary
/**
 Convert TakanashiModel to NSDictionary.
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



#pragma mark - Takanashi
@implementation Takanashi

@synthesize name = _name;
@synthesize appKey = _appKey;
@synthesize accessToken = _accessToken;
@synthesize email = _email;

static Takanashi *_instance;


#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self) {
        _reportsQueue = [NSMutableArray new];
        // retry sending reports after 60s
        _retryTime = dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC);
        _dispatch = dispatch_queue_create("takanashi.dispatch", NULL);
    }
    return self;
}
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
+ (void)setAppKey:(NSString *)appKey
{
    Takanashi *instance = [Takanashi instance];
    instance.appKey = appKey;
}
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email
{
    Takanashi *instance = [Takanashi instance];
    instance.name = name;
    instance.email = email;
}
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email accessToken:(NSString *)accessToken
{
    Takanashi *instance = [Takanashi instance];
    instance.name = name;
    instance.email = email;
    instance.accessToken = accessToken;
}


#pragma mark - Send reports
+ (void)sendExceptionReportWithTitle:(NSString *)title description:(NSString *)description
{
    Takanashi *instance = [Takanashi instance];
    TakanashiModel *model = [TakanashiModel modelWithTitle:title description:description];
    model.type = TakanashiReportException;
    [instance sendReport:model];
}
+ (void)sendExceptionReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    Takanashi *instance = [Takanashi instance];
    TakanashiModel *model = [TakanashiModel modelWithTitle:title description:error.description];
    model.type = TakanashiReportException;
    
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
    Takanashi *instance = [Takanashi instance];
    TakanashiModel *model = [TakanashiModel modelWithTitle:title description:description];
    model.type = TakanashiReportLog;
    [instance sendReport:model];
}
+ (void)sendLogReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error
{
    Takanashi *instance = [Takanashi instance];
    TakanashiModel *model = [TakanashiModel modelWithTitle:title description:error.description];
    model.type = TakanashiReportLog;
    
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
 Send the report to the takanashi server.
 @param model: report data
 */
- (void)sendReport:(TakanashiModel *)model
{
    @try {
        NSMutableURLRequest *request = [NSMutableURLRequest new];
        NSURL *url = nil;
        switch (model.type) {
            case TakanashiReportException:
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/exception/%@", TAKANASHI_URL, _instance.appKey]];
                break;
            case TakanashiReportLog:
            default:
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/log/%@", TAKANASHI_URL, _instance.appKey]];
                break;
        }
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:30.0];  // timeout 30.0s
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:TAKANASHI_USER_AGENT forHTTPHeaderField:@"User-Agent"];
        [request setHTTPBody:model.dictionary.JSONData];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue new]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                   if (error || data.length <= 0 || httpResponse.statusCode != 200) {
                                       // push into reports queue
                                       dispatch_sync(_dispatch, ^{
                                           [_reportsQueue addObject:model];
                                           if (_reportsQueue.count > 5) {
                                               [_reportsQueue removeObjectAtIndex:0];
                                           }
                                       });
                                       // retry to send reports
                                       dispatch_after(_retryTime, _dispatch, ^(void){
                                           if (_reportsQueue.count > 0) {
                                               TakanashiModel *model = [_reportsQueue objectAtIndex:0];
                                               [_reportsQueue removeObjectAtIndex:0];
                                               [self sendReport:model];
                                           }
                                       });
#if DEBUG
                                       NSLog(@"Takanashi send the report failed: %@", error.description);
#endif
                                   }
                                   else {
#if DEBUG
                                       NSLog(@"Takanashi send the report successful.");
#endif
                                   }
                               }];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"Takanashi sent the report failed (exception).");
#endif
    }
}


@end
