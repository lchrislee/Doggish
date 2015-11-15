//USERS
case 'create':
dynamo.putItem(event, context.succeed('create') );
{
  "operation": "create",
  "TableName": "Users",
  "Item": {
    "ID":"1",
    "name": "name2",
    "Email": "email1",
    "points":"0",
    "level":"1",
    "zipCode":"90007",
    "imageUrl":"imageUrl1"
  }
}

case 'read':
{

	"operation": "read",
	"TableName": "Users",
	"Key":{
		"ID":"1"
	},
	"AttributesToGet": [
      "name"
    ]
}

case 'read':
{

	"operation": "list",
	"TableName": "MapMarker",
}

case 'update'
{
	"operation": "update",
	"TableName": "Users",
    "Key": {
        "ID": "1"
    },
    "ExpressionAttributeNames":{ "#n": "name" },
    "UpdateExpression": "SET #n = :val",
    "ExpressionAttributeValues": { 
        ":val": "new name"
    },
    "ReturnValues": "UPDATED_NEW"
    //don't need to return
}



