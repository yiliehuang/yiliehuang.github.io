# Personal Website Maintenance Rules

This repository is my personal academic website.

## Absolute rule

Never commit or push to GitHub unless I explicitly say one of the following:

* approve push
* 同意上传
* 可以上传

Before that approval, all work must remain local.

## Main workflow

For every website update:

1. Run `git status --short` first.
2. Run `git fetch origin`.
3. Determine the online upstream branch, usually `origin/master` or `origin/main`.
4. Inspect the existing website structure before editing.
5. Preserve the existing style, ordering, and file organization unless there is a clear reason to change it.
6. Make the smallest correct change.
7. Update both the website and the CV when the new information should appear in both places.
8. Build or compile everything needed locally.
9. Start or prepare the local website preview.
10. Give me direct local preview links to the homepage and only the pages relevant to the change.
11. Report all accumulated local differences compared with the online branch, including untracked files.
12. Stop at the Preview + Approval Gate and wait for my approval before commit or push.

## Preview + Approval Gate

After any modification, deletion, file upload, paper update, talk update, CV update, profile update, or website content change:

1. Run the necessary local checks.
2. Compile the CV if CV-related files changed.
3. Run `git fetch origin`.
4. Determine the online upstream branch, usually `origin/master` or `origin/main`.
5. Compare the full current local working tree against the online branch, including all accumulated uncommitted and untracked changes.
6. Start or prepare the local Jekyll preview.
7. Give direct local preview links, including only the relevant pages plus the homepage.
8. Include detailed visible/material differences against the online branch.

The final response after every change must use this exact structure:

```text
Visible pages/files changed:

* ...

Detailed visible changes compared with online version:

* `page or CV section`: visible change from `old material` to `new material`
* `file:line`: changed from `old visible text` to `new visible text`
* `file:line`: added visible material `new text`
* `file:line`: removed visible material `old text`

Local preview:

* Main local site: [http://127.0.0.1:4000/](http://127.0.0.1:4000/)
* Changed page: ...
* Changed page: ...
* CV PDF if changed: [http://127.0.0.1:4000/files/CV_Yilie_Huang.pdf](http://127.0.0.1:4000/files/CV_Yilie_Huang.pdf)

Checks run:

* ...

Approval options:

1. approve push — commit and push all current local changes to GitHub
2. request changes — I will tell you what to revise
3. discard latest change — revert only the latest requested change, not unrelated previous local changes
```

Never ask for approval until local preview links are provided. Do not merely say "preview at localhost"; give direct links to the exact pages to check. If the local preview server is not running, start it or tell me the exact command to start it.

The detailed section is for what a visitor, reader, or CV reviewer would actually see. Do not dump implementation-only script, config, or workflow internals unless they affect the visible website, local preview behavior, publication/talk/CV material, or deployment safety. When saying "files changed," list visible website pages, public PDFs, and other visitor-facing material, not helper scripts or intermediate maintenance files unless the user asks for implementation details.

For website/CV text files, list every meaningful visible changed line in the detailed section using:

* `FILE:LINE`: changed from `old visible text` to `new visible text`
* `FILE:LINE`: added visible material `new text`
* `FILE:LINE`: removed visible material `old text`

For binary files such as PDFs, report whether the file is new or modified, the file path, old/new size if available, whether it was regenerated from LaTeX or copied manually, and the local preview link if public. Also compare visible PDF text when practical. If the PDF binary changed but the visible PDF text did not, say clearly that the PDF was regenerated but no visible CV text changed.

If I choose option 2, revise locally and return to the same Preview + Approval Gate. If I choose option 3, revert only the latest requested change, not unrelated prior local changes.

## CV rules

The CV LaTeX source must be kept under:

`cv/CV_Yilie_Huang.tex`

The compiled public CV PDF must be copied to:

`files/CV_Yilie_Huang.pdf`

If the CV is updated, always compile the LaTeX file and refresh the PDF in `files/`.

Do not commit LaTeX auxiliary files such as `.aux`, `.log`, `.out`, `.toc`, `.fls`, `.fdb_latexmk`, `.synctex.gz`, or temporary build folders.

## Public file rules

Public files linked from the website should go under `files/`.

Recommended organization:

* `files/CV_Yilie_Huang.pdf` for the CV
* `files/papers/` for paper PDFs
* `files/slides/` for talk slides
* `files/posters/` for posters

Use clean filenames with no spaces. Prefer names like:

* `2026-art-guangzhou-slides.pdf`
* `2026-icaif-asset-liability-management.pdf`
* `2025-sicon-lq-rl.pdf`

If an existing file already uses a different path, do not break the old link unless updating all references.

## Publication update rules

When updating a paper:

1. First check whether the paper already exists on the website or CV.
2. If it is an update from preprint to publication, modify the existing entry instead of duplicating it.
3. Move it from Preprints to Publications only when appropriate.
4. Update venue, year, DOI, arXiv link, official link, and PDF link if provided.
5. Preserve the website’s existing chronological or reverse-chronological order.
6. Update the CV consistently.
7. If a new PDF is provided, copy it to `files/papers/` or the existing appropriate `files/` location.

## Talk update rules

When updating a talk:

1. Check whether the talk already exists.
2. Add or modify the talk in the existing talks/presentations structure.
3. Add slides to `files/slides/` if provided.
4. Update the CV talks or invited presentations section consistently.
5. Preserve the existing order and formatting.

## News update rules

Only add news items when the item is important enough for the homepage or news section.

Examples:

* new appointment
* accepted paper
* major invited talk
* award
* grant
* conference organization

Do not add trivial updates.

## Local preview rules

Local preview must use both config files so internal site URLs point at the local server:

`bundle exec jekyll serve --config _config.yml,_config_local.yml --host 127.0.0.1 --port 4000`

Before asking me to approve a push, always provide local preview links for the homepage and only the relevant pages, for example:

* `http://127.0.0.1:4000/`
* `http://127.0.0.1:4000/publications/`
* `http://127.0.0.1:4000/talks/`
* `http://127.0.0.1:4000/files/CV_Yilie_Huang.pdf`

If the actual website paths differ, inspect the repo and provide the correct local URLs.

Inspect hardcoded links to `https://yiliehuang.github.io`. If an internal website navigation link points to the public site, change it to a local-safe relative link such as `/publications/`, `/talks/`, or `/files/CV_Yilie_Huang.pdf`. Do not change genuinely external links such as LinkedIn, Google Scholar, arXiv, DOI, journal pages, or collaborators’ websites.

## Pre-publish check

Before any commit or push, run the available local checks.

At minimum:

1. compile CV if CV changed
2. run `git fetch origin`
3. determine the upstream online branch
4. build or serve the Jekyll site locally with `_config.yml,_config_local.yml`
5. check `git status --short`
6. show changed files
7. show detailed visible/material changes against the online branch, including untracked files when they affect website/CV material or preview behavior
8. provide the Preview + Approval Gate response
9. wait for approval

## Commit and push rule

Only after I explicitly approve:

1. run the checks again
2. create a clear commit message
3. commit
4. push to GitHub
5. tell me the public GitHub Pages URL to check after deployment

Recommended commit message examples:

* `Update academic profile`
* `Update publications and CV`
* `Update talks and CV`
* `Update website files`
