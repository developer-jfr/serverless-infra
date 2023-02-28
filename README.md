## Serverless Architecture
-------
#### Used tools + AWS Services
* API Gateway
* Lambda Function
* Dynamo DB
* Terraform
-------
### Instructions to run 
    terraform init
    terraform plan  
    terraform apply

### After successfully creating a infrastructure will be printed a url where you can test the api
--------
## Endpoints

    Get /health -->  to know if the server up and running
    Get /products -->  get all products in a database
    Get /product?productId=some_id --> get specific product
    POST /product --> creating product
    {
        "productId": "1223",
        "productName": "hello world",
        "price": 23213
        "color": "red",
        "inventory": 123
    }

    PATCH /product ---> updating specific field 
    {  
         "productId": "1223",
        "updateKey": "inventory",
        "updateValue": 32432
    }
    DELETE /product --> deleting
    {
        "productId": "1223"
    }