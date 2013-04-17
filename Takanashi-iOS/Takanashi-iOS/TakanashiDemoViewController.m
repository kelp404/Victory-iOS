//
//  TakanashiDemoViewController.m
//  Takanashi-iOS
//
//  Created by Kelp on 2013/03/01.
//
//

#import "TakanashiDemoViewController.h"
#import "Takanashi.h"


#define ROW_SEND_LOG 0
#define ROW_SEND_EXCEPTION 1
#define ROW_CRASH 2


@implementation TakanashiDemoViewController


+ (NSString *)xibName
{
    return @"TakanashiDemoView";
}


#pragma mark - View Evnets
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Takanashi - iOS";
    
    // setup takanashi
    [Takanashi setUrl:@"https://takanashi-demo.appspot.com/api/v1"
            andAppKey:@"0571f5f6-652d-413f-8043-0e9531e1b689"];
    [Takanashi setUserName:@"Kelp" userEmail:@"kelp@phate.org"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Send reports
/**
 Send a log report to the server.
 */
- (void)sendLogReport
{
    // send a log report
    [Takanashi sendLogReportWithTitle:@"Login successful" description:@"account: 10210\nname: Kelp"];
}
/**
 Send an exception report to the server.
 */
- (void)sendExceptionReport
{
    // GET http://google.com.xxx
    NSURL *url = [NSURL URLWithString:@"http://google.com.xxx"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:1.0];  // timeout 1.0s
    
    NSURLResponse *httpResponse;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)httpResponse;
    
    if (error || data.length <= 0 || response.statusCode != 200) {
        // request failed, send an exception report
        [Takanashi sendExceptionReportWithTitle:@"web service error"
                                        request:request
                                       response:response
                                          error:error];
    }
}


#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell-%i-%i", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) { return cell; }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    switch (indexPath.row) {
        case ROW_SEND_LOG:
            cell.textLabel.text = @"Send a log report";
            break;
        case ROW_SEND_EXCEPTION:
            cell.textLabel.text = @"Send an exception report";
            break;
        case ROW_CRASH:
            cell.textLabel.text = @"Crash";
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ROW_SEND_LOG:
            // send a log report
            [self sendLogReport];
            break;
        case ROW_SEND_EXCEPTION:
            // send a exception report
            [self sendExceptionReport];
            break;
        case ROW_CRASH:
            // crash code
            @throw [NSException exceptionWithName:@"Takanashi - iOS" reason:@"crash test" userInfo:nil];
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        default:
            return -1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
