# DynamoDB

## Create a table

In the AWS Console, select the `DynamoDB` service. On the left hand side, select `Tables`. On the right hand side,
click on `Create Table`

- Table name: `UniTestTable`
- Partition key: `id` (type: `number`)
- Sort key: leave it empty
- Table settings: leave `Default Settings`

At the bottom, click on `Create Table`.

## Work with the table using PartiQL

Under the DynamoDB service, on the left hand side, select `PartiQL editor`. Run the following queries one by one:

Insert items:

```SQL
INSERT INTO UniTestTable
VALUE {'id':1, 'a':'a1', 'b':'b1'}
```

```SQL
INSERT INTO UniTestTable
VALUE {'id':2, 'a':'a2', 'c':'c2'}
```

```SQL
INSERT INTO UniTestTable
VALUE {'id':3, 'a':'a3', 'd':'d3'}
```

```SQL
INSERT INTO UniTestTable
VALUE {'id':4, 'a':'a4', 'x': 'x4'}
;
```

Query by id:

```SQL
SELECT *
  FROM UniTestTable
 WHERE id = 2
```

Query items having a specific attribute:

```SQL
SELECT *
  FROM UniTestTable
 WHERE x IS NOT MISSING
```

Update an item:

```SQL
UPDATE UniTestTable
   SET c = 'qqq'
 WHERE id = 3
```

Using functions:

```SQL
SELECT *
  FROM UniTestTable
 WHERE begins_with(c,'q')
```

Insert more data:

```SQL
INSERT INTO UniTestTable
VALUE {'id':15, 'nested': {'x': 'x15', 'vals': ['b' ,'c','d']}}
```

```SQL
INSERT INTO UniTestTable
VALUE {'id':16, 'nested': {'x': 'x16', 'vals': ['a' ,'b','c']}}
```

```SQL
SELECT id, nested.x, nested.vals[0]
FROM UniTestTable
WHERE nested.vals is not missing
```

## Delete the table

Select the table under the `DyanmoDB` service. Click `Actions`, then `Delete table`.
