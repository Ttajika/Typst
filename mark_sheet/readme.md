# TypstとFormScannerで作るマークシート試験


すべてフリーソフトで完結するマークシート式試験の作り方です．

- 回答用紙の印刷は普通紙ででき，特別なマークシートは不要です．
- 市販のソフト・マークシートを使用する場合とほとんど手間は変わらないかと思います．
    - 問題・解答作成は自動連番なのでこちらのほうが省力化できる可能性があります
    - Win/Mac両方に対応しています
- 本ガイドラインとテンプレートは日本大学経済学部での使用を想定していますが，学籍番号の形式とスキャナの設置場所に関する部分のみ所属機関特有のものですので，他機関で利用される場合はこれらを適宜変更してください．

## 試験作成・採点方法

- 試験作成・採点の流れは以下のとおりです
1. Typstで試験とマークシートを作成する．テンプレートは以下をご覧ください．
    - Typstとテンプレートについて
        - Typstは現代的な汎用組版ソフトです．TeXの代替として期待されています.
        - [[マーク式試験テンプレファイル](https://typst.app/project/rI6YUx8eQIafMKP0hRZ1B6)]: [使い方動画](https://vimeo.com/1048093765/d2a2838aac) （テンプレファイルのリンクをクリックして利用してください）               
            - テンプレファイルの特徴
                - 問題番号の自動連番
                - 下線部，空白部の自動連番
                - 数式を扱える
                - 正答マークシートなどを自動で作成できる
            - Typstのより詳細な[解説記事](https://qiita.com/tomoyatajika/items/649884befe95c5f1dcea)
            - [[その他のTypstの解説記事](https://typst-jp.github.io/docs/japanese/articles/)]
        - Typstアプリの読み込みが遅い場合はキャッシュを削除してください
        - その他，ローカルにもインストールできます  (VSCodeでTinymistという拡張機能をダウンロードする方法が一番簡単です)
2. マークシートと試験問題を印刷して試験を行う
    - マークシートの印刷は普通紙でOKです
3. 回答されたマークシート，正答マークシート，配点マークシート，採点パターンマークシートをスキャナでスキャンする
    - スキャナは8号館5階の複合機でうまく作動しました
        
        ※スキャン時は以下の条件を満たすと精度が安定します：
        
        - 解像度：150dpi〜300dpi
        - カラー設定：グレースケール or 白黒（デフォルトから変更しなくてOK）
        - 拡大縮小：なし（100%実寸印刷された用紙をスキャン）
        - 傾きがあると読み取りミスが増えるため、原稿はまっすぐセットしてください
    - 8号館5階の複合機はコンピューターセンターにメールすると使えるようになります．
4. スキャンしたものはPDFファイルとして出力されるので，これを画像ファイルに変換する．
    - 変換方法
        - [[採点プログラムのコード(Google Colab)](https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing)]（Googleでのログインが必要です）を使って変換してください．adobeのツールでも変換可能ですが，どうやら見栄えを良くするために勝手に画像をいじるので挙動が安定しません．
5. マークシートの画像を[FormScanner](https://sites.google.com/site/examgrader/formscanner?authuser=0)でマークシートをスキャンする．[[FormScannerのダウンロードページ](https://sourceforge.net/projects/formscanner/files/1.1.3/)]・[[解説動画](https://vimeo.com/1048086452/f0d36686ca?share=copy)]・[[解説記事](https://harucharuru.hatenablog.com/entry/2020/01/14/182020)]
    - 注意：FormScannerの設定について：
        - 学籍番号：列ごとに設定（設問グループ名は「ID」としてください）
        - 初回のみ読み取り枠を設定する必要があります
        - ※設定の詳細は[[解説動画](https://vimeo.com/1048086452/f0d36686ca?share=copy)]を参照してください（採点プログラムと整合的にするための設定があります）
    - FormScannerのダウンロード方法
        
        (FormScannerの起動には [javaのダウンロードも必要です](https://www.java.com/en/download/))
        
        windows userは exeファイルを，mac userはdmgファイルをダウンロードしてください
        
  
        
6. FormScannerを使って生成されたcsvを採点プログラムで採点する
    - 以下のファイルをダウンロードしてクリックしてください．生成されたcsvファイルを入力することで，採点結果のファイルが生成されます
        
        [採点アプリ.html](Typst%E3%81%A8FormScanner%E3%81%A6%E3%82%99%E4%BD%9C%E3%82%8B%E3%83%9E%E3%83%BC%E3%82%AF%E3%82%B7%E3%83%BC%E3%83%88%E8%A9%A6%E9%A8%93%2017f5c78ee3bc800fabfcdf75adbcc1f3/%E6%8E%A1%E7%82%B9%E3%82%A2%E3%83%95%E3%82%9A%E3%83%AA.html)
        
    - 回答や配点は正答マークシートなどを読み取ることで採点できるのでエクセルなどへの記入の必要はありません．
    - Python版[[採点プログラムのコード(Google Colab)](https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing)]（Googleでのログインが必要です） [[使い方の動画](https://vimeo.com/1048086557/dac65e751d)]

