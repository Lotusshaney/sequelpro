//
//  $Id: QKSelectQueryOrderByTests.m 3732 2012-07-18 11:24:06Z stuart02 $
//
//  QKSelectQueryOrderByTests.m
//  QueryKit
//
//  Created by Stuart Connolly (stuconnolly.com) on February 25, 2012
//  Copyright (c) 2012 Stuart Connolly. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "QKSelectQueryOrderByTests.h"
#import "QKTestConstants.h"

@implementation QKSelectQueryOrderByTests

#pragma mark -
#pragma mark Initialisation

+ (id)defaultTestSuite
{
    SenTestSuite *testSuite = [[SenTestSuite alloc] initWithName:NSStringFromClass(self)];
	
	[self addTestForDatabase:QKDatabaseUnknown withIdentifierQuote:EMPTY_STRING toTestSuite:testSuite];
	[self addTestForDatabase:QKDatabaseMySQL withIdentifierQuote:QKMySQLIdentifierQuote toTestSuite:testSuite];
	[self addTestForDatabase:QKDatabasePostgreSQL withIdentifierQuote:QKPostgreSQLIdentifierQuote toTestSuite:testSuite];
	
    return [testSuite autorelease];
}

+ (void)addTestForDatabase:(QKQueryDatabase)database withIdentifierQuote:(NSString *)quote toTestSuite:(SenTestSuite *)testSuite
{		
    for (NSInvocation *invocation in [self testInvocations]) 
	{
		SenTestCase *test = [[QKSelectQueryOrderByTests alloc] initWithInvocation:invocation database:database identifierQuote:quote];
		
		[testSuite addTest:test];
		
        [test release];
    }
}

#pragma mark -
#pragma mark Setup

- (void)setUp
{
	QKQuery *query = [QKQuery selectQueryFromTable:QKTestTableName];
	
	[query setQueryDatabase:[self database]];
	[query setUseQuotedIdentifiers:[self identifierQuote] && [[self identifierQuote] length] > 0];
	
	[query addField:QKTestFieldOne];
	[query addField:QKTestFieldTwo];
	
	[self setQuery:query];
}

#pragma mark -
#pragma mark Tests

- (void)testSelectQueryTypeIsCorrect
{
	STAssertTrue([[[self query] query] hasPrefix:@"SELECT"], nil);
}

- (void)testSelectQueryOrderByAscendingIsCorrect
{	
	[[self query] orderByField:QKTestFieldOne descending:NO];
		
	NSString *query = [NSString stringWithFormat:@"ORDER BY %1$@%2$@%1$@ ASC", [self identifierQuote], QKTestFieldOne];
	
	STAssertTrue([[[self query] query] hasSuffix:query], nil);
}

- (void)testSelectQueryOrderByMultipleFieldsAscendingIsCorrect
{	
	[[self query] orderByField:QKTestFieldOne descending:NO];
	[[self query] orderByField:QKTestFieldTwo descending:NO];
		
	NSString *query = [NSString stringWithFormat:@"ORDER BY %1$@%2$@%1$@ ASC, %1$@%3$@%1$@ ASC", [self identifierQuote], QKTestFieldOne, QKTestFieldTwo];
	
	STAssertTrue([[[self query] query] hasSuffix:query], nil);
}

- (void)testSelectQueryOrderByDescendingIsCorrect
{	
	[[self query] orderByField:QKTestFieldOne descending:YES];
	
	NSString *query = [NSString stringWithFormat:@"ORDER BY %1$@%2$@%1$@ DESC", [self identifierQuote], QKTestFieldOne];
	
	STAssertTrue([[[self query] query] hasSuffix:query], nil);
}

- (void)testSelectQueryOrderByMultipleFieldsDescendingIsCorrect
{	
	[[self query] orderByField:QKTestFieldOne descending:YES];
	[[self query] orderByField:QKTestFieldTwo descending:YES];
	
	NSString *query = [NSString stringWithFormat:@"ORDER BY %1$@%2$@%1$@ DESC, %1$@%3$@%1$@ DESC", [self identifierQuote], QKTestFieldOne, QKTestFieldTwo];
	
	STAssertTrue([[[self query] query] hasSuffix:query], nil);
}

@end
