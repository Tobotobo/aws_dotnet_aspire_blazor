# set -x # 実行したコマンドと引数も出力する
set -e # スクリプト内のコマンドが失敗したとき（終了ステータスが0以外）にスクリプトを直ちに終了する
set -E # '-e'オプションと組み合わせて使用し、サブシェルや関数内でエラーが発生した場合もスクリプトの実行を終了する
set -u # 未定義の変数を参照しようとしたときにエラーメッセージを表示してスクリプトを終了する
set -o pipefail # パイプラインの左辺のコマンドが失敗したときに右辺を実行せずスクリプトを終了する

# Bash バージョン 4.4 以上の場合のみ実行
if [[ ${BASH_VERSINFO[0]} -ge 4 && ${BASH_VERSINFO[1]} -ge 4 ]]; then
    shopt -s inherit_errexit # '-e'オプションをサブシェルや関数内にも適用する
fi

# 初期のカレントディレクトリを保存
initial_dir_path="$(pwd)"

# 呼び出し元のスクリプトがあるフォルダへのパス
script_dir_path="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"

# 呼び出し元のスクリプトのファイル名
script_file_name="$(basename "${BASH_SOURCE[1]}")"

# 文字に色を付ける　※例）echo "${red}あいうえお${reset}"
readonly red=$(printf '\033')[31m     # 赤
readonly green=$(printf '\033')[32m   # 緑
readonly yellow=$(printf '\033')[33m  # 黄
readonly blue=$(printf '\033')[34m    # 青
readonly magenta=$(printf '\033')[35m # マゼンタ
readonly cyan=$(printf '\033')[36m    # シアン
readonly reset=$(printf '\033')[00m   # リセット

# ログを表示する　※装飾無し用
function log() {
    echo "$(date +"%Y/%m/%d %H:%M:%S") $@"
}

# 情報メッセージを表示する
function info() {
    echo "${cyan}$(date +"%Y/%m/%d %H:%M:%S") [INFO] $@${reset}"
}

# 警告メッセージを表示する
function warn() {
    echo "${yellow}$(date +"%Y/%m/%d %H:%M:%S") [WARN] $@${reset}"
}

# 成功メッセージを表示する
function ok() {
    echo "${green}$(date +"%Y/%m/%d %H:%M:%S") [OK] $@${reset}"
}

# 成功メッセージを表示する
function success() {
    echo "${green}$(date +"%Y/%m/%d %H:%M:%S") [SUCCESS] $@${reset}"
}

# エラーメッセージを表示する
function error() {
    echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [ERROR] $@${reset}" >&2
}

# 失敗メッセージを表示する　※表示のみでエラーは発生させない
function ng() {
    echo "${red}$(date +"%Y/%m/%d %H:%M:%S") [NG] $@${reset}" >&2
}

# 指定の文言で y/n の入力を取得する
# 戻り値: y = 0, n = 1
# y/n 以外の入力は再入力を求める
function confirm_yes_no {
    while true; do
        echo -n "${magenta}$(date +"%Y/%m/%d %H:%M:%S") [CONFIRM] $*${reset}"
        read ans
        case $ans in
        [Yy]*)
            return 0
            ;;
        [Nn]*)
            return 1
            ;;
        *)
            echo "${red}y または n を入力してください。${reset}"
            ;;
        esac
    done
}

# -y オプションで実行確認をスキップ可能に
disabled_confirm_yes_no=0
for arg in "$@"; do
    case $arg in
    -y)
        disabled_confirm_yes_no=1
        ;;
    esac
done

# 実行確認
if ((!disabled_confirm_yes_no)) && (! confirm_yes_no "${script_file_name} を実行します。よろしいですか？ [y/n]: "); then
    info "実行を中止しました。"
    exit 0
fi

# スクリプト終了時に初期のカレントディレクトリに戻るよう設定
on_exit() {
    cd "${initial_dir_path}"
}
trap on_exit EXIT

# エラー発生時にスタックトレースを表示
raised_err_msg=""
raised_err_skip=1
on_error() {
    local err_command=${BASH_COMMAND}
    if [[ $raised_err_msg != "" ]]; then
        err_command=${raised_err_msg}
    fi
    local -a stack=("")
    local stack_size=${#FUNCNAME[@]}
    local -i i
    for ((i = ${raised_err_skip}; i < stack_size; i++)); do
        local func="${FUNCNAME[$i]:-(top level)}"
        local -i line="${BASH_LINENO[$((i - 1))]}"
        local src="${BASH_SOURCE[$i]:-(no file)}"
        stack+=("  at $func $src:$line")
    done
    (
        IFS=$'\n'
        error "${err_command}${stack[*]}"
    )
}
trap on_error ERR

# エラーを発生させる　※例）raise 〇〇の処理に失敗しました。
function raise() {
    raised_err_msg=$@
    return 1
}

function assert() {
    local args="$@"
    test "$@" || raise "assert ${args}" 2
}

# 呼び出し元のスクリプトフォルダにカレントディレクトリを設定
cd "${script_dir_path}"

# ___set_env.sh が存在する場合は読込み
if [[ -f "___set_env.sh" ]]; then
    set -a
    source ___set_env.sh
    set +a
fi

# .env ファイルが存在する場合は読込み
if [[ -f ".env" ]]; then
    set -a
    source .env
    set +a
fi

# 上のフォルダ(プロジェクトルートの想定)に .env ファイルが存在する場合は読込み
if [[ -f "../.env" ]]; then
    set -a
    source ../.env
    set +a
fi

# ___utils.sh が存在する場合は読込み
if [[ -f "___utils.sh" ]]; then
    source ___utils.sh
fi

# main 処理実行
main

# 実行完了
success "${script_file_name} の実行が完了しました。"