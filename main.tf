module "dynamodb" {
    source = "./dynamodb"

    table_name = var.table_name
    hash_key = var.hash_key
}

module "lambda" {
    source = "./lambda"

    handler = var.handler
    function_name = var.function_name
}