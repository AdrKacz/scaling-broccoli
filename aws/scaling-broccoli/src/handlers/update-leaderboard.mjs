// Create clients and set shared const values outside of the handler.
import { randomUUID } from 'crypto';

// Create a DocumentClient that represents the query to add an item
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, ScanCommand, PutCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb';
const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

// Get the DynamoDB table name from environment variables
const LEADERBOARD_TABLE = process.env.LEADERBOARD_TABLE;
const MAXIMUM_SIZE = parseInt(process.env.MAXIMUM_SIZE, 10);
const LEADERS_SIZE = parseInt(process.env.LEADERS_SIZE, 10);

/**
 * Update leaderboard with a score and return it
 * Returns position to 0 if player is not ranked
 * {
 *  "name": "John Doe",
 *  "score": 100
 * }
 */
export const updateLeaderboard = async (event) => {
    if (event.httpMethod !== 'POST') {
        throw new Error(`postMethod only accepts POST method, you tried: ${event.httpMethod} method.`);
    }
    // All log statements are written to CloudWatch
    console.info('received:', event);

    // Get id and name from the body of the request
    const body = JSON.parse(event.body);
    const name = body.name;
    const score = body.score;

    if (typeof name !== 'string' || typeof score !== 'number') {
        throw new Error('name must be a string and score must be a number');
    }

    // get all items
    const items = await getAllItems(LEADERBOARD_TABLE);

    // sort items by score descending
    items.sort((a, b) => b.score - a.score);

    // check if too many items
    if (items.length >= MAXIMUM_SIZE) {
        const minItem = items[items.length - 1];
        if (minItem.score >= score) {
            // too many items and the lowest score is higher than the new score
            // do nothing
            const response =  {
                statusCode: 200,
                body: JSON.stringify({
                    leaders: items.slice(0, LEADERS_SIZE).map(item => ({ name: item.name, score: item.score })),
                    position: 0
                })
            };
            console.info(`response from: ${event.path} statusCode: ${response.statusCode} body: ${response.body}`);
            return response;
        }
    }

    // add item to the sorted list of items
    const index = sortedIndex(items, score);
    console.log(items)
    console.log(index)
    items.splice(index, 0, { name, score });
    console.log(items)

    // add item in the table
    const uuid = randomUUID()
    const putCommand = new PutCommand({
        TableName: LEADERBOARD_TABLE,
        Item: {
            id: uuid, // generate random id
            name,
            score
        }
    });
    
    // remove extra items from the table
    const extraItems = items.slice(MAXIMUM_SIZE);
    const deleteCommands = extraItems.map(item => new DeleteCommand({
        TableName: LEADERBOARD_TABLE,
        Key: { id: item.id }
    }));

    // send commands in parallel
    await Promise.all([putCommand, ...deleteCommands].map(command => ddbDocClient.send(command)));
    console.log(items)
    console.log(items.slice(0, LEADERS_SIZE))
    const response = {
        statusCode: 200,
        body: JSON.stringify({
            leaders: items.slice(0, LEADERS_SIZE).map(item => ({ name: item.name, score: item.score })),
            position: index + 1,
            uuid })
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

export const sortedIndex = (array, value) => {
    let low = 0;
    let high = array.length;

    while (low < high) {
        const mid = (low + high) >>> 1; // divide by 2
        if (array[mid].score > value) low = mid + 1;
        else high = mid;
    }
    return low;
}