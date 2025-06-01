# gdot

Dotfile and workstation management utility that handles shell and topic management.  
A single source of truth for workstation setup and a package of various bin tools.  

## Table of Contents

* [Information](#information)
* [Terminology](#terminology)
* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Changes](#changes)
* [Contributing](#contributing)
* [License](#license)
* [Contact](#contact)
* [Thanks](#thanks)

## Information

### Platforms

The gdot utility is mainly created for MacOS management,
though shell profiles work on any Linux distro.  
Various topics can be used on deb and rpm based platforms
and the utility should handle installing
and configuring where possible.

### Requirements

MacOS requires [Homebrew](https://brew.sh)
and [mas](https://github.com/mas-cli/mas) cli
for App Store applications.  

### Dependencies

There are no dependencies on other repos or tooling.

## Terminology

The gdot utility works around topics, like many dotfile managers.  
It does however feature extended functionality
to handle app/package and software management as well per topic.

### Topic

Topics in the `topics/` directory of the repo define
applications and programs to install and maintain.  
This is the top level configuration element of `gdot`.  
In each topics folder there is a file named `gdot.sh` that determines
how to set up the topic.  
See the `lib/gdot/gdot.sh` default file for available functions and structure.  

Run `$ gdot topic list` for a full list of topics.

Each topic can have three main functions to configure:

1. `bootstrap()` – bootstraps things before install
1. `install()` – Installs the app/program
1. `configure()` – Configure the app/program after install

These are run in order for each topic, and are all optional.
Some topics only utilize a subset of these, some none at all.

### Shell

Shells in the `shells/` directory pf the repo configure shell profiles.  
These are just like [topics](#topic) but kept separately.  
This handles rc, profile, sets prompt, and configures various aliases etc.

When running `$ gdot dot`, shells get configured before other topics.

Currently supported:

* `zsh` – fully fledged prompt and config
* `bash` – basic installation, unconfigured

### Context

A context defines what to install on the current system.  
setting `gdot_context` in the config file can install and configure
apps/programs for the defined contexts. A comma separated value
can install multiple contexts, and each topic also has a context by its name.

Example: This configures all topics from base context, as well as the topic 'vscode'.

``` shell
#file: .gdot/.gdot
gdot_context="base,vscode"
```

### Platform

Platforms define support for different os platforms.  
Topics will only be managed on the relevant platform it is being run on,
and some topics do not have support on all platforms.

Currently supported:

* `macos` – MacOS (Brew packages)
* `deb` – Debian based os (Apt packages)
* `rpm` – RPM based os (Yum/Dnf packages)

Some topics only configure shell properties, or configure links, etc,
in those cases `all` keyword ensures it runs on all platforms.

### Config

The utility can use an external config directory where
static configuration can be stored and synced.

The .gdot config file has a variable to define the location of
this external directory.

This ensures that this configuration does not need to be pushed to gdot,
but can by managed by it.

An example of this is the `vscode` topic, that symlinks
settings, keybindings, and snippets from the config dir to the relevant location.

``` shell
/path/to/config/
  vscode/
    settings.json
    keybindings.json
    snippets/
      my.code-snippets
```

If the custom config directory can not resolve the source for linking,
it simply skips this.

> ! This should not be used to store sensitive information,
> but mainly custom configuration that needs to be syncable.

### Bin tools

The `bin/` directory gets loaded into path and contains various tools
and snippets to extend functionality of topics.

They can be listed by running  `$ gdot tools`.

## Installation

1. Clone git repository.

    ``` shell
    git clone "https://github.com/gummigudm/gdot.git" "${HOME}/.gdot"
    ```

1. Configure `gdot`.

    Create config file from default.

    ``` shell
    cp "${HOME}/.gdot/.gdot.default" "${HOME}/.gdot/.gdot"
    ```

    Edit in editor of choice.  
    Set appropriate variables to configure. (See: [Terminology](#terminology) for details)

    ``` shell
    vi "${HOME}/.gdot/.gdot"
    ```

1. Initialize `gdot`.

    Temporarily add bin to path. (Shell config takes care of this after init.)

    ``` shell
    export PATH="${HOME}/.gdot/bin:${PATH}"
    gdot init
    ```

## Usage

1. Run `gdot`.

    This is idempotent and will show output of actions taken.

    ``` shell
    gdot dot
    ```

## Development

Refer to [Terminology](#terminology) for information
on how to develop topics and extend functionality.

Development is done locally and the cli
can be used to open for editing with `$ gdot edit`

## Changes

Changes with bugfixes and features are depicted in `CHANGELOG.md`
correlating to project release versions.

## Contributing

Any contributions are greatly appreciated. See `CONTRIBUTING.md` for more information.

### Contributors

* [gummigudm](https://github.com/gummigudm)  

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Guðmundur Guðmundsson - [gummigudm@gmail.com](mailto:gummigudm@gmail.com)

* Github - [gummigudm](https://github.com/gummigudm)
* Gitlab - [gummigudm](https://gitlab.com/gummigudm)

## Thanks

Initial structure of shell and topic loading is heavily inspired by
[Zach Holmans](https://github.com/holman)
[dotfiles](https://github.com/holman/dotfiles) repository.
