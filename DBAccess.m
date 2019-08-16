#import "DBAccess.h"



#define kDatabaseName @"todo"
#define kDatabaseFullName @"todo.db"

@implementation DBAccess

-(id) init
{
	database = NULL;
	
    if ((self = [super init]))
    {
		//Initialize the Database
        [self initializeDatabase];
    }
    return self;
}

/**
 This method opens the database that exists in the resource bundle
 */
- (BOOL) initializeDatabase {

	if (database) return YES;
	
	NSArray *paths = 
			NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
												NSUserDomainMask, 
												YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = 
			[documentsDirectory stringByAppendingPathComponent:kDatabaseFullName];

	
    NSFileManager* filemanager = [NSFileManager defaultManager];
 	
    if (![filemanager fileExistsAtPath:writableDBPath]) {
		
        NSString* resourceDBPath = 
				[[NSBundle mainBundle] pathForResource:kDatabaseName ofType:@"db"];
 
        if ([filemanager fileExistsAtPath:resourceDBPath]) {
            [filemanager copyItemAtPath:resourceDBPath 
								 toPath:writableDBPath 
								  error:NULL];
        }
		else {
			NSLog(@"Database %@ does not exists in resources", kDatabaseFullName);
			return FALSE;
		}

    }
	
//	[filemanager release];
    filemanager = nil;
	int success = sqlite3_open([writableDBPath UTF8String], &database);
	if (success == SQLITE_OK) 
	{
		NSLog(@"Successfully Opened Database = %@", writableDBPath);
		return YES;
	} 
	else 
	{
		sqlite3_close(database);
		NSLog(@"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
		
	return NO;
}

-(void) closeDatabase
{
    if (sqlite3_close(database) != SQLITE_OK) {
        NSLog(@"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
	database = NULL;
}


- (NSMutableArray*) getAllToDo
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    //  SQL Query to read all project records
	NSString* sqlStr = [NSString stringWithFormat:@"SELECT * FROM todo"];
	
	const char *sql = [sqlStr cStringUsingEncoding:NSASCIIStringEncoding];
	
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program 
	// in the SQLite library.
    int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	
    if ( sqlResult == SQLITE_OK) {
		
        // We step through the results - once for each row.
        while (sqlite3_step(statement) == SQLITE_ROW) {
			
            ToDoItem* item = [[ToDoItem alloc] init];
            
			//Read column data for a record
			int ID = sqlite3_column_int(statement, 0);
            char *title = (char *)sqlite3_column_text(statement, 1);
           
			NSString* strTitle = (title) ? [NSString stringWithUTF8String:title] : @"";

            item.title = strTitle;
            
            //read priority from the column index 2
            int priority = sqlite3_column_int(statement, 2);
            
            item.priority = priority;
            
            //inser the item to the items array
            [items addObject:item];
            
        }
        
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"Problem with the database:");
        NSLog(@"%d",sqlResult);
    }   
    return items;
}





-(BOOL) createToDo:(ToDoItem *)item {
	NSString* sqlStr = [NSString stringWithFormat:@"INSERT INTO todo  \
												    ( \"title\" ) \
						                            VALUES (\"%@\")", 
													item.title];
    
	
	//Convert the NSString to C string as sqlite only understands c strings.
    NSLog(@"%@", sqlStr);
    const char *sql = [sqlStr cStringUsingEncoding:NSASCIIStringEncoding];
	
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	
    BOOL inserted = NO;
    if ( sqlResult== SQLITE_OK) {
        int success = sqlite3_step(statement);
        if(success == SQLITE_DONE)
        {
            NSLog(@"ToDo inserted successfully");
            inserted = YES;
        }    
        else
        {
            NSLog(@"ToDo insert FAILED");
        }
    }
    
    return inserted;
	
}

-(BOOL) deleteCountryWithName:(NSString*) name
{
	NSString* sqlStr = [NSString stringWithFormat:@"delete from country  \
                        where name = \"%@\"", name];

	
	//Convert the NSString to C string as sqlite only understands c strings.
    NSLog(@"%@", sqlStr);
    const char *sql = [sqlStr cStringUsingEncoding:NSASCIIStringEncoding];
	
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	
    BOOL deleted = NO;
    if ( sqlResult== SQLITE_OK) {
        int success = sqlite3_step(statement);
        if(success == SQLITE_DONE)
        {
            NSLog(@"Country deleted successfully");
//            inserted = YES;
        }    
        else
        {
            NSLog(@"Country delete FAILED");
        }
    }
    
    return deleted;


}



@end
