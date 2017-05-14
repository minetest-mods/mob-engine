# Contributing to Mob Engine

The following is a set of guidelines for contributing to Mob Engine, which are hosted in the Minetest Mods Team on GitHub. These are just guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.


---
## What should I know before I get started?

### Mob Engine

Mob Engine is a mod(pack) for Minetest that provides a mob engine and several creatures to the game.


---
## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Mob Engine. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template](.github/ISSUE_TEMPLATE.md), the information it asks for helps us resolve issues faster.

#### Before Submitting A Bug Report

**Perform a [cursory search](https://github.com/minetest-mods/mob-engine/issues?&q=is%3Aissue)** to see if the problem has already been reported. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/). Create an issue on repository and provide the following information by filling in [the template](.github/ISSUE_TEMPLATE.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include links to files or GitHub projects, or copy/pasteable snippets, which you use in those examples. If you're providing snippets in the issue, use [Markdown code blocks](https://daringfireball.net/projects/markdown/syntax#precode).
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem. You can use [this tool](http://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **If the problem wasn't triggered by a specific action**, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* **Did the problem start happening recently** (e.g. after updating to a new version of Mob Engine) or was this always a problem?
* If the problem started happening recently, **can you reproduce the problem in an older version of Mob Engine?** What's the most recent version in which the problem doesn't happen? You can download older versions of Mob Engine from [the releases page](https://github.com/minetest-mods/mob-engine/releases).
* **Can you reliably reproduce the issue?** If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* **Which version of Mob Engine are you using?**
* **Which version of the Minetest you're using?**

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Mob Engine, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion and find related suggestions.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](ISSUE_TEMPLATE.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

**Perform a [cursory search](https://github.com/minetest-mods/mob-engine/issues?&q=is%3Aissue)** to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/).Create an issue on that repository and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**. Include copy/pasteable snippets which you use in those examples, as [Markdown code blocks](https://daringfireball.net/projects/markdown/syntax#precode).
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Include screenshots and animated GIFs** which help you demonstrate the steps or point out the part of Mob Engine which the suggestion is related to. You can use [this tool](http://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux.
* **Explain why this enhancement would be useful**
* **Specify which version of Mob Engine you're using.**
* **Specify which version of Minetest you're using.**

### Code Contributions

Unsure where to begin contributing to Mob Engine? You can start by looking through these `quicker` and `help-wanted` issues:

* [Quicker issues][quicker] - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues][help-wanted] - issues which should be a bit more involved than `quicker` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

#### Branching Model
Mob Engine adopts [Vincent Driessen's branching model](http://nvie.com/posts/a-successful-git-branching-model):

| Branch name | Type | branch off from | merge into | Description |
| --- | --- | --- | --- | --- |
| master | main branch | n/a | n/a | Branch where the source code of `HEAD` always reflects a production-ready state. |
| develop | main branch | n/a | n/a | Branch where the source code of `HEAD` always reflects a state with the latest delivered development changes for the next release. This is where any automatic nightly builds are built from.
| feature/... | supporting branch | `develop` | `develop` | Branches that exists as long as the new feature is in development, but will eventually be merged into develop (to definitely add the new feature to the upcoming release) or discarded (in case of a disappointing experiment).
| release/... | supporting branch | `develop` | `develop`, `master` and *tag version* | Branches that support preparation of a new production release. They allow for last-minute dotting of i’s and crossing t’s. Furthermore, they allow for minor bug fixes and preparing meta-data for a release (version number, build dates, etc.). By doing all of this work on a release branch, the develop branch is cleared to receive features for the next big release.
| hotfix/... | supporting branch | `master` | `develop`, `master` and *tag version* | Branches that arise from the necessity to act immediately upon an undesired state of a live production version. When a critical bug in a production version must be resolved immediately, a hotfix branch may be branched off from the corresponding tag on the master branch that marks the production version. |

For more information on the Vincent Driessen's branching model, see [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model).

#### Start contributing
To start contibuting you must follow these steps:

1. Fork the repository
2. Choose the desired branch (except `master` or `develop`) or create a new branch (from `develop` with `feature` prefix or from master with `hotfix` prefix).
3. Start coding.

### Pull Requests

* Fill in [the required template](.github/PULL_REQUEST_TEMPLATE.md)
* Document new code based on the
  [Documentation Styleguide](#documentation-styleguide)
* End files with a newline.


---
## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally

### Documentation Styleguide

Use [Markdown](https://daringfireball.net/projects/markdown) in all documentation


---
## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests.

The labels are loosely grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Please open an issue if you have suggestions for new labels, and if you notice some labels are missing.

#### Type of Issue and Issue State

| Label name | Search link | Description |
| --- | --- | --- |
| `bug` | [search][search-label-bug] | Confirmed bugs or reports that are very likely to be bugs. |
| `duplicate` | [search][search-label-duplicate] | Issues which are duplicates of other issues, i.e. they have been reported before. |
| `enhancement` | [search][search-label-enhancement] | Feature requests. |
| `feedback` | [search][search-label-feedback] | General feedback more than bug reports or feature requests. |
| `help-wanted` | [search][search-label-help-wanted] | Complex issues wich need an intensive development. The develop team would appreciate help from the community in resolving these issues. |
| `invalid` | [search][search-label-invalid] | Issues which aren't valid (e.g. user errors). |
| `more-information-needed` | [search][search-label-more-information-needed] | More information needs to be collected about these problems or feature requests (e.g. steps to reproduce). |
| `needs-reproduction` | [search][search-label-needs-reproduction] | Likely bugs, but haven't been reliably reproduced. |
| `question` | [search][search-label-question] | Questions more than bug reports or feature requests (e.g. how do I do X). |
| `quicker` | [search][search-label-quicker] | Less complex issues which are quicker to resolve. Good first issues to work on for developers who want to contribute to the project. |
| `wontfix` | [search][search-label-wontfix] | The core development team has decided not to fix these issues for now, either because they're working as intended or for some other reason. |

#### Topic Categories
| Label name | Search link | Description |
| --- | --- | --- |
| `api` | [search][search-label-api] | Related to API. |
| `crash` | [search][search-label-crash] | Reports of Mob Engine causing Minetest crash. |
| `documentation` | [search][search-label-documentation] | Related to any type of documentation. |

#### Pull Request Labels
| Label name | Search link | Description |
| --- | --- | --- |
| `needs-review` | [search][search-label-needs-review] | Pull requests which need review, and approval from maintainers or core development team. |
| `needs-testing` | [search][search-label-needs-testing] | Pull requests which need manual testing. |
| `requires-changes` | [search][search-label-requires-changes] | Pull requests which need to be updated based on review comments and then reviewed again. |
| `under-review` | [search][search-label-under-review] | Pull requests being reviewed by maintainers or development core team. |
| `work-in-progress` | [search][search-label-work-in-progress] | Pull requests which are still being worked on, more changes will follow. |





[search-label-api]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aapi
[search-label-bug]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Abug
[search-label-crash]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Acrash
[search-label-documentation]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Adocumentation
[search-label-duplicate]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aduplicate
[search-label-enhancement]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aenhancement
[search-label-feedback]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Afeedback
[search-label-help-wanted]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Ahelp-wanted
[search-label-invalid]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Ainvalid
[search-label-more-information-needed]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Amore-information-needed
[search-label-needs-reproduction]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aneeds-reproduction
[search-label-needs-review]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aneeds-review
[search-label-needs-testing]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aneeds-testing
[search-label-question]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aquestion
[search-label-quicker]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aquicker
[search-label-requires-changes]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Arequires-changes
[search-label-under-review]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Aunder-review
[search-label-wontfix]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Awontfix
[search-label-work-in-progress]: https://github.com/minetest-mods/mob-engine/issues?&q=label%3Awork-in-progress
