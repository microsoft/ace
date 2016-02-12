Ace welcomes and strongly encourages community contributions! Please don't be shy!

## Issue Contribution

* Your PR should have a link to [the issue](https://github.com/microsoft/ace/issues) that you are fixing. 

## Feature Contribution

Features are new or improved functionality. For example, 
* Exposing a new Android/iOS control through the cross-platform framework.
* Implementing more properties on existing controls.

Feature contributions are welcomed, but need to be approved by Ace collaborators.

## Documentation Contribution

* Want to fix or add to the documentation at http://microsoft.github.io/ace? Please submit a PR! The website lives in the gh-pages branch of this repository. 

## Legal

You will need to complete a Contributor License Agreement (CLA). Briefly, this agreement testifies that you are granting us permission to use the submitted change according to the terms of the project's license, and that the work being submitted is under appropriate copyright.

Please submit a Contributor License Agreement (CLA) before submitting a pull request. You may visit https://cla.microsoft.com to sign digitally. Alternatively, download the agreement ([Microsoft Contribution License Agreement.docx](https://www.codeplex.com/Download?ProjectName=typescript&DownloadId=822190) or [Microsoft Contribution License Agreement.pdf](https://www.codeplex.com/Download?ProjectName=typescript&DownloadId=921298)), sign, scan, and email it back to <cla@microsoft.com>. Be sure to include your github user name along with the agreement. Once we have received the signed CLA, we'll review the request. 

## Sending a PR

Your pull request should: 

* Include a clear description of the change
* Be a child commit of a reasonably-recent commit in the **master** branch 
    * Requests need not be a single commit, but should be a linear sequence of commits (i.e. no merge commits in your PR)
* (In the future:) It is desirable, but not necessary, for the tests to pass at each commit
* Have clear commit messages 
    * e.g. "Refactor feature XYZ", "Fix issue XYZ", "Add tests for issue XYZ"
* (In the future:) Include adequate tests 
    * At least one test should fail in the absence of your non-test code changes. If your PR does not match this criteria, please specify why
    * Tests should include reasonable permutations of the target fix/change
* (In the future:) Ensure there are no linting issues ("gulp tslint")
* To avoid line ending issues, set `autocrlf = input` and `whitespace = cr-at-eol` in your git configuration
