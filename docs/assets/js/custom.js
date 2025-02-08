
document.addEventListener("DOMContentLoaded", function() {
    // Lunr.js のロード
    var scriptLunr = document.createElement('script');
    scriptLunr.src = 'https://cdnjs.cloudflare.com/ajax/libs/lunr.js/2.3.9/lunr.min.js';
    scriptLunr.onload = function () {
        // lunr.stemmer.support.js をロード
        var scriptStemmer = document.createElement('script');
        scriptStemmer.src = 'https://unpkg.com/lunr-languages/lunr.stemmer.support.js';
        scriptStemmer.onload = function () {
            // lunr.ja.js をロード
            var scriptJa = document.createElement('script');
            scriptJa.src = 'https://unpkg.com/lunr-languages/lunr.ja.js';
            scriptJa.onload = function () {
                // 日本語トークナイザーの設定
                if (window.lunr && lunr.hasOwnProperty('ja')) {
                    lunr.Pipeline.registerFunction(lunr.ja.stopWordFilter, 'jaStopWordFilter');
                    lunr.Pipeline.registerFunction(lunr.ja.stemmer, 'jaStemmer');
                    console.log("Lunr.js 日本語対応が適用されました。");
                } else {
                    console.error("Lunr.js の日本語対応の適用に失敗しました。");
                }
            };
            document.head.appendChild(scriptJa);
        };
        document.head.appendChild(scriptStemmer);
    };
    document.head.appendChild(scriptLunr);
});
