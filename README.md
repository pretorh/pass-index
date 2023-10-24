# pass-index

A [password store](https://www.passwordstore.org/) extention that uses uuid filenames (to obfuscate system names)

## commands:

Usage:

```
pass index [command]
```

With no command, dump the names of the items in the index file (like `pass show index`, but without the keys)

### `create`

Create a password using the `pass insert` command, but with a `PASS_INDEX_UUID_GENERATOR` (defaults to `uuidgen`) generated filename

With `--generate <count>`, use `pass generate <count>` to create the actual password

### `edit`

Read the name from `stdin`, resolve the key-file, and edit the password an editor

### `show`

Read the name from `stdin`, resolve the key-file, and show the password

Use `-c` or `--clip`: pass `--clip` when reading the password

### `ls`

List all items in the index file

Use `--grep` to ask for a string to grep the list with
