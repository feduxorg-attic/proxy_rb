# Contributing

In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code ( **no patch is too small** : fix typos, add comments, clean up inconsistent whitespace )
* by refactoring code
* by closing [issues][]
* by reviewing patches

[issues]: https://github.com/fedux-org/proxy_pac_rb/issues

## Submitting an Issue

We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. 

When submitting a bug report, please include a [Gist][] that includes a *stack
trace* and any details that may be necessary to reproduce the bug, including
your *gem version*, *Ruby version*, and *operating system*. Ideally, a bug report
should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request

1. [Fork the repository.][fork]
2. Create a topic [branch]. `git checkout -b local_topic_branch`
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake test`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake test`. If your specs fail, return to step 5.
7. Add, commit, and push your changes. To push your topic branch use `git push -u origin local_topic_branch`.
8. [Submit a pull request.][pr]

Here are some reasons why a pull request may not be merged:

1. It hasn’t been reviewed.
2. It doesn’t include specs for new functionality.
3. It doesn’t include documentation for new functionality.
4. It changes behavior without changing the relevant documentation, comments, or specs.
5. It changes behavior of an existing public API, breaking backward compatibility.
6. It breaks the tests on a supported platform.
7. It doesn’t merge cleanly (requiring Git rebasing and conflict resolution).

Include this emoji in the top of your ticket to signal to us that you read this
file: :memo:

[fork]: http://help.github.com/fork-a-repo/
[branch]: https://help.github.com/articles/fork-a-repo#create-branches
[pr]: http://help.github.com/send-pull-requests/