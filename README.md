# BitV API Documentation

Source for the BitV public API documentation site.

**Live site**

- Simplified Chinese — <https://bitv-api.github.io/spot/v1/cn/>
- English — <https://bitv-api.github.io/spot/v1/en/>
- Traditional Chinese — <https://bitv-api.github.io/spot/v1/hk/>

## Branches

| Branch | Purpose |
| ------ | ------- |
| `v1_cn` / `v1_en` / `v1_hk` | Documentation source, one branch per language |
| `gh-pages` | Generated static site (this is what the live site serves) |

Each language branch holds its own copy of the content. A change that applies to
all languages has to be made on each branch.

## Editing

All documentation content lives in a single file per branch:

```
source/index.html.md
```

## Building

Requires Ruby and [Middleman](https://middlemanapp.com/).

```bash
bundle install
bundle exec middleman build
```

The generated site is written to `build/`, which is then published to the
`gh-pages` branch.

## License

This site is built on [Slate](https://github.com/slatedocs/slate), which is
licensed under the Apache License, Version 2.0. See `LICENSE` for the full text.
