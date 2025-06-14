English follows Japanese.
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
    - 回答や配点は正答マークシートなどを読み取ることで採点できるのでエクセルなどへの記入の必要はありません．
    - [[採点プログラムのコード(Google Colab)](https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing)]（Googleでのログインが必要です） [[使い方の動画](https://vimeo.com/1048086557/dac65e751d)]


# Creating a Multiple-Choice Exam with Typst and FormScanner

This is a guide on how to create a multiple-choice exam using only free software.

- You can print the answer sheets on plain paper; no special forms are required.
- The effort involved is comparable to using commercial software and mark sheets.
    - It may be more efficient as question and answer creation is automatically numbered.
    - It is compatible with both Windows and Mac.
- This guideline and template are intended for use at the Nihon University College of Economics. The only institution-specific parts are the student ID format and the scanner location. If you are using this at another institution, please modify these sections as needed.

## Exam Creation and Grading Method

The workflow for creating and grading the exam is as follows:

1.  **Create the exam and answer sheet using Typst.** Please see the template below.
    - **About Typst and the template:**
        - Typst is a modern, general-purpose typesetting system, seen as a promising alternative to TeX.
        - [[Multiple-Choice Exam Template File](https://typst.app/project/rI6YUx8eQIafMKP0hRZ1B6)]: [[Video Tutorial](https://vimeo.com/1048093765/d2a2838aac)] (Click the link to the template file to use it)
            - **Template Features:**
                - Automatic numbering of questions.
                - Automatic numbering for underlined sections and blanks.
                - Ability to handle mathematical formulas.
                - Automatic creation of the answer key mark sheet and more.
        - [More detailed article on Typst (in Japanese)](https://qiita.com/tomoyatajika/items/649884befe95c5f1dcea)
        - [[Other articles on Typst (in Japanese)](https://typst-jp.github.io/docs/japanese/articles/)]
    - If the Typst app is slow to load, please clear your cache.
    - You can also install it locally (the easiest way is to download the Tinymist extension in VSCode).

2.  **Print the answer sheets and exam questions and administer the test.**
    - Printing the answer sheets on plain paper is fine.

3.  **Scan the completed answer sheets, the answer key sheet, the point allocation sheet, and the grading pattern sheet.**
    - The multifunction printer on the 5th floor of Building 8 worked well.
        ※ Scanning accuracy is more stable under the following conditions:
        - **Resolution:** 150dpi to 300dpi
        - **Color Setting:** Grayscale or Black & White (the default setting is fine)
        - **Scaling:** None (scan the paper that was printed at 100% actual size)
        - **Set the documents straight**, as skewing can increase reading errors.
    - To use the multifunction printer on the 5th floor of Building 8, you need to email the Computer Center to get access.

4.  **The scanned output will be a PDF file. Convert this to image files.**
    - **How to convert:**
        - Please use the [[Grading Program Code (Google Colab)](https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing)] (Requires Google login) to convert the files. While Adobe tools can also convert them, they may automatically alter the images to improve appearance, leading to unstable behavior.

5.  **Scan the mark sheet images with [FormScanner](https://sites.google.com/site/examgrader/formscanner?authuser=0).** [[FormScanner Download Page](https://sourceforge.net/projects/formscanner/files/1.1.3/)] ・ [[Video Tutorial](https://vimeo.com/1048086452/f0d36686ca?share=copy)] ・ [[Instructional Article (in Japanese)](https://harucharuru.hatenablog.com/entry/2020/01/14/182020)]
    - **Note: Regarding FormScanner settings:**
        - **Student ID:** Set up column by column (use "ID" as the question group name).
        - You will need to set the reading frames for the first time.
        - ※ For detailed settings, please refer to the [[Video Tutorial](https://vimeo.com/1048086452/f0d36686ca?share=copy)] (there are specific settings to ensure compatibility with the grading program).
    - **How to download FormScanner:**
        (You also need to [download Java](https://www.java.com/en/download/) to run FormScanner)
        Windows users should download the .exe file, and Mac users should download the .dmg file.

6.  **Grade the CSV file generated by FormScanner using the grading program.**
    - Answers and point allocations can be graded by reading the answer key sheets, so there is no need to enter them into Excel or similar software.
    - [[Grading Program Code (Google Colab)](https://colab.research.google.com/drive/1jRxTq22NM54GMllzE5MNWnxU3uPjYfSh?usp=sharing)] (Requires Google login) [[Video Tutorial](https://vimeo.com/1048086557/dac65e751d)]
