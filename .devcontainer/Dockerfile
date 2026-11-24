# 原稿側の薄い層。土台は texlive-ja イメージ側で管理する。
#
# ★ 新しいプロジェクトを始めたら、タグが古くないか確認すること
#    最新タグ: https://github.com/norak29/texlive-ja/pkgs/container/texlive-ja
FROM ghcr.io/norak29/texlive-ja:2026.11.23

# --- 緊急避難用の追加枠 -------------------------------------------
# 締切前に「このパッケージが無い」と気づいたときは、ここに足して
# Dev Containers: Rebuild Container すれば数十秒で入る。
# イメージ本体の再ビルドを待たなくてよい。
# 落ち着いたら texlive-ja 側の texlive.profile に移し、ここは消す。
#
# RUN tlmgr install <パッケージ名>
