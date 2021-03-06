# Introduction

Welcome!

You have landed upon my project coursework for [Getting and Cleaning Data](https://www.coursera.org/course/getdata). This
class is offered by [Johns Hopkins University](http://www.jhu.edu/) as part of its
[Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1/overview).

# Overview

The key to making sense of these artifacts is to take the class and work on the
problem.

# Resources

There were many resources utilized to complete this project. All of them are
appropriately referenced or cited.

In the case of `R` code, it is expected that library citations were not necessary
because they may be easily found on either [CRAN](http://cran.us.r-project.org/) or [GitHub](https://github.com/).

In the case of my system configuration, I included as much of it as possible to
encourage reproducibility. In particular, this includes information on the
operating system, developemnt environment, and overall approach. The majority
of these artifacts were produced using [orgmode](http://orgmode.org/) which is responsible for
generating the final deliverables which in this case are `R` and [MarkDown](https://en.wikipedia.org/wiki/Markdown)
documents. Please read `technical.md` for more detailed information or
`technical.org` if you want to read the source.

In the case of the data set, its information page is [here](http://archive.ics.uci.edu/ml/datasets/Human%2BActivity%2BRecognition%2BUsing%2BSmartphones) and a direct link to
download it is [here](https://d396qusza40orc.cloudfront.net/getdata%252Fprojectfiles%252FUCI%2520HAR%2520Dataset.zip). It isn't always prudent to store archive files in source
control systems, but this is a special case and it is stored within.

The core analysis is:
-   Defined in `run_analysis.org`
-   Executed in `run_analysis.R`
-   Explained in `run_analysis.md`

The codebook is:
-   Defined in `CodeBook.org`
-   Executed in `CodeBook.R`
-   Explained in `CodeBook.md`

# Discussion

## Style

The course lectures explained that you should be able to explain any of your
analytical process to your grandmother, and that is the approach that I am
following here. My grandmother was very patient and easy-going and would have
made a fine data scientist.

## Getting Started

This project definition is intentionally very vague and open ended. Basically
you need to get some data and do something to it and report on it. How hard can
that be? As usual, it is mostly how hard *you* make it.

Since all of the data is provided in the archive file, you may read it as you
see fit. My goal will be to avoid copy-and-paste as much as humanly possible.
There is no shortage of information about the data; the real value is in
identifying which parts of it are useful.

The class discussion boards are absolutely essential to completing this project.
Perhaps essential is not strong enough… they are critical. The only way to make
sense of the project, the data, and the approach is to invest a lot of work and
rely upon the generousity of your classmates and the community teaching
assistants.

# Analysis

## Defining the Question

The first step of any analytical project is to define the question. What
question is to be answered by this project? The answer is simple, but it doesn't
look that way. Instead of being posed with a question we are instead posed with
a number of steps that we should perform.

Specifically we are asked to download some data, merge it into a single data-set,
give it useful names, and then make it tidy. It goes without saying that if you
haven't ready the [tidy data](http://vita.had.co.nz/papers/tidy-data.pdf) paper then now is definitely the time. With that in
mind the question becomes a lot more clear.

The question we are being asked is how we went about the process of performing
the steps that they asked us to perform. By order of deduction, this is the
*only* logical question that we may answer here! Fortunately, it is worth
answering.

The intent of the project is to practice, literally, "Getting and Cleaning Data".
By explaining to someone else, namely anyone reading this, what we did and how
we did it, we are forced to think through that which we are attempting to do and
that which we actually ended up doing.

## Getting Our Bearings

"Getting one's bearing" is an [English expression](http://dictionary.reference.com/browse/get%2Bone's%2Bbearings) that conveys how we handle
being dropped into a new situation. That is very much the case with this project.
The question is quite general, so where do we start?

The best place to start is just by reading the aforementioned project page for
the data. There you can find the project abstract which nice and succinct:

> Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

You can find the same information in the file `README.txt`. You should read it
a few times like I did because it is the *key* starting point. It tells you where
to look for column names and data types. Unfortunately, it does so quite
painfully.

In a perfect world you would have a clear and concise data definition in one
place. We have it, but it is littered about between different files. In fact,
the terms used to describe things have little meaning to the students working
on this project so it takes time to make sense of things. The data itself is
of a consistent sample type, but it is split up in different files. Even worse,
some of the files are simply columns that belong with row data defined
elsewhere. In the grand scheme of things it is not a big deal, it just takes a
lot of time to make sense of it.

The purpose of this document is to make sense of the work that will be performed
in the analysis, and why. The details of the actual steps taken using `R` are
explained in `run_analysis.org`.

## Making Things Right

We need to "make things right" in regards to the data. We can do this
methodically if we take a breath and think through the standard analytical
questions, namely:

-   How many rows are there?
-   What are the columns names and types?
-   Are the data types what we want?
-   Do we need to convert them to something else?
-   Does the data have `NA` and is that OK or not?

The easiest way to do that is with a combination of `Excel` and `R`. A nice way to
codify it is with unit tests that are part of the code itself. There we can
check for:

-   Expected number of rows
-   Expected number of columns

### How To Do It

The most important task here is to start whittling down the scope of this project
from infinity to something accmplishable. First make sense of the sample types.

Having read `README.txt` it becomes clear that there are some obvious categorical
and quantitative measures in the samples somewhere:
-   Categorical
    -   Person ID: their unique identifier for them
    -   Activity: the action that they were performing when the sample was taken
        -   See `activity_labels.txt`
-   Quantitative
    -   Basically everything else
    -   There are a lot of them, see `features.txt`
    -   There are samples for every dimension of `X`, `Y`, and `Z`
    -   There is a lot of summary data there, see `features_info.txt`
        -   We only care about mean and standard deviation
        -   They are already in there for each kind of sample
        -   There is a naming standard such that every sample name of that kind
            ends with either `mean-()` or `std()` following by a dash and then the
            dimension

This is a good start, but there is clearly more to the story. It is actually
hard to know why it is set up this way, but surely there is a good reason. So,
going forward there is a big question of what to do with all of the separate
files. The data is split up into separate files because some are used to train
their system and the rest is used to test their system. That is obvious so we
know we can merge those samples together. But still, what are they?

There are files for both `test` and `train`. The most confusing part of this is
what exactly are the files communicating? It is not obvious.

The `subject` files have subject Ids in them. You can see that the IDs for the
training are not in the testing. Also, they go up to 30, and we know that there
are that many subjects. Assumption is they have the same number of samples as
the other X and Y files. What are those though?

Staring at them you see that X has all of the samples that are defined in
features.txt because a single row of data is so long. What then is Y? It looks like
it could be subject id, but it never goes above 6. We know from looking at
`activity_labels.txt` that there are only 6 kinds of activities, so that is what
lives in there. Again, the assumption is that there are the same number of rows.

Basically:
-   X is tabular
-   Y and activity<sub>labels</sub> is a column that needs to be added to the tabular data
-   The description data then serves as the fundamental link in getting the data into
    a presentable form for the reader.

The remainder of the work is getting the data into a desirable, tidying it,
and summarizing it for the reader.

All in all it is a very straight forward project once the data makes sense.
