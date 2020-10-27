# Mini Database

_A lightweight file-based columnar database supporting CRUD operations with a single lookup key._

This small tool serves as a lightweight file-based columnar database supporting CRUD operations with a single lookup key. Assuming infrequent access by default, file locking can be optionally enabled to safely handle concurrent updates. Also, there's support for simple transactions, with multiple concurrent reads, a singular write (and a command to update from read to write), and rollback of any updates done under the transaction.

Each database "table" is represented as an individual file (put by default under `~/.config/[NAMESPACE/]TABLE`, the location can be customized via command-line arguments or `$XDG_CONFIG_HOME`). Each record is a line consisting of Tab-separated columns; the first column is the `KEY`. Records can contain newline characters.

## Dependencies

* Bash, GNU `sed`
* `flock` for transaction support
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)
