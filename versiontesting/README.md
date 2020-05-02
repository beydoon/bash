# README

This is a quick test to understand how to add versioning control to
applications using git tagging.

Versioning Schemes
There are two types of versioning schemes:

Internal version number: This can be incremented many times in a day (e.g.
revision control number)
Released version: This changes less often (e.g. semantic versioning)
People use different schemes as per their need, but semantic versioning is
fairly widely used and authored by Tom Preston-Werner, co-founder of GitHub.

## Semantic Versioning
Semantic versioning follows the pattern of X.Y.Z

Or more readable would be [major].[minor].[patch]-[build/beta/rc]

E.g. 1.2.0-beta

major or X can be incremented if there are major changes in software, like
backward-incompatible API release.

minor or Y is incremented if backward compatible APIs are introduced.

patch or Z is incremented after a bug fix.

How do we achieve this using Git?
By using tags:

Tags in Git can be used to add a version number.

git tag -a "v1.5.0-beta" -m "version v1.5.0-beta"
adds a version tag of v1.5.0-beta to your current Git repository. Every new
commit after this will auto-increment tag by appending commit number and commit
hash. This can be viewed using the git describe command.

v1.5.0-beta-1-g0c4f33f here -1- is the commit number and 0c4f33f the
abbreviation of commit's hash. The g prefix stands for "git".

Complete details can be viewed using:

git show v1.0.5-beta

[REFERANCE] (https://stackoverflow.com/a/46434732/3143084)
