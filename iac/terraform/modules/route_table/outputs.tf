output "webview_route_table_ids" {
    value = aws_route_table.webview[*].id
}

output "rdb_route_table_ids" {
    value = aws_route_table.rdb[*].id
}