# AWS Infrastructure for the Leaderboard

We used a Amazon DynamoDB, which is a key-value and document database that delivers single-digit millisecond performance at any scale.

![AWS Infrastructure](/LeaderboardAWS/photos/infrastructure.png)

To create the infrastructure, you need to follow this tutorial from AWS :
[Tutorial: Build a CRUD API with Lambda and DynamoDB](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-dynamo-db.html)

### You need to make some changes however :

* Change the DynamoDB name from `http-crud-tutorial-items` to `Leaderboard`
* Change the Lambda name from `http-crud-tutorial-function` to `LeaderboardLambda`
* Change the Lambda code from the tutorial to this one : 
```javascript
const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    switch (event.routeKey) {
      case "GET /items":
        body = await dynamo.scan({ TableName: "Leaderboard" }).promise();
        break;
      case "GET /add/{id}/{name}/{score}":
		await dynamo
			.put({
				TableName: "Leaderboard",
				Item: {
					id: event.pathParameters.id,
					name: event.pathParameters.name.toUpperCase(),
          score: event.pathParameters.score,
				}
			})
			.promise();
		body = `Put item ${event.pathParameters.id}`;
		break;
      default:
        throw new Error(`Unsupported route: "${event.routeKey}"`);
    }
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode,
    body,
    headers
  };
};
```

* Change the API Gateway name from `http-crud-tutorial-api` to `LeaderboardAPI`
* Create only two routes for the API Gateway:
	* `GET /items`
	* `GET /items/{id}/{name}/{score}`

To list the DB : 

`https://a6yssfdpd0.execute-api.eu-west-1.amazonaws.com/items`


To add an item :

`https://a6yssfdpd0.execute-api.eu-west-1.amazonaws.com/items/1/Jeff/3672`

To publish your game on itch.io you need to configure your API to add an Access-Control-Allow-Origin.

Go to the `API settings` and go to `CORS` and add the origin of the request made by itch.io during the game :

![CORS Origin](/LeaderboardAWS/photos/origin.png)

And it works !

PS : We only use the HTTP method GET because of [CORS errors](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) on itch.io.