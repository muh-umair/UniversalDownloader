# UniversalDownloader
UniversalDownloader is a library to dowload all types of resource from the network. 

#### Supported types
- Image (PNG, JPG, etc.)
- JSON
- Raw data

## Installation
#### CocoaPods
```
pod 'UniversalDownloader', :git => 'https://github.com/umairbhatti39/UniversalDownloader', :tag => '1.0.0'
```
#### Manual
Drag drop Source directory from root into your project.

## Usage
```
import UniversalDownloader
```
#### Downloader
Use one of the following to access downloader object 
```
UniversalDownloader.shared
``` 
or 
```
let downloader = UniversalDownloader(configs: UniversalDownloaderConfigs.default)
```

#### Basic Request
Making a request for any kind of resource
```
let url = "URL for a resource"

UniversalDownloader.shared
.request(url: url)
.response { (status, errorMessage, response) in
        
    //Handle response data
    let data = response?.rawData
        
}
```

#### Image
Loading images
```
let url = "URL for an image"

UniversalDownloader.shared
.request(url: url)
.responseImage { (status, errorMessage, response) in
    
    //Handle response image
    let data = response?.image
    
}
```
or
```
let url = "URL for an image"

UniversalDownloader.shared
.request(url: url)
.responseImage(in: myImageView, placeholder: UIImage(named: "placeholder"), failure: UIImage("failure"))
```

#### JSON
Loading JSON from the network
```
let url = "URL for JSON"

UniversalDownloader.shared
.request(url: url)
.responseJSON { (status, errorMessage, response) in
    
    //Handle response json
    let json = response?.json
    let jsonAsArray = response?.array
    let jsonAsDictionary = response?.dictionary
    
}
```

#### Working Examples
Clone/download the repo and open `Example.xcworkspace` to check UniversalDownloader in action. 


