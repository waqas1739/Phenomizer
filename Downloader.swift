//
//  Downloader.swift
//  ThePhenomizer
//
//  Created by Robert Wicks on 12/2/15.
//  Copyright © 2015 SE15 UniB. All rights reserved.
//
//  Downloads the features

import UIKit

class Downloader: NSObject, NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    var spinnerCallback:(()->Void)!
    
    override init() {
        super.init()
        let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("featuresSession")
        backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }

    func download(callback: () -> Void) {
        spinnerCallback = callback
        let url = NSURL(string: "http://compbio.charite.de/jenkins/job/hpo/lastSuccessfulBuild/artifact/hp/hp.obo")!
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }

/* ********** Download delegate methods ************************************************************ */
    // Handler for download finished
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL){
            writeToPlistFromFile(location.path!)
    }
    
    // Handler for errors during download
    func URLSession(session: NSURLSession,
        task: NSURLSessionTask,
        didCompleteWithError error: NSError?){
            downloadTask = nil
            if (error != nil) {
                print(error?.description)
            }else{
                print("The task finished transferring data successfully")
            }
        backgroundSession.invalidateAndCancel()
    }
/* ********************************************************************************************* */
    
    func writeToPlistFromFile(path: String){
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        let url = NSURL(string: rootPath)
        let plistPathInDocument = (url?.URLByAppendingPathComponent("featuresPFile.plist").absoluteString)!
        // Loop over obo file to add to plist
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        let isFileFound:Bool? = NSFileManager.defaultManager().fileExistsAtPath(path)
        if isFileFound == true {
            if let fileStream = StreamReader(path: path) {
                defer {
                    fileStream.close()
                }
                
                var idFound:Bool = false
                var currId:String? = nil
                while let line = fileStream.nextLine() {
                    let options:[String] = ["name: ", "id: "]
                    for option in options {
                        let range = NSString(string: line).rangeOfString(option)
                        if range.location == 0 {
                            let rangeName = line.startIndex.advancedBy(option.characters.count)..<line.endIndex
                            
                            if (idFound && currId != nil) {
                                // we've already found the id and now we have the corresponding fname
                                dict.setObject(line[rangeName], forKey: currId!)
                                currId = nil
                                idFound = false
                            } else {
                                currId = line[rangeName]
                                idFound = true
                            }
                        }
                    }
                }
                dict.writeToFile(plistPathInDocument, atomically: false)
            }
        }
        spinnerCallback()
        let http = HTTPRequest()
        http.sendVersionQueryAndSave() //save the version for the copy of the db that we just got
    }
}

