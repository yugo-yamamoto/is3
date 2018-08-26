# is3 interactive s3 client

## requirements

- aws cli 
- ruby 2.0.0 later

## how to use 

### login

```
$ ./is3.rb [bucketname][initial path]
```

### command

| command | description |
|---------|-------------|
|ls      | list objects |
|cd [directory]    | change directory |
|pwd     | show current directory |
|less [filename ] | less contents | 
| get [filename] | download file to local current directory |
| put [local filename] | upload local file to remote current directory |
| rm [filename] | remove objects |
| presign | show presign url (expired 1 week) | 
| quit or exit | quit |



