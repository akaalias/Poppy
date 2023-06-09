## Publishing Automatic Updates

### In XCode
- Make code changes
- Update release and build number
- Create Product Archive
- Distribute App using Developer ID
- Export signed Poppy.app into /Distribution

### In Terminal

```sh
$ cd {ROOT}/Distribution
$ ./publish.sh
```

### On Github
- Create new release to make sure people who download it from releases have the latest version right away
