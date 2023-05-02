// Create clients and set shared const values outside of the handler.

// Create a DocumentClient that represents the query to add an item
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, ScanCommand } from '@aws-sdk/lib-dynamodb';
const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

// Get the DynamoDB table name from environment variables
const LEADERBOARD_TABLE = process.env.LEADERBOARD_TABLE;
const MAXIMUM_SIZE = parseInt(process.env.MAXIMUM_SIZE, 10);
const LEADERS_SIZE = parseInt(process.env.LEADERS_SIZE, 10);

/**
 * Get leaderboard a player position if uuid is provided
 * Set uuid to "none" to not get a player position
 * Will return position to 0 if player is not ranked
 * {
 * "uuid": "1234"
 * }
 */
export const getLeaderboard = async (event) => {
    if (event.httpMethod !== 'GET') {
        throw new Error(`getMethod only accept GET method, you tried: ${event.httpMethod}`);
      }
    // All log statements are written to CloudWatch
    console.info('received:', event);

    // Get id from pathParameters from APIGateway because of `/{uuid}` at template.yaml
    const uuid = event.pathParameters.uuid;
    if (typeof uuid !== 'string') {
        throw new Error('uuid must be a string'); 
    }

    // get all items
    const items = await getAllItems(LEADERBOARD_TABLE);

    // sort items by score descending
    items.sort((a, b) => b.score - a.score);

    // get player position
    let playerIndex = uuid === 'none' ? -1 : items.findIndex(item => item.id === uuid);

    // check if player is ranked
    if (playerIndex >= MAXIMUM_SIZE) {
        playerIndex = -1;
    }

    const response = {
        statusCode: 200,
        body: JSON.stringify({
            leaders: items.slice(0, LEADERS_SIZE).map(item => ({ name: item.name, score: item.score })),
            position: playerIndex + 1 
        })
    };

    console.info(`response from: ${event.path} statusCode: ${response.statusCode} body: ${response.body}`);
    return response;
};

export const getAllItems = async (tableName) => {
    const data = await ddbDocClient.send(new ScanCommand({
        TableName: tableName
    }));
    const items = data.Items;

    let lastEvaluatedKey = data.LastEvaluatedKey;
    while (typeof lastEvaluatedKey !== 'undefined') {
        const data = await ddbDocClient.send(new ScanCommand({
            TableName: tableName,
            ExclusiveStartKey: lastEvaluatedKey
        }));

        items.push(...data.Items);
        lastEvaluatedKey = data.LastEvaluatedKey;
    }

    return items
}