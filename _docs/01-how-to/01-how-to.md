---
title: How to write a tutorial
---

# How to write a tutorial

"A tutorial to write a tutorial"

## Related links

[Markdown Quick Reference](https://packetlife.net/media/library/16/Markdown.pdf)

[How to take good screenshots](01a-good-screenshots/01a-good-screenshots)

## Step 1: setup directories

This website contains auto-generated pages. Thus, tutorials must be organized according to a predefined structure in order to be correctly indexed. The main directory is:

```
...
/_docs/
    [markdown and image files are stored here]
...
```

Tutorials must be follow a numerical sequence and be organized as subdirectories of `/_docs/`. E.g., considering our site already has two tutorials (01 and 02), to write a new tutorial named *my-awesome-guide*, initially create a subdirectory index as *03*:

```
...
/_docs/
    03-my-awesome-guide/
...
```

Tip: use short names in the indexed folders. Full title must be specified in the markdown file as a meta-tag (covered in sequence).

## Step 2: setup essential files

Each tutorial must have (at least) one markdown file stored in the `/_docs/{your_subdirectory}/`, e.g.: `/_docs/03-my-awesome-guide/03-my-awesome-guide.md`. Note that the markdown file should have the same name as parent folder. Also, the markdown file must contain a title meta-tag (use a full descriptive tutorial title!), e.g.:

```
---
title: Awesome guide for creating tutorials in markdown
---

Bla bla bla bla bla bla....
```

Next, if your tutorial needs images or screenshots, add them to the created subdirectory. E.g,: `/_docs/03-my-awesome-guide/img1.png`.

## Step 3: [Optional] setup sub-tutorials

If your tutorial needs complementary guides (or related tutorials) *sub-tutorials* can be created. A sub-tutorial is created just like regular tutorials, but stored in subdirectories instead of the root */docs*. 

E.g,: Let's consider a big tutorial named *12-formatting-a-laptop*, which can be done in two different ways: *formatting and installing windows*; *formatting and instaling linux*. Some actions are valid for both procedures (e.g., copy files to a backup disk), however other actions are specific (e.g., installing the operating system). This big tutorial can be organized as follows:

Files structure:

```
...
/_docs/
    12-formatting-a-laptop/
        12-formatting-a-laptop.md    <= main markdown file
        image1_backup_your_files.png    <= image(s) for the main tutorial
        12a-windows/                 <= subdirectory for linux version
            12a-windows.md              <= markdown file for windows users
            install_windows.png         <= image(s) related to windows installation
        12b-linux/                   <= subdirectory for linux version
            12b-linux.md                <= markdown file for linux users
            install_linux.png           <= image(s) related to linux installation
...
```


```
---
title: A (not so) quick guide to format a laptop
---

Step 1: backup your files

(Describe here how to backup files...)

Step 2: [Windows Users]

(Create a link to the corresponding sub-tutorial)

Step 2: [Linux Users]

(Create a link to the corresponding sub-tutorial)

```

Tip: check *01-how-to* and *01a-good-screenshots* for a practical sub-tutorial example.

Tip: remeber to add links for sub-tutorials in the main tutorial (Related Links section)

## Step 4: essential sections

Ensure each tutorial has the following content organized as sections:

```
---
(meta-tags)
---

# Title (same as used in the title meta-tag)

(tutorial description. Answer the question: what is this guide about?)

## [Optional] Related links

(links for sub-tutorials and related content)

## [Optional] Prerequisites

(describe what is needed to execute your tutorial / what environment you tested. This section is optional, some tutorials have no prerequisites.)

E.g.:
- Linux Ubuntu, 20.04
- Laravel 7.x
- NodeJS 12
- This tutorial requires a database pre-configured according to the Tutorial 25

## Step 1: blabla

(first step...)

## Step 2: blabla

(second step...)

...
```

## Step 5: re-generate Table of Contents

After finishing writting your tutorial (and before commiting it to git), the Table of Contents must be re-generated. 

Execute: `$ ruby generate_toc.rb`