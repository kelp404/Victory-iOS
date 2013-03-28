//
//  Takanashi.h
//  Takanashi-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import <Foundation/Foundation.h>


#if !TAKANASHI_APP_KEY
    #define TAKANASHI_URL @"https://takanashi-demo.appspot.com/api/v1"
    #define TAKANASHI_APP_KEY @"0571f5f6-652d-413f-8043-0e9531e1b689"
    #define TAKANASHI_USER_AGENT @"Takanashi iOS"
#endif


#pragma mark - TakanashiReportType
typedef enum {
    TakanashiReportException = 0,
    TakanashiReportLog = 1,
} TakanashiReportType;


#pragma mark - TakanashiModel
/**
 An exception, log report data model.
 */
@interface TakanashiModel : NSObject {
    NSDateFormatter *_formatter;
}
@property (strong, nonatomic) NSString *version;        // app version
@property (strong, nonatomic) NSString *email;          // user email
@property (strong, nonatomic) NSString *name;           // user name
@property (strong, nonatomic) NSString *status;         // http response status code
@property (strong, nonatomic) NSString *os_version;     // device os version
@property (strong, nonatomic) NSString *device;         // device model
@property (strong, nonatomic) NSString *method;         // http request method
@property (strong, nonatomic) NSString *url;            // http request url
@property (strong, nonatomic) NSString *timeout;        // http request timeout
@property (strong, nonatomic) NSString *access_token;   // user access token
@property (strong, nonatomic) NSString *parameters;     // http request parameters
@property (strong, nonatomic) NSString *title;          // report title
@property (strong, nonatomic) NSString *description;    // report description
@property (strong, nonatomic) NSDate *create_time;      // report datetime "yyyy-MM-ddTHH:mm:ss"
@property (nonatomic) TakanashiReportType type;
+ (TakanashiModel *)modelWithTitle:(NSString *)title description:(NSString *)description;
@end



#pragma mark - Takanashi
@interface Takanashi : NSObject {
    // if the report sent failed, it will cache in this array.
    NSMutableArray *_reportsQueue;
    // resend reports, add model into _reportsQueue should process in this dispatch.
    dispatch_queue_t _dispatch;
    // retry sending reports after 60s
    dispatch_time_t _retryTime;
}

// takanashi application key
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *accessToken;

#pragma mark - Setup
+ (void)setAppKey:(NSString *)appKey;
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email;
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email accessToken:(NSString *)accessToken;

#pragma mark - Send reports
+ (void)sendExceptionReportWithTitle:(NSString *)title description:(NSString *)description;
+ (void)sendExceptionReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error;
+ (void)sendLogReportWithTitle:(NSString *)title description:(NSString *)description;
+ (void)sendLogReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error;


@end
