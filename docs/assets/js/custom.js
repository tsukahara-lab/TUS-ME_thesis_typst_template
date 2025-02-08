
document.addEventListener("DOMContentLoaded", function() {
    var script = document.createElement('script');
    script.src = 'https://unpkg.com/lunr-languages/lunr.stemmer.support.js';
    script.onload = function () {
        var scriptJa = document.createElement('script');
        scriptJa.src = 'https://unpkg.com/lunr-languages/lunr.ja.js';
        document.head.appendChild(scriptJa);
    };
    document.head.appendChild(script);
});
