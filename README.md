# pass-index

password store extention for using uuid filenames

usage:

```
pass index [command]
```

## commands:

With no command, dump the names of the items in the index file (like `pass show index`, but without the keys)

- `create` - create a password using the `pass insert` command, but with a `PASS_INDEX_UUID_GENERATOR` (or `uuidgen`) generated filename
    - with `--generate`, use `pass generate` to create the actual password
- `show` - read the name from `stdin`, resolve the key-file, and show the password
    - `echo "example.com" | pass index show`
- `ls` - list all items in the index file
