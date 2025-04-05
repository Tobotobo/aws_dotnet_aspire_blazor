#!/usr/bin/env bash

# set -x # 実行したコマンドと引数も出力する
set -e # スクリプト内のコマンドが失敗したとき（終了ステータスが0以外）にスクリプトを直ちに終了する
set -E # '-e'オプションと組み合わせて使用し、サブシェルや関数内でエラーが発生した場合もスクリプトの実行を終了する
set -u # 未定義の変数を参照しようとしたときにエラーメッセージを表示してスクリプトを終了する
set -o pipefail # パイプラインの左辺のコマンドが失敗したときに右辺を実行せずスクリプトを終了する

# Bash バージョン 4.4 以上の場合のみ実行
if [[ ${BASH_VERSINFO[0]} -ge 4 && ${BASH_VERSINFO[1]} -ge 4 ]]; then
    shopt -s inherit_errexit # '-e'オプションをサブシェルや関数内にも適用する
fi

# Getting started with the AWS CDK
# https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html
npm install -g aws-cdk

# C# による Lambda 関数の構築
# https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-csharp.html
dotnet new install Amazon.Lambda.Templates
dotnet tool install -g Amazon.Lambda.Tools

# .NET .NET Aspire テンプレート
# https://learn.microsoft.com/ja-jp/dotnet/aspire/fundamentals/aspire-sdk-templates?pivots=visual-studio
dotnet new install Aspire.ProjectTemplates