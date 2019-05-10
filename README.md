# Execution Marker

This small tool serves as a lightweight file-based columnar database supporting CRUD operations with a single lookup key.

Each database "table" is represented as an individual file (put by default under `~/.config/[NAMESPACE/]TABLE`, location can be customized via `$XDG_CONFIG_HOME`). Each record is a line consisting of Tab-separated columns; the first column is the `KEY`. Records can contain newline characters.

## Dependencies

* Bash, GNU `sed`
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)
