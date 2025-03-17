# DyanmoDB

In this exercise, we create a DynamoDB table, insert a few items and query the table. Alternatiely, you can
use the AWS console (web UI) to do the same.

When commands return scrollable output, use the arrow keys to scroll and `q` to exit.

## Create a table with a single attribute primary key

```Bash
aws dynamodb create-table \
--table-name TestTable \
--attribute-definitions AttributeName=id,AttributeType=S \
--key-schema AttributeName=id,KeyType=HASH \
--billing-mode PAY_PER_REQUEST
```

## List tables

```Bash
aws dynamodb list-tables
```

## Insert data into the table - `put-item`

Primary key must be unique. The `put-item` operation either creates a new item or replaces an existing item.

```Bash
aws dynamodb put-item \
--table-name TestTable \
--item '{"id": {"S": "1"}, "Attr1": {"S": "X"}, "Attr2": {"S": "Y"}}'
```

```Bash
aws dynamodb put-item \
--table-name TestTable \
--item '{"id": {"S": "2"}, "Attr2": {"S": "Z"}, "Attr3": {"S": "U"}}'
```

## Scan the table and list primary keys - `scan`

Scan operations access all itmes in the table.

```Bash
aws dynamodb scan \
--table-name TestTable \
--projection-expression "id"
```

Only output the IDs

```Bash
aws dynamodb scan \
--table-name TestTable \
--projection-expression "id" \
--query 'Items[*].id.S' \
--output table
```

## Get a single item by primary key - `get-item`

Only the individual item is accessed in the table.

```Bash
aws dynamodb get-item \
--table-name TestTable \
--key '{"id": {"S": "1"}}' | jq
```

## Delete table

```Bash
aws dynamodb delete-table --table-name TestTable
```

## Create a table with a compsite key

```Bash
aws dynamodb create-table \
--table-name TestTable \
--attribute-definitions AttributeName=id,AttributeType=S AttributeName=date,AttributeType=S \
--key-schema AttributeName=id,KeyType=HASH AttributeName=date,KeyType=RANGE \
--billing-mode PAY_PER_REQUEST
```

## Insert data into the table with composite key

```Bash
aws dynamodb put-item \
--table-name TestTable \
--item '{"id": {"S": "1"}, "date": {"S": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}, "note": {"S": "test-1"}}'
```

Execute the same command again. Note, that this table has a composite key of `id` and `date`. Although the `id` value
remains the same, the `date` attribute is going to be different since it comes from the current time. As a result,
a new item gets created.

Insert a couple more records with different id values. Have at least 4-5 items in the table. For example:

```Bash
aws dynamodb put-item \
--table-name TestTable \
--item '{"id": {"S": "2"}, "date": {"S": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}, "note": {"S": "test-2"}}'
```

```Bash
aws dynamodb put-item \
--table-name TestTable \
--item '{"id": {"S": "3"}, "date": {"S": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}, "note": {"S": "test-3"}}'
```

## Scan the table to see all items

```Bash
aws dynamodb scan --table-name TestTable
```

Make note of the `ScannedCound` value.

## Query data for a given id - `query`

Example query for `id=1`. There were two records inserted with this `id`. (Those two records have different `date`
values.)

Since we don't specify the entire composite key, we can't use `get-item`. We only specify part of the key (just `id`, but
not `date`), so we use `query` instead.

```Bash
aws dynamodb query \
--table-name TestTable \
--key-condition-expression "id = :id" \
--expression-attribute-values '{":id": {"S": "1"}}'
```

The query returns those two records and the `ScannedCount` value is 2.

## Get an exact item wih composite key

The below command is an example. You will need to update the timestamp.

```Bash
aws dynamodb get-item \
--table-name TestTable \
--key '{"id": {"S": "1"}, "date": {"S": "2025-03-16T11:11:29Z"}}' | jq
```

## Delete the table

```Bash
aws dynamodb delete-table --table-name TestTable
```
