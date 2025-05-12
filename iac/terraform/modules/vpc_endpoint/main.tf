resource "aws_vpc_endpoint" "webview_ecs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_ecs_agent" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_ecs_telemetry" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "webview_s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.webview_route_table_ids
}

resource "aws_vpc_endpoint" "webview_secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.webview_subnet_ids
  security_group_ids  = [var.vpce_security_group_id]
  private_dns_enabled = true
}