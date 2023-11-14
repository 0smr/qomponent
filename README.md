# QML Qomponent
<p><img src="https://img.shields.io/github/v/tag/0smr/qomponent?sort=semver&label=version" alt="version tag">
<img src="https://img.shields.io/github/license/0smr/qomponent?color=36b245" alt="license">
<a href="https://www.blockchain.com/bch/address/bitcoincash:qrnwtxsk79kv6mt2hv8zdxy3phkqpkmcxgjzqktwa3">
<img src="https://img.shields.io/badge/BCH-Donate-f0992e?logo=BitcoinCash&logoColor=f0992e" alt="BCH donate"></a></p>

**Qomponent** QtQuick2/QML tools.

**Qomponent** is made up of variation components from my past projects. So I thought it would be a good idea to group them all together as a single module.

*If you liked these components, please consider givin a star :star2:*

### Preview

<table width="200px">
<tr><td><video src="https://github.com/0smr/qomponent/assets/51415059/263791225-ce6d5311-d612-4263-825c-3ae12ca25a19.mp4"></video></td>
<td><video src="https://github.com/0smr/qomponent/assets/51415059/799b1962-a351-4e43-b5d3-9100e204f540.mp4"></video></td>
<td><video src="https://github.com/0smr/qomponent/assets/51415059/73a0bb65-bb63-4a82-a718-f0f3a079fedc.mp4"></video></td></tr>
<tr><td colspan="3"><video src="https://github.com/0smr/qomponent/assets/51415059/aecfd391-a593-4526-9238-25aafae69dee.mp4"></video></td></tr>
</table>

## How to use
> **Note**<br>
> Components in this repository are still in development, thus changes over each update may be significant.
> <br>&nbsp;

### Usage

+ Clone the repository first.
    ```bash
    git clone "https://github.com/0smr/qomponent.git"
    ```
+ Then add `qomponent` to your makefile.
    * **QMake**: <sub>[example-1](example/example-1/example-1.pro#L7)</sub>
        ```make
        include("path/to/Qomponent.pri")
        ```
    * **CMake**: <sub>[example-3](example/example-3/CMakeLists.txt#L30..L32)</sub>
        ```cmake
        add_subdirectory(path/to/Qomponent/)
        target_link_libraries(${target-name} qomponent)
        ```
+ Add `qrc:/` to the engine's import path.
    <sub>[example-1](example/example-1/main.cpp#L17)</sub>
    ```cpp
    engine.addImportPath("qrc:/");
    ```
+ Import the `Qomponent` module.
    <sub>[example-1](example/example-1/main.qml#L10)</sub>
    ```qml
    import Qomponent 0.2
    ```

If you are confused, please refer to [example-1](example/example-1) for a clearer understanding of what you should do.

## Components

<div align="center">

||||
|--|--|--|
|ColorPicker|CircularColorPicker|RippleTT|
|BoxShadow |QGrid        |GirdSeparator|
|FastShadow|GridSeparator|TextAnimation|
|Pie       |ToolTipPlus  |Tiltable    |
|Ruler     |UITour       |MiniMarkdown|
|Guide     |MiniKeyboard |PatternLock |
|GridRuler |VRow         |LinearGauge |
|FocusEffect|ArcSlider    |ThemeEditor|
|ColorEditor|DragableGridView |FontSelector|
|UITourItem |MultiRangeSlider |AutoCompleteInput|
|ElasticEffect|TimePicker|BarChart|
|QRect|-|-|-|

</div>

## Issues

Please file an issue on [issues page](https://github.com/0smr/qomponent/issues) if you have any problems.

## Documentation

[Documentation](docs/README.md) can be found in the `docs` directory.
