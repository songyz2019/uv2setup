# uv2setup

Convert uv project into a setup package for Windows easily with max compatibility.

The most common way to make setup package for Python is pyinstaller, however, some Python packages, especially in AI and datascience domain, pyinstaller have limited compatibility. Thus, we provide a method, using `uv sync` to install Python environment during setup and `uv run` to start Python codes to keep compatibility.

> [!NOTE]
> This project is a **Proof of Concept** / **Experimental** implementation exploring Python application packaging and installation workflows. It is intended for technical demonstration and learning purposes only, and is not production-ready or actively maintained.

## Usage

1. Clone this repo
```bash
git clone --depth=1 https://github.com/songyz2019/uv2setup
cd uv2setup
```
2. Run `fetch-resource.py`, or put your `uv.exe` and `uvw.exe` into `.uv2setup/`
```bash
# fetch-resource.py is designed to run on any Python 3 environment
python fetch-resource.py 
```
3. Copy your uv project in `app/`
4. Install [Inno Setup](https://jrsoftware.org/isdl.php) and open `uv2setup.iss`
5. Edit some `#define` in `uv2setup.iss`
6. Run `Build -> Compile` in menu. Your setup file will be in `dist/` folder

## Extras
1. Internet access is required for users during the installation
2. Replace '.uv2setup/icon.ico' to change icons.
3. Edit '.uv2setup/uv.toml' to set mirrors, change timeout and edit other behaviors of uv.

## License

```text
Copyright 2026-present songyz2019

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```