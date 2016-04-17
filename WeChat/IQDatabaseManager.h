/*
 IQDatabaseManager

 The MIT License (MIT)
 
 Copyright (c) 2014 Mohd Iftekhar Qurashi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/*
Faulting and Uniquing

Faulting is a mechanism Core Data employs to reduce your application’s memory usage. A related feature called uniquing ensures that, in a given managed object context, you never have more than one managed object to represent a given record.

 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdFaultingUniquing.html
*/


#ifndef IQ_INSTANCETYPE
    #if __has_feature(objc_instancetype)
        #define IQ_INSTANCETYPE instancetype
    #else
        #define IQ_INSTANCETYPE id
    #endif
#endif



//Created by Iftekhar. 17/4/13.
@interface IQDatabaseManager : NSObject

//Shared Object.
+ (IQ_INSTANCETYPE )sharedManager;

//Save context
- (BOOL)save;

@end
