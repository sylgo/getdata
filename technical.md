
# Overview

The aim of this project is to achieve 100% reproducibility and transparency.
Great efforts have been made to do so. Part of that effort is in attaining
[idempotency](https://en.wikipedia.org/wiki/Idempotence); which means that the program can be run any number of times and
guaranteed to provide the same results. The easiest way to work towards this
goal is make it *crystal clear* the nature of the environment in which this
analysis was performed. There a are two steps to that process, setting up the
computing environment and then setting up the data environment. This document
addresses only the former.

# Computational Environment

The operating system on this computer is [Apple OSX](https://www.apple.com/osx/).

    archey

                 ###
               ####                   User: gcr
               ###                    Hostname: orion
       #######    #######             Distro: OS X 10.9.3
     ######################           Kernel: Darwin
    #####################             Uptime:  5:41
    ####################              Shell: /usr/local/bin/bash
    ####################              Terminal: dumb
    #####################             Packages: 78
     ######################           CPU: Intel Core i7-4960HQ CPU @ 2.60GHz
      ####################            Memory: 16 GB
        ################              Disk: 20%
         ####     #####

The package manager is [Homebrew](http://brew.sh/).

    brew --version

    0.9.5

The editor is [GNU Emacs](https://www.gnu.org/software/emacs/).

    (print emacs-version)

    "24.3.1"

The literate programming system is [org-mode](http://orgmode.org/).

    (print org-version)

    "8.2.7c"

# Analytical Environment

The statistical environment used is [The R Project](http://www.r-project.org/).

    r --version

    R version 3.1.1 (2014-07-10) -- "Sock it to Me"
    Copyright (C) 2014 The R Foundation for Statistical Computing
    Platform: x86_64-apple-darwin13.2.0 (64-bit)

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under the terms of the
    GNU General Public License versions 2 or 3.
    For more information about these matters see
    http://www.gnu.org/licenses/.

A support tool for working with `R` in `emacs` used is [Emacs Speaks Statistics (ESS)](http://ess.r-project.org/).

    (print ess-version)

    "14.08"

The `.Renviron`.

    cat ~/.Renviron

    R_LIBS=~/.Rpackages

The `.Rprofile`.

    cat ~/.Rprofile

    local({
        r = getOption("repos")
        r["CRAN"] = "http://cran.r-project.org/"
        options(repos = r)
    })
    options(browserNLdisabled = TRUE)
    options("digits.secs"=3)
    options(prompt="ℝ> ")
    options(stringsAsFactors=TRUE)
    options(showWarnCalls=TRUE)
    options(showErrorCalls=TRUE)
    options(error=NULL)
    options(warn=0)
    options(max.print=500)
    options(warnPartialMatchDollar = TRUE)
    Sys.setenv(LANG = "en_US.UTF-8")
    Sys.setlocale("LC_COLLATE", "en_US.UTF-8")
    Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")
    library(assertthat)
    library(testthat)
    library(stringr)
    library(sqldf)
    library(MASS)
    library(jsonlite)
    library(data.table)
    library(xlsx)
    library(XML)
    library(magrittr)
    library(devtools)
    library(reshape2)
    library(tidyr)
    library(lubridate)
    library(plyr)
    library(dplyr)
    .First <- function() {
        gcr <- new.env()
        gcr$attach.unsafe <- attach
        gcr$attach <- function(...) {
            warning("NEVER USE ATTACH! Use `unsafe.attach` if you must.")
            attach.unsafe(...)
        }
        gcr$require <- function(...) {
            warning("Are you sure you wanted `require` instead of `library`?")
            base::require(...)
        }
        gcr$lsnofun <- function(name = parent.frame()) {
            obj <- ls(name = name)
            obj[!sapply(obj, function(x) is.function(get(x)))]
        }
        gcr$recoveronerror <- function() {
            options(error=recover)
        }

        gcr$recoveronerroroff <- function() {
            options(error=NULL)
        }
        gcr$erroronwarn <- function() {
            options(warn=2)
        }

        gcr$erroronwarnoff <- function() {
            options(warn=0)
        }
        options(sqldf.driver = "SQLite")
        gcr$printdf <- function(df) {
            if (nrow(df) > 10) {
                print(head(df, 5))
                cat("---\n")
                print(tail(df, 5))
            } else {
                print(df)
            }
        }
        gcr$printlen <- function(len=500) {
            options("max.print" = len)
        }
        gcr$hundred <- function(df, idx=0) {
            df[idx:(idx+100),]
        }
        base::attach(gcr, name="gcr", warn.conflicts = FALSE)
    }
