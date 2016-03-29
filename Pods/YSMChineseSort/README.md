# YSMChineseSort

[![CI Status](http://img.shields.io/travis/ysmeng/YSMChineseSort.svg?style=flat)](https://travis-ci.org/ysmeng/YSMChineseSort)
[![Version](https://img.shields.io/cocoapods/v/YSMChineseSort.svg?style=flat)](http://cocoapods.org/pods/YSMChineseSort)
[![License](https://img.shields.io/cocoapods/l/YSMChineseSort.svg?style=flat)](http://cocoapods.org/pods/YSMChineseSort)
[![Platform](https://img.shields.io/cocoapods/p/YSMChineseSort.svg?style=flat)](http://cocoapods.org/pods/YSMChineseSort)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.     

pod 'YSMChineseSort','~>0.1.0'

## Requirements
iOS 7.1

## Installation

YSMChineseSort is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

## Quick Start
1、import "NSArray+SortContact.h";    

2、
>>[self.dataSource sortContactTOTitleAndSectionRow:^(BOOL isSuccess, NSArray *titleArray, NSArray *rowArray) {   

>>>>if (isSuccess) {    

>>>>>>[self.titleDataSource addObjectsFromArray:titleArray];   

>>>>>>[self.rowDataSource addObjectsFromArray:rowArray];          

>>>>}    

>>}];    

## Author

ysmeng, 49427823@163.com

## License

YSMChineseSort is available under the MIT license. See the LICENSE file for more info.
