//
//  Victory.h
//  Victory-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import <Foundation/Foundation.h>


#define VICTORY_URL @"https://victory-demo.appspot.com/api/v1"
#define VICTORY_APP_KEY @"2324e6e2-3407-4896-a498-5d340b9f300c"
#define VICTORY_USER_AGENT @"Victory iOS"


#pragma mark - VictoryReportType
typedef enum {
    VictoryReportException = 0,
    VictoryReportLog = 1,
} VictoryReportType;


#pragma mark - VictoryModel
/**
 An exception, log report data model.
 */
@interface VictoryModel : NSObject {
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
@property (nonatomic) VictoryReportType type;
+ (VictoryModel *)modelWithTitle:(NSString *)title description:(NSString *)description;
@end



#pragma mark - Victory
@interface Victory : NSObject

// victory application key
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *accessToken;

+ (id)instance;

#pragma mark - Setup
+ (void)setUrl:(NSString *)url andAppKey:(NSString *)appKey;
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email;
+ (void)setUserName:(NSString *)name userEmail:(NSString *)email accessToken:(NSString *)accessToken;

#pragma mark - Send reports
+ (void)sendExceptionReportWithTitle:(NSString *)title description:(NSString *)description;
+ (void)sendExceptionReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error;
+ (void)sendLogReportWithTitle:(NSString *)title description:(NSString *)description;
+ (void)sendLogReportWithTitle:(NSString *)title request:(NSURLRequest *)request response:(NSHTTPURLResponse *)response error:(NSError *)error;


@end
