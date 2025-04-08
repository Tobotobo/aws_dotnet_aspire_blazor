#!/usr/bin/env bash

main() {
    # プロジェクトルートをカレントディレクトリに設定
    cd "${script_dir_path}/../"

    # スタック名と論理バケットIDから物理バケットIDを取得
    bucket_id=$(get_bucket_id 2>/dev/null || true)

    # バケットが存在する場合は中身を削除
    if [[ -n "$bucket_id" ]]; then
        info ${bucket_id} の中身を削除...
        aws s3 rm s3://${bucket_id} \
            --recursive
    fi

    info ${stack_name} スタックを削除...
    sam delete \
        --stack-name ${stack_name} \
        --s3-bucket ${bucket_name}
}

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/___run_main.sh"
