#!/usr/bin/env bash

main() {
    wwwroot="AspireAWSExample.Web/bin/Release/net8.0/publish/wwwroot"

    # プロジェクトルートをカレントディレクトリに設定
    cd "${script_dir_path}/../"

    info AspireAWSExample.Web を publish...
    rm -rf "${wwwroot}"
    dotnet publish AspireAWSExample.Web

    info API Gateway の URL を appsettings.json に書き込み ※TODO: ApiBaseUrl のみ書き換え
    api_gateway_url=$(get_api_gateway_url)
    echo "{\"ApiBaseUrl\":\"${api_gateway_url}\"}" > "${wwwroot}/appsettings.json"

    info ${bucket_name} に ${wwwroot} をアップロード...
    bucket_id=$(get_bucket_id)
    aws s3 sync ${wwwroot} s3://${bucket_id}/ --delete

    # # スタック名と論理バケットIDから物理バケットIDを取得
    # bucket_id=$(aws cloudformation describe-stack-resource \
    #     --stack-name ${stack_name} \
    #     --logical-resource-id ${bucket_name} \
    #     --query "StackResourceDetail.PhysicalResourceId" \
    #     --output text)

    # log ${bucket_name} に ${bucket_src} を同期...
    # aws s3 sync ${www} s3://${bucket_id}/ --delete
}

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/___run_main.sh"
