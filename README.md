Getting Started
===============

以下在macOS环境(其它系统稍有不同, 如Debian gems在 `/var/lib/gems`
或者运行 `gem list -d`):

1.  拷贝fonts中的字体(ttf文件)到
    `/Library/Ruby/Gems/2.6.0/gems/asciidoctor-pdf-1.5.3/data/fonts`

2.  拷贝fonts中的default-theme.yml, 覆盖
    `/Library/Ruby/Gems/2.6.0/gems/asciidoctor-pdf-1.5.3/data/themes/default-theme.yml`,
    覆盖前请备份原文件

3.  转换测试文件examples/example.adoc

<!-- -->

    $ asciidoctor-pdf examples/example.adc

中文处理
========

涉及中文处理一般都要费尽周折, LaTex, Pandoc等等都是这样.
Asciidoctor-pdf处理中文主要是通过配置theme文件指定字体来实现.

准备字体
--------

可拷贝Windows/Fonts下的中文字体, 但是Asciidoctor
PDF不能像浏览器将字体倾斜的功能, 而中文字体一般没有斜体.
网上找到基于Adobe和Google联合发布思源黑体(Source Han Sans或Noto Sans
CJK, otf格式)制作了
[怀源黑体(ttf格式)](https://github.com/chloerei/asciidoctor-pdf-cjk-kai_gen_gothic/releases),
但是该项目现在停止维护.

-   [Google Roboto Fonts](https://fonts.google.com/specimen/Roboto)

-   [Google Noto Fonts(含中文)](https://www.google.com/get/noto/)

自定义主题
----------

新建custom-theme.yml

    font:
      catalog:
        Roboto:
          normal: Roboto-Regular.ttf
          italic: Roboto-Italic.ttf
          bold: Roboto-Bold.ttf
          bold_italic: Roboto-BoldItalic.ttf
        Roboto Mono:
          normal: RobotoMono-Regular.ttf
          italic: RobotoMono-Italic.ttf
          bold: RobotoMono-Bold.ttf
          bold_italic: RobotoMono-BoldItalic.ttf
        Noto Sans CJK SC:
          normal: NotoSansCJKsc-Regular.ttf
          italic: NotoSansCJKsc-Thin.ttf
          bold: NotoSansCJKsc-Bold.ttf
          bold_italic: NotoSansCJKsc-Medium.ttf
      fallbacks: [Noto Sans CJK SC, Roboto]
    base:
      font_family: Noto Sans CJK SC

    $ asciidoctor-pdf -a pdf-theme=custom-theme.yml -a pdf-fontsdir="fonts;GEM_FONTS_DIR" Syntax.adoc

这里NotoSansCJKsc从Google Fonts下载是otf格式的, 需要转换为ttf格式.

转换otf到ttf格式
================

由于asciidoctor-pdf使用了prawn, 后者只能解析ttf格式字体.
Asciidoctor作者提到使用fontforge来做格式转换([链接](https://discuss.asciidoctor.org/How-to-generate-fonts-td2358.html)),
但好像转换后的文件出现缺字的情况.

系统要求
--------

1.  Python3

2.  virtualenvwrapper

下载otf格式思源黑体
-------------------

[**Source Han
Sans**](https://fonts.adobe.com/fonts/source-han-sans-simplified-chinese)
is a sans-serif gothic typeface family created by Adobe and Google. It
is also released by Google under the Noto fonts project as [**Noto Sans
CJK**](https://www.google.com/get/noto/). The family includes seven
weights, and supports Traditional Chinese, Simplified Chinese, Japanese
and Korean. It also includes Latin, Greek and Cyrillic characters from
the Source Sans Pro family.

1.  [Adobe Fonts on
    GitHub](https://github.com/adobe-fonts/source-han-sans)

2.  [Google Fonts on GitHub](https://github.com/googlefonts/noto-cjk)

安装Adobe Font Development Kit for OpenType
-------------------------------------------

The [**Adobe Font Development Kit for OpenType
(AFDKO)**](https://github.com/adobe-type-tools/afdko), also known as
Adobe FDKO or simply AFDKO, is a font development kit (FDK), a set of
command-line tools freely distributed by Adobe for editing and verifying
OpenType fonts. It does not offer a glyph editor, but focuses on tools
for manipulating font metrics, kerning and other OpenType features.
AFDKO runs on Microsoft Windows, Linux and macOS, and licensed under the
Apache License.

    $ mkvirtualenv font
    $ pip3 install afdko
    $ which otf2ttf
    /Users/frankshong/.virtualenvs/font/bin/otf2ttf
    $ otf2ttf NotoSansCJKsc-Bold.otf
    WARNING: Dropping glyph names, they do not fit in 'post' table.
    $ otf2ttf NotoSansCJKsc-Regular.otf
    WARNING: Dropping glyph names, they do not fit in 'post' table.
    $ otf2ttf NotoSansCJKsc-Thin.otf
    WARNING: Dropping glyph names, they do not fit in 'post' table.
    $ otf2ttf NotoSansCJKsc-Medium.otf
    WARNING: Dropping glyph names, they do not fit in 'post' table.

上面的WARNING可以忽略

在theme文件中声明字体
---------------------

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th>type</th>
<th>font</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><p>normal</p></td>
<td><p>NotoSansCJKsc-Regular</p></td>
</tr>
<tr class="even">
<td><p>italic</p></td>
<td><p>NotoSansCJKsc-Thin</p></td>
</tr>
<tr class="odd">
<td><p>bold</p></td>
<td><p>NotoSansCJKsc-Bold</p></td>
</tr>
<tr class="even">
<td><p>bold_italic</p></td>
<td><p>NotoSansCJKsc-Medium</p></td>
</tr>
</tbody>
</table>

修改绑定字体
============

可以修改系统中的fonts和themes,
这样执行不需要每次都指定pdf-style和pdf-fontsdir参数

1.  将字体拷贝到
    `/Library/Ruby/Gems/2.6.0/gems/asciidoctor-pdf-1.5.3/data/fonts`

2.  修改
    `/Library/Ruby/Gems/2.6.0/gems/asciidoctor-pdf-1.5.3/data/themes/default-theme.yml`

这样就可以直接运行下面的命令:

    $ asciidoctor-pdf helloworld.adoc

中文换行问题
============

问题描述
--------

-   <https://github.com/asciidoctor/asciidoctor-pdf/issues/82>

-   <https://github.com/asciidoctor/asciidoctor-pdf/issues/1206>

-   <https://github.com/asciidoctor/asciidoctor-pdf/pull/1355>

解决方法
--------

在文档首行添加属性:

    :scripts: cjk

或者参考 [Support for Non-Latin
Languages](https://github.com/asciidoctor/asciidoctor-pdf#support-for-non-latin-languages)

    $ asciidoctor-pdf -a scripts=cjk -a pdf-theme=default-with-fallback-font document.adoc

测试文本
--------

AsciiDoc is a human-readable document format, semantically equivalent to
DocBook XML, but using plain-text mark-up conventions. AsciiDoc
documents can be created using any text editor and read “as-is”, or
rendered to HTML or any other format supported by a DocBook tool-chain,
i.e. PDF, TeX, Unix manpages, e-books, slide presentations, etc.

AsciiDoc 是一个人类可读的文件格式，语义上等同于 DocBook 的
XML，但使用纯文本标记了约定。可以使用任何文本编辑器创建文件把 AsciiDoc
和阅读“原样”，或呈现为HTML 或由 DocBook 的工具链支持的任何其他格式，如
PDF，TeX 的，Unix 的手册页，电子书，幻灯片演示等。

AsciiDoc は、意味的には DocBook XML
のに相当するが、プレーン·テキスト·マークアップの規則を使用して、人間が読めるドキュメントフォーマット、である。
AsciiDoc
は文書は、任意のテキストエディタを使用して作成され、「そのまま"または、HTML
や DocBook
のツールチェーンでサポートされている他のフォーマット、すなわち PDF、TeX
の、Unix の man
ページ、電子書籍、スライドプレゼンテーションなどにレンダリングすることができます。

AsciiDoc 는 의미의 DocBook XML 에 해당하지만 일반 텍스트 마크 업 규칙을
사용하여 사람이 읽을 수있는 문서 형식입니다. AsciiDoc 문서는 텍스트
편집기를 사용하여 생성하고 "있는 그대로"읽거나, HTML 또는 DocBook 을
도구 체인에서 지원하는 다른 형식, 즉 PDF, 텍, 유닉스 맨 페이지, 전자 책,
슬라이드 프리젠 테이션 등을 렌더링 할 수 있습니다.

测试中文和English混合编排。这是中文。This is English. 什么都没有。
**黑体**. *斜体*. 测试中文和English混合编排。这是中文。This is English.
什么都没有。 **黑体**. *斜体*. 测试中文和English混合编排。这是中文。This
is English. 什么都没有。 **黑体**. *斜体*.
测试中文和English混合编排。这是中文。This is English. 什么都没有。
**黑体**. *斜体*. 测试中文和English混合编排。这是中文。This is English.
什么都没有。 **黑体**. *斜体*. 测试中文和English混合编排。这是中文。This
is English. 什么都没有。 **黑体**. *斜体*.
测试中文和English混合编排。这是中文。This is English. 什么都没有。
**黑体**. *斜体*. 测试中文和English混合编排。这是中文。This is English.
什么都没有。 **黑体**. *斜体*.

Troubleshooting
===============

`` /Library/Ruby/Gems/2.6.0/gems/prawn-2.2.2/lib/prawn/font/ttf.rb:246:in `/': nil can’t be coerced into Float (TypeError) ``
-----------------------------------------------------------------------------------------------------------------------------

字体不符合要求, 见 [Preparing a Custom
Font](https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc#preparing-a-custom-font)

从 [Google Fonts](https://fonts.google.com/?category=Monospace)
选择一款Mono字体

渲染源代码中的中文注释出现问题
------------------------------

[default-theme.yml](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/data/themes/base-theme.yml)
指定M+ 1mn字体, 但未指定 [Fallback
Fonts](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/docs/theming-guide.adoc#fallback-fonts)

**default-theme.yml.**

    ...
    literal:
      font_color: B12146
      font_family: M+ 1mn
    ...
    code:
      font_color: $base_font_color
      font_family: $literal_font_family
    ...

[Built-in
(AFM)](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/docs/theming-guide.adoc#built-in-afm-fonts)
fonts do not use the [fallback
fonts](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/docs/theming-guide.adoc#fallback-fonts).
In order for the fallback font to kick in, you must be using a TrueType
font.

1.  首先要下载 [Roboto
    Mono](https://fonts.google.com/specimen/Roboto+Mono?category=Monospace)

2.  然后theme文件中注册 [Custom
    Fonts](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/docs/theming-guide.adoc#custom-fonts)

3.  在theme文件中指定 [Fallback
    Fonts](https://github.com/asciidoctor/asciidoctor-pdf/blob/v1.5.0.beta.7/docs/theming-guide.adoc#fallback-fonts)

4.  可以在theme文件中指定该字体:

<!-- -->

    code:
      font-family: Roboto Mono

或者, 修改
`/Library/Ruby/Gems/2.6.0/gems/asciidoctor-pdf-1.5.3/data/themes/default-theme.yml`
中的属性

    ...
    literal:
      font_family: Roboto Mono

中文空格问题
------------

虽然前面已经讨论了中文空格在文字对齐上的问题, 空格作为英文单词分隔符,
在词法分析上有特殊意义, 因此中英文混合在有些情况下仍有些问题, 如

1.  链接, 地址必须与前面的汉字要有空格

2.  行内代码, \`\` 文本必须前后都要空格, 且转换成PDF时存在对齐问题
