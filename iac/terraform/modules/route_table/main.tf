resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.public_route_cidr
    gateway_id = var.igw_id 
    }

  tags = {
    Name = "${var.environment}-${var.project_name}-public-rt"
  }
}

resource "aws_route_table" "webview" {
  count = length(var.webview_subnet_ids)
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.environment}-${var.project_name}-webview-rt-${count.index}"
  }
}

resource "aws_route_table" "rdb" {
  count = length(var.rdb_subnet_ids)
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.environment}-${var.project_name}-rdb-rt-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "webview" {
  count         = length(var.webview_subnet_ids)
  subnet_id = var.webview_subnet_ids[count.index]
  route_table_id = aws_route_table.webview[count.index].id
}

resource "aws_route_table_association" "rdb" {
  count         = length(var.rdb_subnet_ids)
  subnet_id = var.rdb_subnet_ids[count.index]
  route_table_id = aws_route_table.rdb[count.index].id
}