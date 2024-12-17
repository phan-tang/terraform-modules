module "dynamodb" {
  source = "./dynamodb"
  
  table_name = var.table_name
  hash_key = var.hash_key
}