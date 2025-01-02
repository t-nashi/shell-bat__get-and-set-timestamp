#!/bin/bash

# 文字コードを日本語utf-8に変更
export LANG=ja_JP.UTF-8

# 変数定義 ##########
# --
# カレントディレクトリ（.commandファイル実行時）
CURRENT_DIR_PATH=$(cd $(dirname $0);pwd)
  # echo "・カレントディレクトリ： ${CURRENT}"

# メイン処理 start ########################################
# --
  echo -e "\n--コマンドstart--\n"

  # カレントディレクトリへ移動
  cd $CURRENT_DIR_PATH

  # 各種パスを設定
  GET_TIMESTAMP_DIR_PATH="${CURRENT_DIR_PATH}/01_getTimestamp" # タイムスタンプを取得したいファイルがあるフォルダのパス
  SET_TIMESTAMP_DIR_PATH="${CURRENT_DIR_PATH}/02_setTimestamp" # タイムスタンプを設定したいファイルがあるフォルダのパス
  OUT_FILE_FULL_PATH="${CURRENT_DIR_PATH}/02_setTimestamp.command"

  # 出力用変数
  OUT_VALUE=''

  # GET_TIMESTAMP_DIR_PATHの中のファイルに対して処理を実行
  for files in "$GET_TIMESTAMP_DIR_PATH"/*; do
    if [ -f "$files" ]; then

      # ファイルのタイムスタンプを取得
      timestamp=$(stat -f "%Sm" -t "%Y%m%d_%H%M%S" "$files")

      # ファイル名を取得
      fileName="$(basename "$files")"

      # ファイル名の拡張子を変換
      case "$fileName" in
        *.png) fileName="${fileName%.png}.webp" ;;
        *.jpg) fileName="${fileName%.jpg}.webp" ;;
        *.gif) fileName="${fileName%.gif}.webp" ;;
        *.MP4) fileName="${fileName%.MP4}.mp4" ;;
      esac

      # タイムスタンプ変更対象のファイルパス
      targetFileFullPath="${SET_TIMESTAMP_DIR_PATH}/${fileName}"

      # 出力用変数に追加
      OUT_VALUE+="touch -t \$(date -j -f \"%Y%m%d_%H%M%S\" \"$timestamp\" +\"%Y%m%d%H%M.%S\") \"$targetFileFullPath\"\n"

      # 処理対象のファイル名を出力
      echo "$(basename "$files")"

    fi
  done

  # 結果を出力ファイルに書き込む
  echo -e "$OUT_VALUE" > "$OUT_FILE_FULL_PATH"

  echo -e "\n--コマンドend--\n"
# --
# メイン処理 end ########################################

# プロセスを終了
# osascript -e 'tell application "Terminal" to close first window'
