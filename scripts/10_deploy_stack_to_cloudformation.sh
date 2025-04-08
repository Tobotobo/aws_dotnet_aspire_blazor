#!/usr/bin/env bash

main() {
    # プロジェクトルートをカレントディレクトリに設定
    cd "${script_dir_path}/../"

    info ${stack_name} をビルド...
    sam build --build-in-source

    info ${stack_name} をデプロイ...
    sam deploy \
        --stack-name ${stack_name} \
        --region ${region} \
        --capabilities CAPABILITY_IAM \
        --no-disable-rollback \
        --resolve-s3
}

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/___run_main.sh"
