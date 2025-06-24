# spotify-mcp

[![Release](https://img.shields.io/github/v/release/chethanuk/spotify-mcp)](https://img.shields.io/github/v/release/chethanuk/spotify-mcp)
[![Build status](https://img.shields.io/github/actions/workflow/status/chethanuk/spotify-mcp/main.yml?branch=main)](https://github.com/chethanuk/spotify-mcp/actions/workflows/main.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/chethanuk/spotify-mcp/branch/main/graph/badge.svg)](https://codecov.io/gh/chethanuk/spotify-mcp)
[![Commit activity](https://img.shields.io/github/commit-activity/m/chethanuk/spotify-mcp)](https://img.shields.io/github/commit-activity/m/chethanuk/spotify-mcp)
[![License](https://img.shields.io/github/license/chethanuk/spotify-mcp)](https://img.shields.io/github/license/chethanuk/spotify-mcp)

Spotify API Model Context Protocol (MCP) server

- **Github repository**: <https://github.com/chethanuk/spotify-mcp/>
- **Documentation** <https://chethanuk.github.io/spotify-mcp/>

## Getting started with your project

### 1. Create a New Repository

First, create a repository on GitHub with the same name as this project, and then run the following commands:

```bash
git init -b main
git add .
git commit -m "init commit"
git remote add origin git@github.com:chethanuk/spotify-mcp.git
git push -u origin main
```

### 2. Set Up Your Development Environment

Then, install the environment and the pre-commit hooks with

```bash
make install
```

This will also generate your `uv.lock` file

### 3. Run the pre-commit hooks

Initially, the CI/CD pipeline might be failing due to formatting issues. To resolve those run:

```bash
uv run pre-commit run -a
```

### 4. Commit the changes

Lastly, commit the changes made by the two steps above to your repository.

```bash
git add .
git commit -m 'Fix formatting issues'
git push origin main
```

You are now ready to start development on your project!
The CI/CD pipeline will be triggered when you open a pull request, merge to main, or when you create a new release.

To finalize the set-up for publishing to PyPI, see [here](https://fpgmaas.github.io/cookiecutter-uv/features/publishing/#set-up-for-pypi).
For activating the automatic documentation with MkDocs, see [here](https://fpgmaas.github.io/cookiecutter-uv/features/mkdocs/#enabling-the-documentation-on-github).
To enable the code coverage reports, see [here](https://fpgmaas.github.io/cookiecutter-uv/features/codecov/).

## Releasing a new version

- Create an API Token on [PyPI](https://pypi.org/).
- Add the API Token to your projects secrets with the name `PYPI_TOKEN` by visiting [this page](https://github.com/chethanuk/spotify-mcp/settings/secrets/actions/new).
- Create a [new release](https://github.com/chethanuk/spotify-mcp/releases/new) on Github.
- Create a new tag in the form `*.*.*`.

For more details, see [here](https://fpgmaas.github.io/cookiecutter-uv/features/cicd/#how-to-trigger-a-release).

---

Repository initiated with [fpgmaas/cookiecutter-uv](https://github.com/fpgmaas/cookiecutter-uv).


# Development

Common commands:

```bash
# Setup
make install        # Install main deps
make install-dev    # Install dev tools
make install-all    # Install everything

# Dependencies
make add-pkg PKG=requests GROUP=main  # Add a package
make check-updates  # Check for updates
make update-deps    # Update all packages
make lock           # Update lock file
make sync           # Sync with lock file

# Testing & Quality
make check   # Run all checks
make test    # Run tests with coverage

# Build & Release
make build           # Build packages
make publish         # Publish to PyPI (asks for confirmation)
make build-and-publish  # Build and publish

# Cleanup
make clean       # Remove build/test files
make clean-all   # Remove everything (including venv)

# Docs
make docs        # Start docs server
make docs-test   # Test docs build

# Help
make help        # Show all commands
```

For more details, check the Makefile.
