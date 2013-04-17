#Takanashi-iOS

Kelp http://kelp.phate.org/  
[MIT License][mit]  
[MIT]: http://www.opensource.org/licenses/mit-license.php


<a href="https://github.com/Kelp404/Takanashi" target="_blank">Takanashi</a> is an error reporting server. It runs on Google App Engine.  
This project **Takanashi-iOS** is an error reporter demo. It could send crash, log information to Takanashi server.  


##Clone
```
$ git clone --recursive git://github.com/kelp404/Takanashi-iOS.git
```


##Example
```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Takanashi - iOS";
    
    // setup takanashi
    // these are your takanashi server url and application key
    [Takanashi setUrl:@"https://takanashi-demo.appspot.com/api/v1"
            andAppKey:@"0571f5f6-652d-413f-8043-0e9531e1b689"];

    // app user name
    [Takanashi setUserName:@"Kelp" userEmail:@"kelp@phate.org"];
}

// send log report method
- (void)sendLogReport
{
    // send a log report
    [Takanashi sendLogReportWithTitle:@"Login successful" description:@"account: 10210\nname: Kelp"];
}
```


##References
+ https://github.com/kelp404/Takanashi
+ https://github.com/kelp404/KSCrash (<a href="https://github.com/kstenerud/KSCrash" target="_blank">origin</a>)
