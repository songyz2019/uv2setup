# uv2setup

Make your uv project into a setup package for Windows easily.

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