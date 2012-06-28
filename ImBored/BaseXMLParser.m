//
//  BaseXMLParser.m
//  ImBored
//
//  Created by Amy Dyer on 4/9/12.
//  Copyright (c) 2012 Intuit. All rights reserved.
//

#import "BaseXMLParser.h"

@interface BaseXMLParser () {
@private
    NSMutableString * _currentString;
    NSXMLParser * _parser;
}

@end

@implementation BaseXMLParser

- (void) dealloc {
    [_parser release];
    [_currentString release];
}

#pragma mark - NSXMLParserDelegate methods

- (void) parseData:(NSData *)data {
    _parser = [[NSXMLParser alloc] initWithData:data];
    _parser.delegate = self;
    
    [_parser parse];
    
    [_parser release];
    _parser = nil;
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
    _currentString = [[NSMutableString alloc] init];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    [_currentString setString:@""];
    [self didStartElement:elementName];
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_currentString appendString:string];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [self didFindString:_currentString inElement:elementName];
    [self didEndElement:elementName];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    [_currentString release];
    _currentString = nil;
}

- (void) abortParsing {
    [_parser abortParsing];
}

#pragma mark - Abstract Methods

- (void) didStartElement:(NSString *)element {
}

- (void) didFindString:(NSString *)string inElement:(NSString *)element {
}

- (void) didEndElement:(NSString *)element {
}


@end
