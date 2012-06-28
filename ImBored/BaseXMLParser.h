//
//  BaseXMLParser.h
//  ImBored
//
//  Created by Amy Dyer on 4/9/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseXMLParser : NSObject <NSXMLParserDelegate> {

}

- (void) parseData:(NSData *)data; 

- (void) didFindString:(NSString *)string inElement:(NSString *)element;
- (void) didStartElement:(NSString *)element;
- (void) didEndElement:(NSString *)element;
- (void) abortParsing;

@end
