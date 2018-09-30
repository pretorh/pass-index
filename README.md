# pass-index

password store extention for using uuid filenames

usage:

```
pass index [command]
```

## commands:

With no command, dump the names of the items in the index file (like `pass show index`, but without the keys)

- `show` - read the name from `stdin`, resolve the key-file, and show the password
    - `echo "example.com" | pass index show`
