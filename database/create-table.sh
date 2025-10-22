#!/bin/bash

# AWS CLI command to create DynamoDB table for Users
aws dynamodb create-table \
    --table-name Users \
    --attribute-definitions \
        AttributeName=username,AttributeType=S \
    --key-schema \
        AttributeName=username,AttributeType=HASH \
    --provisioned-throughput \
        ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-1

echo "DynamoDB table 'Users' created successfully!"
