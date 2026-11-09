#!/bin/bash
# сборка report.pdf: html без кода -> pdf через системный chromium (webpdf требует playwright)
set -e
cd "$(dirname "$0")"
JUPYTER=${JUPYTER:-jupyter}
$JUPYTER nbconvert --to html --no-input --execute 02_report.ipynb --output report.html
python3 - <<'P'
s = open("report.html", encoding="utf-8").read()
css = """<style>@page{size:A4;margin:11mm 12mm}body{font-size:10.5px!important}
.jp-Notebook,.jp-Cell,.container{padding:0!important;margin:0!important}
.jp-RenderedHTMLCommon{font-size:10.5px!important;line-height:1.35!important}
.jp-RenderedHTMLCommon h1{font-size:19px!important;margin:4px 0!important}.jp-RenderedHTMLCommon h2{font-size:15px!important;margin:8px 0 3px!important}
.jp-RenderedHTMLCommon h3{font-size:12.5px!important;margin:6px 0 2px!important}.jp-RenderedHTMLCommon p{margin:3px 0!important}
.jp-RenderedHTMLCommon ul,.jp-RenderedHTMLCommon ol{margin:2px 0!important}
.jp-OutputArea-output img{max-width:84%!important;height:auto!important}
.jp-OutputArea-output table{font-size:9.5px!important}.jp-OutputArea-output td,.jp-OutputArea-output th{text-align:left!important}.jp-OutputArea-output td,.jp-OutputArea-output th{padding:1px 4px!important}
.jp-Cell-outputWrapper,.jp-OutputArea-child{padding:0!important;margin:0!important}
</style>"""
open("report.html", "w", encoding="utf-8").write(s.replace("</head>", css + "</head>"))
P
chromium --headless --no-sandbox --disable-gpu --no-pdf-header-footer --print-to-pdf=report.pdf "file://$PWD/report.html" 2>/dev/null
