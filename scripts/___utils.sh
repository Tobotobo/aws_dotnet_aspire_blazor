get_api_gateway_id() {
    # スタック名と論理リソースIDから API Gateway ID を取得
    aws cloudformation describe-stack-resource \
        --stack-name ${stack_name} \
        --logical-resource-id ${api_gateway_name} \
        --query "StackResourceDetail.PhysicalResourceId" \
        --output text
}

get_api_gateway_url() {
    local api_gateway_id=$(get_api_gateway_id)
    # API Gateway の URL を返す
    echo "https://${api_gateway_id}.execute-api.${region}.amazonaws.com"
}

get_bucket_id() {
    # スタック名と論理バケットIDから物理バケットIDを取得
    aws cloudformation describe-stack-resource \
        --stack-name ${stack_name} \
        --logical-resource-id ${bucket_name} \
        --query "StackResourceDetail.PhysicalResourceId" \
        --output text
}

get_cloudfront_id() {
    # スタック名と論理リソースIDから CloudFront Distribution ID を取得
    aws cloudformation describe-stack-resource \
        --stack-name ${stack_name} \
        --logical-resource-id ${cloudfront_name} \
        --query "StackResourceDetail.PhysicalResourceId" \
        --output text
}

get_cloudfront_url() {
    local cloudfront_id=$(get_cloudfront_id)
    # Distribution ID から CloudFront のドメイン名を取得
    local domain_name=$(aws cloudfront get-distribution \
        --id ${cloudfront_id} \
        --query "Distribution.DomainName" \
        --output text)
    # CloudFront の URL を返す
    echo "https://${domain_name}"
}