# Makefile

# ==============================================================================
# Configuration
# ==============================================================================
.DEFAULT_GOAL := help

# Define the virtual environment directory name
VENV_DIR := venv
# Define paths to executables.
# PYTHON is from the virtual environment.
# uv is assumed to be globally available.
PYTHON := $(VENV_DIR)/bin/python
UV := uv

# ==============================================================================
# Environment Setup
# ==============================================================================
# This target acts as a dependency to ensure the venv is created before use.
$(VENV_DIR)/bin/activate: pyproject.toml
	@echo "🚀 Creating virtual environment at $(VENV_DIR)..."
	@$(UV) venv $(VENV_DIR)

.PHONY: install
install: $(VENV_DIR)/bin/activate ## Install main dependencies and pre-commit hooks
	@echo "🚀 Installing main dependencies..."
	@$(UV) sync --group main
	@echo "🚀 Installing pre-commit hooks..."
	@$(UV) run pre-commit install
	@echo "\n✅ Main environment ready. Activate with: source $(VENV_DIR)/bin/activate"

.PHONY: install-dev
install-dev: $(VENV_DIR)/bin/activate ## Install development dependencies (main + dev)
	@echo "🚀 Installing development dependencies..."
	@$(UV) sync --group main --group dev
	@echo "\n✅ Development environment ready. Activate with: source $(VENV_DIR)/bin/activate"

.PHONY: install-all
install-all: $(VENV_DIR)/bin/activate ## Install all dependency groups (main + dev)
	@echo "🚀 Installing all dependency groups..."
	@$(UV) sync --all-groups
	@echo "\n✅ Full environment ready. Activate with: source $(VENV_DIR)/bin/activate"

# ==============================================================================
# Dependency Management
# ==============================================================================
.PHONY: add-pkg
add-pkg: ## Add a package to a group. Usage: make add-pkg PKG=numpy GROUP=ml
	@if [ -z "$(PKG)" ] || [ -z "$(GROUP)" ]; then \
		echo "Error: PKG and GROUP must be specified. Example: make add-pkg PKG=numpy GROUP=ml"; \
		exit 1; \
	fi
	@echo "🚀 Adding package '$(PKG)' to group '$(GROUP)'..."
	@$(UV) add --group $(GROUP) $(PKG)

.PHONY: check-updates
check-updates: ## Check for available package updates
	@echo "🚀 Checking for outdated packages..."
	@$(UV) pip list --outdated

.PHONY: update-deps
update-deps: ## Update all packages to their latest versions
	@echo "🚀 Updating all installed packages to their latest versions..."
	@echo "⚠️  This command updates packages in the environment but does not modify pyproject.toml or the lock file."
	@echo "   After verifying the updates, run 'make lock' to persist the changes."
	@$(UV) pip install --upgrade --upgrade-package $$($(UV) pip freeze | cut -d '=' -f 1 | tr '\n' ' ')

.PHONY: lock
lock: ## Regenerate the uv.lock file from pyproject.toml
	@echo "🚀 Regenerating lock file..."
	@$(UV) lock --refresh

.PHONY: sync
sync: ## Synchronize the environment with the lock file
	@echo "🚀 Syncing environment with uv.lock..."
	@$(UV) sync --no-upgrade

# ==============================================================================
# Quality & Testing
# ==============================================================================
.PHONY: check
check: install ## Run all code quality checks (format, lint, type-check)
	@echo "🚀 Checking lock file consistency..."
	@$(UV) lock --locked
	@echo "🚀 Running pre-commit hooks..."
	@$(UV) run pre-commit run --all-files
	@echo "🚀 Running static type checker..."
	@$(UV) run mypy
	@echo "🚀 Checking for obsolete dependencies..."
	@$(UV) run deptry .
	@echo "✅ All checks passed!"

.PHONY: test
test: ## Run tests and generate a coverage report
	@echo "🚀 Running tests with coverage..."
	@$(UV) run pytest --cov --cov-config=pyproject.toml --cov-report=xml -v

# ==============================================================================
# Build & Distribution
# ==============================================================================
.PHONY: build
build: clean ## Build wheel and source distribution packages
	@echo "🚀 Building distribution packages..."
	@$(UV) run uvx --from build pyproject-build --installer uv

.PHONY: publish
publish: ## Publish the package to PyPI (with confirmation)
	@read -p "Are you sure you want to publish to PyPI? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "🚀 Publishing to PyPI..."; \
		$(UV) run twine upload dist/*; \
	else \
		echo "Publishing cancelled."; \
	fi

.PHONY: build-and-publish
build-and-publish: build publish ## Build and publish a new version

# ==============================================================================
# Cleaning
# ==============================================================================
.PHONY: clean-build
clean-build: ## Remove build artifacts
	@echo "🚀 Removing build artifacts..."
	@rm -rf build/ dist/ .eggs/ *.egg-info/

.PHONY: clean-py
clean-py: ## Remove Python cache files
	@echo "🚀 Removing Python cache files..."
	@find . -name '__pycache__' -exec rm -rf {} +
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +

.PHONY: clean-test
clean-test: ## Remove test and coverage artifacts
	@echo "🚀 Removing test and coverage artifacts..."
	@rm -rf .pytest_cache/ .coverage coverage.xml

.PHONY: clean
clean: clean-build clean-py clean-test ## Remove all temporary build, test, and Python files

.PHONY: clean-all
clean-all: clean ## Remove all temporary files and the virtual environment
	@echo "🚀 Removing virtual environment '$(VENV_DIR)'..."
	@rm -rf $(VENV_DIR)

# ==============================================================================
# Documentation
# ==============================================================================
.PHONY: docs-test
docs-test: ## Test if documentation builds correctly
	@echo "🚀 Testing documentation build..."
	@$(UV) run mkdocs build -s

.PHONY: docs
docs: ## Build and serve the documentation locally
	@echo "🚀 Building and serving documentation at http://localhost:8000..."
	@$(UV) run mkdocs serve

# ==============================================================================
# Help
# ==============================================================================
.PHONY: help
help: ## Display this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
