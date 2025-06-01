# gdot

Dotfile and workstation management utility that handles shell and topic management.  
A single source of truth for workstation setup and a package of various bin tools.  

## Install

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

1. Run `gdot`.

    This is idempotent and will show output of actions taken.

    ``` shell
    gdot dot
    ```

## Terminology

### Topics

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

### Shells

Shells in the `shells/` directory pf the repo configure shell profiles.  
These are just like [topics](#topics) but kept separately.  
This handles rc, profile, sets prompt, and configures various aliases etc.

When running `$ gdot dot`, shells get configured before other topics.

Currently supported:

* `zsh` – fully fledged prompt and config
* `bash` – basic installation, unconfigured

### Contexts

A context defines what to install on the current system.  
setting `gdot_context` in the config file can install and configure
apps/programs for the defined contexts. A comma separated value
can install multiple contexts, and each topic also has a context by its name.

Example: This configures all topics from base context, as well as the topic 'vscode'.

``` shell
gdot_context="base,vscode"
```

### Platforms

Platforms define support for different os platforms.  
Topics will only be managed on the relevant platform it is being run on,
and some topics do not have support on all platforms.

Currently supported:

* `macos` – MacOS (Brew packages)
* `deb` – Debian based os (Apt packages)
* `rpm` – RPM based os (Yum/Dnf packages)

Some topics only configure shell properties, or configure links, etc,
in those cases `all` keyword ensures it runs on all platforms.

### Bin tools

The `bin/` directory gets loaded into path and contains various tools
and snippets to extend functionality of topics.

They can be listed by running  `$ gdot tools`.
