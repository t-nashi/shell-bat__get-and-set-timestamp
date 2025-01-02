# 文字コードをUTF-8に設定
chcp 65001

# 本実行ファイルのディレクトリパスを取得
$currentDirPath = Convert-Path .

# 各種パスを設定
$getTimestampDirPath = $currentDirPath + '\01_getTimestamp' # タイムスタンプを取得したいファイルがあるフォルダのパス
$setTimestampDirPath = $currentDirPath + '\02_setTimestamp' # タイムスタンプを設定したいファイルがあるフォルダのパス
$outFileFullPath = $currentDirPath + '\02_setTimestamp.ps1'

# 出力用変数
$outValue = ''

#「作成日時」 「CreationTime」
#「更新日時」 「LastWriteTime」
#「アクセス日時」「LastAccessTime」

# 対象のフォルダ内のファイルに対して処理を実行
Get-ChildItem -Path $getTimestampDirPath -File | ForEach-Object {

  # ファイル名を取得
  $itemFileName = $_.Name
  # 拡張子を変更
  $itemFileName = $itemFileName -replace '\.png$', '.webp'
  $itemFileName = $itemFileName -replace '\.jpg$', '.webp'
  $itemFileName = $itemFileName -replace '\.gif$', '.webp'
  $itemFileName = $itemFileName -replace '\.MP4$', '.mp4'
  # ファイルフルパスを設定
  $targetFileFullPath = $setTimestampDirPath + '\' + $itemFileName

  # 「作成日時」を取得
  $lastCreationTimeFormattedDate = $_.CreationTime.ToString("yyyy/MM/dd HH:mm:ss")
  $outValue += "Set-ItemProperty $targetFileFullPath -name CreationTime -value ""$lastCreationTimeFormattedDate"""
  $outValue += "`r`n"

  # 「更新日時」を取得
  $lastWriteTimeFormattedDate = $_.LastWriteTime.ToString("yyyy/MM/dd HH:mm:ss")
  $outValue += "Set-ItemProperty $targetFileFullPath -name LastWriteTime -value ""$lastWriteTimeFormattedDate"""
  $outValue += "`r`n"
}

# ファイルに出力
$outValue | Out-File -FilePath ($outFileFullPath) # 上書き
# $outValue | Out-File -FilePath ($outFileFullPath) -Append # 追記

# 処理停止
# Pause
