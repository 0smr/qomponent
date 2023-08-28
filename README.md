# QML Qomponent
<p><img src="https://img.shields.io/github/v/tag/smr76/qomponent?sort=semver&label=version" alt="version tag">
<img src="https://img.shields.io/github/license/smr76/qomponent?color=36b245" alt="license">
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

Clone the repository first.
```bash
git clone "https://github.com/SMR76/qomponent.git"
```

Then include `Qomponent.pri` in your project. <sub>[see example-1](example/example-1/example-1.pro#L11)</sub>
```make
include("path/to/Qomponent.pri")
```

Add `qrc:/` to the engine import path. <sub>[see example-1](example/example-1/main.cpp#L17)</sub>
```cpp
engine.addImportPath("qrc:/");
```

And finally import the `Qomponent` module. <sub>[see example-1](example/example-1/main.qml#L6)</sub>
```qml
import Qomponent 0.1
```

If you are confused, please refer to [example-1](example/example-1) for a clearer understanding of what you should do.

## Components

<!-- <details open>
<summary>Available</summary>
</details> -->

## Issues

Please file an issue on [issues page](https://github.com/SMR76/qomponent/issues) if you have any problems.

## Documentation

[Documentation](docs/README.md) can be found in the `docs` directory.
