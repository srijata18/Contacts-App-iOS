
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ToDoItem.h"


@interface DBAccess : NSObject {
	sqlite3* database;
}

-(BOOL) createToDo:(ToDoItem*) item;

-(NSMutableArray*) getAllToDo;
-(BOOL) deleteToDoWithTitle:(NSString*) title;
-(void) closeDatabase;

- (BOOL)initializeDatabase;

@end


