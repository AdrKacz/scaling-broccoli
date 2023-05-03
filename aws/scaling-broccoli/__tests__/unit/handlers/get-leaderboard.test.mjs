import { getLeaderboard } from '../../../src/handlers/get-leaderboard.mjs'; 

import { DynamoDBDocumentClient, ScanCommand } from '@aws-sdk/lib-dynamodb';
import { mockClient } from "aws-sdk-client-mock";
import 'aws-sdk-client-mock-jest';
 
describe('Test getLeaderboard', () => { 
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
 
    it('should get leaders only if uuid is none', async () => {   
        const event = { 
            httpMethod: 'GET', 
            pathParameters: { 
                uuid: 'none' 
            } 
        };
 
        // Invoke getByIdHandler() 
        const result = await getLeaderboard(event); 
 
        // Compare the result with the expected result 
        expect(result).toEqual({ 
            statusCode: 200, 
            body: JSON.stringify({
                leaders: [
                    {name: 'D', score: 32},
                    {name: 'C', score: 16},
                    {name: 'A', score: 10},
                    {name: 'B', score: 8},
                    {name: 'E', score: 7}
                ],
                position: 0
            })
        });

        expect(ddbMock).toHaveReceivedCommandTimes(ScanCommand, 2);
    }); 

    it('should get leaders and position', async () => {   
        const event = { 
            httpMethod: 'GET', 
            pathParameters: { 
                uuid: 'A' 
            } 
        };
 
        // Invoke getByIdHandler() 
        const result = await getLeaderboard(event); 
 
        // Compare the result with the expected result 
        expect(result).toEqual({ 
            statusCode: 200, 
            body: JSON.stringify({
                leaders: [
                    {name: 'D', score: 32},
                    {name: 'C', score: 16},
                    {name: 'A', score: 10},
                    {name: 'B', score: 8},
                    {name: 'E', score: 7}
                ],
                position: 3
            }) 
        });

        expect(ddbMock).toHaveReceivedCommandTimes(ScanCommand, 2);
    }); 
}); 
 