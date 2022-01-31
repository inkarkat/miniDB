# Mini Database

_A lightweight file-based database supporting CRUD operations with a single lookup key._

This small tool serves as a lightweight database supporting CRUD operations of multiple columns via a single lookup key. Assuming infrequent access by default, file locking can be optionally enabled to safely handle concurrent updates. Also, there's support for simple transactions, with multiple concurrent reads, a singular write (and a command to update from read to write), and rollback of any updates done under the transaction.

Each database "table" is represented as an individual file (put by default under `~/.local/share/[NAMESPACE/]TABLE`; the location can be customized via command-line arguments or `$XDG_DATA_HOME`). Each record is a row of Tab-separated columns; the first column is the `KEY`. Records can contain newline characters. The database does not have to fit into memory all at once, but as operations are done on it linearly (and without an index), this is intended for small-scale data in the kilobyte to low-megabyte range.

## Dependencies

* Bash, GNU `sed`
* `flock` for transaction support
* [withTransaction](https://github.com/inkarkat/withTransaction) for transaction support
* automated testing is done with _bats - Bash Automated Testing System_ (https://github.com/bats-core/bats-core)

## See also

* [nanoDB](https://github.com/inkarkat/nanoDB) provides an even more primitive key-value store behind a very similar API.
* [picoDB](https://github.com/inkarkat/picoDB) provides an even more primitive store of a set of keys (without values) behind a very similar API.
