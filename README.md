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


##Update server url and application key
open `/Takanashi-iOS/Takanashi-iOS/Class/Takanashi.h`
```objective-c
// this is your takanashi server url
#define TAKANASHI_URL @"https://takanashi-demo.appspot.com/api/v1"

// this is your takanashi application key
#define TAKANASHI_APP_KEY @"0571f5f6-652d-413f-8043-0e9531e1b689"
```


##References
+ https://github.com/kelp404/Takanashi
+ https://github.com/kelp404/KSCrash (<a href="https://github.com/kstenerud/KSCrash" target="_blank">origin</a>)