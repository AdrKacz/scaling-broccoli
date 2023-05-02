import { updateLeaderboard } from '../../../src/handlers/update-leaderboard.mjs';

import { DynamoDBDocumentClient, ScanCommand, PutCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb';
import { mockClient } from "aws-sdk-client-mock";
import 'aws-sdk-client-mock-jest';

describe('Test updateLeaderboard', function () { 
    const ddbMock = mockClient(DynamoDBDocumentClient);
 
    beforeEach(() => {
        ddbMock.reset();

        ddbMock
        .on(ScanCommand)
        .resolves({
            Items: [
                {name: 'A', score: 10, id: 'A'},
                {name: 'B', score: 8, id: 'B'},
                {name: 'C', score: 16, id: 'C'}
            ],
            LastEvaluatedKey: 'C'
        })
        .on(ScanCommand, {
            ExclusiveStartKey: 'C'
        })
        .resolves({
            Items: [
                {name: 'D', score: 32, id: 'D'},
                {name: 'E', score: 7, id: 'E'}
            ]
        });
      });
 
    it('should return only leaders if not ranked', async () => {  
        const event = { 
            httpMethod: 'POST', 
            body: JSON.stringify({name: 'F', score: 2}) 
        }; 
     
        const result = await updateLeaderboard(event); 
    
        // Compare the result with the expected result 
        expect(result.statusCode).toEqual(200);
        expect(JSON.parse(result.body).leaders).toEqual([
            {name: 'D', score: 32},
            {name: 'C', score: 16},
            {name: 'A', score: 10},
            {name: 'B', score: 8},
            {name: 'E', score: 7}
        ]);
        expect(JSON.parse(result.body).position).toEqual(0);
        expect(typeof JSON.parse(result.body).uuid).toBe("undefined");

        expect(ddbMock).toHaveReceivedCommandTimes(ScanCommand, 2);
        expect(ddbMock).toHaveReceivedCommandTimes(PutCommand, 0);
        expect(ddbMock).toHaveReceivedCommandTimes(DeleteCommand, 0);
    });

    it('should insert and delete if ranked and full', async () => {  
        const event = { 
            httpMethod: 'POST', 
            body: JSON.stringify({name: 'F', score: 64}) 
        }; 
     
        const result = await updateLeaderboard(event); 
    
        // Compare the result with the expected result 
        expect(result.statusCode).toEqual(200);
        expect(JSON.parse(result.body).leaders).toEqual([
            {name: 'F', score: 64},
            {name: 'D', score: 32},
            {name: 'C', score: 16},
            {name: 'A', score: 10},
            {name: 'B', score: 8}
        ]);
        expect(JSON.parse(result.body).position).toEqual(1);
        expect(typeof JSON.parse(result.body).uuid).toBe("string");

        expect(ddbMock).toHaveReceivedCommandTimes(ScanCommand, 2);

        expect(ddbMock).toHaveReceivedCommandTimes(PutCommand, 1);

        expect(ddbMock).toHaveReceivedCommandTimes(DeleteCommand, 1);
        expect(ddbMock).toHaveReceivedCommandWith(DeleteCommand, {
            TableName: 'LeaderboardTable',
            Key: { id: 'E' }
        });
    });
}); 