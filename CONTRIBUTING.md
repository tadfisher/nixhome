Contributing
============

Thanks for wanting to contribute to Home Manager! These are some
guidelines to make the process as smooth as possible for both you and
the Home Manager developers.

If you are only looking to report a problem then it is sufficient to
read through the following section on reporting issues. If you instead
want to directly contribute improvements and additions then please
have a look at everything here.

Reporting an issue
------------------

If you notice a problem with Home Manager and want to report it then
have a look among the already [open issues][], if you find one
matching yours then feel free to comment on it to add any additional
information you may have.

If no matching issue exists then go to the [new issue][] page and
write a description of your problem. Include as much information as
you can, ideally also include relevant excerpts from your Home Manager
configuration.

Contributing code
-----------------

If you want to contribute code to improve Home Manager then please
follow these guidelines.

### Fork and create a pull request ###

If you have not previously forked Home Manager then you need to do
that first. Have a look at GitHub's "[Fork A Repo][]" for instructions
on how to do this.

Once you have a fork of Home Manager you should create a branch
starting at the most recent `master`. Give your branch a reasonably
descriptive name. Perform your changes on this branch and when you are
happy with the result push the branch to GitHub and
[create a pull request][].

### Commits ###

The commits in your pull request should be reasonably self-contained,
that is, each commit should make sense in isolation. In particular,
you will be asked to amend any commit that introduces syntax errors or
similar problems even if they are fixed in a later commit.

The commit messages should follow the format

    {component}: {description}

    {long description}

where `{component}` refers to the code component (or module) your
change affects, `{description}` is a brief description of your change,
and `{long description}` is an optional clarifying description. Note,
`{description}` should start with a lower case letter. As a rare
exception, if there is no clear component, or your change affects many
components, then the `{component}` part is optional.

When adding a new module, say `foo.nix`, we use the fixed commit
format `foo: add module`. You can, of course, still include a long
description if you wish.

In addition to the above commit message guidelines, try to follow the
[seven rules][] as much as possible.

### Style guidelines ###

The code in Home Manager should follow the [Nixpkgs syntax
guidelines][]. Note, we prefer `lowerCamelCase` for variable and
attribute names with the accepted exception of variables directly
referencing packages in Nixpkgs which use a hyphenated style. For
example, the Home Manager option `services.gpg-agent.enableSshSupport`
references the `gpg-agent` package in Nixpkgs.

### News ###

Home Manager includes a system for presenting news to the user. When
making a change you, therefore, have the option to also include an
associated news entry. In general, a news entry should only be added
for truly noteworthy news. For example, a bug fix or new option does
generally not need a news entry.

If you do have a change worthy of a news entry then please add one in
[`news.nix`][] but you should follow some basic guidelines:

- The entry timestamp should be in ISO-8601 format having "+00:00" as
  time zone. For example, "2017-09-13T17:10:14+00:00". A suitable
  timestamp can be produced by the command

      date --iso-8601=second --universal

- The entry condition should be as specific as possible. For example,
  if you are changing or deprecating a specific option then you could
  restrict the news to those users who actually use this option.

- Wrap the news message so that it will fit in the typical terminal,
  that is, at most 80 characters wide. Ideally a bit less.

- Unlike commit messages, news will be read without any connection to
  the Home Manager source code. It is therefore important to make the
  message understandable in isolation and to those who do not have
  knowledge of the Home Manager internals. To this end it should be
  written in more descriptive, prose like way.

- If you refer to an option then write its full attribute path. That
  is, instead of writing

  > The option 'foo' has been deprecated, please use 'bar' instead.

  it should read

  > The option 'services.myservice.foo' has been deprecated, please
  > use 'services.myservice.bar' instead.

- A new module, say `foo.nix`, should always include a news entry
  (without any condition) that has a message along the lines of

  > A new service is available: 'services.foo'.

  or

  > A new program configuration is available: 'program.foo'.

  depending on the type of module.

[open issues]: https://github.com/rycee/home-manager/issues
[new issue]: https://github.com/rycee/home-manager/issues/new
[Fork A Repo]: https://help.github.com/articles/fork-a-repo/
[create a pull request]: https://help.github.com/articles/creating-a-pull-request/
[seven rules]: https://chris.beams.io/posts/git-commit/#seven-rules
[`news.nix`]: https://github.com/rycee/home-manager/blob/master/modules/misc/news.nix
[Nixpkgs syntax guidelines]: https://nixos.org/nixpkgs/manual/#sec-syntax
