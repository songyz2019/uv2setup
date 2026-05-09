# uv2setup

遵守常见的Python规范和最佳实践，然后轻松把你的Python项目打包为Windows用户可用的安装包

1. 使用uv管理Python环境
2. 编写`[project.scripts]`


# Project Requirements

uv2setup is intentionally opinionated.

To keep the installer stable, predictable, and compatible across Windows systems, your project must follow the conventions below.

---

# Required Project Structure

Your project **must** use a standard `src` layout.

```text
my-app/
├─ pyproject.toml
├─ uv.lock
└─ src/
   └─ my_app/
      ├─ __init__.py
      └─ main.py
```

Requirements:

```text
1. The package directory must exist under src/
2. The package directory must contain __init__.py
3. The project must be installable by uv
4. The project must successfully run `uv sync`
```

---

# Required pyproject.toml Configuration

Your project must define a GUI entrypoint using `[project.gui-scripts]`.

Example:

```toml
[project]
name = "my-app"
version = "0.1.0"
requires-python = ">=3.13"
dependencies = []

[project.gui-scripts]
uv2setup_entrypoint = "my_app.main:main"

[build-system]
requires = ["uv_build>=0.9.0,<0.10.0"]
build-backend = "uv_build"
```

Notes:

```text
1. uv2setup currently prioritizes GUI desktop applications
2. The entrypoint name must be exactly `uv2setup_entrypoint`
3. The target must be importable by Python
4. The target function must be callable without arguments
```

---

# Example Entry Function

```python
def main():
    print("Hello from uv2setup!")
```

---

# Required Build Backend

uv2setup currently expects projects to use:

```toml
[build-system]
requires = ["uv_build>=0.9.0,<0.10.0"]
build-backend = "uv_build"
```

Other build backends are not officially supported yet.

---

# Runtime Model

uv2setup does NOT bundle Python dependencies into a frozen executable.

Instead, the installed application works like this:

```text
1. Installer copies your project files
2. Installer runs `uv sync --frozen`
3. A local virtual environment is created on the target machine
4. Desktop shortcuts launch your app using `uv run`
```

This design prioritizes:

```text
- Maximum compatibility
- Reliable dependency resolution
- Better native Python behavior
- Easier debugging
- Simpler packaging
```

---

# What uv2setup Excludes

The following directories/files are automatically excluded from installers:

```text
.venv/
__pycache__/
*.pyc
.pytest_cache/
.mypy_cache/
.ruff_cache/
.git/
```

Do not rely on them being included.

---

# Current Scope

uv2setup currently focuses on:

```text
- Windows desktop applications
- GUI applications
- uv-managed projects
```

CLI/TUI applications may work, but are not the primary target in the current stage.

---

# Design Philosophy

uv2setup is NOT a universal Python packager.

Instead, it is:

```text
A lightweight installer generator for projects that follow the uv2setup conventions.
```

By intentionally limiting supported project layouts, uv2setup can remain:

```text
- Simple
- Predictable
- Easy to debug
- Easy to maintain
- Highly compatible
```
