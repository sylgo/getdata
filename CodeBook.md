
# Introduction

This codebook is very straightforward because the explanation of all of the
work is provided in `run_analysis.md`. The detailed work is provided there.
This document contains a look at the generated *tidy* dataset and its columns and
types.

# Overview

Load the tidy data set after generating it.

```R
dfTidy <- read.table(dfTidy, "./dfTidy.txt", row.name=FALSE)
```

Verify the number rows are what we expect at 180 with 30 subjects and 6 groups.

```R
subs <- length(levels(dfTidy$subjectID))
subs
assert_that(subs==30)
acts <- length(levels(dfTidy$activityID))
acts
assert_that(acts==6)
groupcheck <- subs * acts
groupcheck
assert_that(nrow(dfTidy) == groupcheck)
```

    [1] 30
    [1] TRUE
    [1] 6
    [1] TRUE
    [1] 180
    [1] TRUE

Report on the column types. They are values that come from sensors that define
either a XYZ dimensions of a rate for a measurement at one of those dimensions.
We have to factors for subjectID and categoryID and numbers for **everything** else.

```R
str(dfTidy)
```

    Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':         180 obs. of  68 variables:
     $ subjectID                                                                                                                                            : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 2 2 2 2 ...
     $ activityID                                                                                                                                           : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 2 3 4 5 6 1 2 3 4 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the X axis.                       : num  0.277 0.255 0.289 0.261 0.279 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the Y axis.                       : num  -0.01738 -0.02395 -0.00992 -0.00131 -0.01614 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the Z axis.                       : num  -0.1111 -0.0973 -0.1076 -0.1045 -0.1106 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the X axis.         : num  -0.284 -0.355 0.03 -0.977 -0.996 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the Y axis.         : num  0.11446 -0.00232 -0.03194 -0.92262 -0.97319 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the Z axis.         : num  -0.26 -0.0195 -0.2304 -0.9396 -0.9798 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the X axis.                    : num  0.935 0.893 0.932 0.832 0.943 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the Y axis.                    : num  -0.282 -0.362 -0.267 0.204 -0.273 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the Z axis.                    : num  -0.0681 -0.0754 -0.0621 0.332 0.0135 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the X axis.      : num  -0.977 -0.956 -0.951 -0.968 -0.994 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the Y axis.      : num  -0.971 -0.953 -0.937 -0.936 -0.981 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the Z axis.      : num  -0.948 -0.912 -0.896 -0.949 -0.976 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the X axis.                  : num  0.074 0.1014 0.0542 0.0775 0.0754 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the Y axis.                  : num  0.028272 0.019486 0.02965 -0.000619 0.007976 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the Z axis.                  : num  -0.00417 -0.04556 -0.01097 -0.00337 -0.00369 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the X axis.    : num  -0.1136 -0.4468 -0.0123 -0.9864 -0.9946 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the Y axis.    : num  0.067 -0.378 -0.102 -0.981 -0.986 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the Z axis.    : num  -0.503 -0.707 -0.346 -0.988 -0.992 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the X axis.                        : num  -0.0418 0.0505 -0.0351 -0.0454 -0.024 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the Y axis.                        : num  -0.0695 -0.1662 -0.0909 -0.0919 -0.0594 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the Z axis.                        : num  0.0849 0.0584 0.0901 0.0629 0.0748 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the X axis.          : num  -0.474 -0.545 -0.458 -0.977 -0.987 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the Y axis.          : num  -0.05461 0.00411 -0.12635 -0.96647 -0.98773 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the Z axis.          : num  -0.344 -0.507 -0.125 -0.941 -0.981 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the X axis.                    : num  -0.09 -0.1222 -0.074 -0.0937 -0.0996 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the Y axis.                    : num  -0.0398 -0.0421 -0.044 -0.0402 -0.0441 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the Z axis.                    : num  -0.0461 -0.0407 -0.027 -0.0467 -0.049 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the X axis.      : num  -0.207 -0.615 -0.487 -0.992 -0.993 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the Y axis.      : num  -0.304 -0.602 -0.239 -0.99 -0.995 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the Z axis.      : num  -0.404 -0.606 -0.269 -0.988 -0.992 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration magnitude by time                            : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration magnitude by time              : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration magnitude by time                         : num  -0.137 -0.1299 0.0272 -0.9485 -0.9843 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration magnitude by time           : num  -0.2197 -0.325 0.0199 -0.9271 -0.9819 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk magnitude by time                       : num  -0.1414 -0.4665 -0.0894 -0.9874 -0.9924 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk magnitude by time         : num  -0.0745 -0.479 -0.0258 -0.9841 -0.9931 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope magnitude by time                               : num  -0.161 -0.1267 -0.0757 -0.9309 -0.9765 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope magnitude by time                 : num  -0.187 -0.149 -0.226 -0.935 -0.979 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time Mag                               : num  -0.299 -0.595 -0.295 -0.992 -0.995 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time Mag                 : num  -0.325 -0.649 -0.307 -0.988 -0.995 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the X axis.                    : num  -0.2028 -0.4043 0.0382 -0.9796 -0.9952 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the Y axis.                    : num  0.08971 -0.19098 0.00155 -0.94408 -0.97707 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the Z axis.                    : num  -0.332 -0.433 -0.226 -0.959 -0.985 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the X axis.      : num  -0.3191 -0.3374 0.0243 -0.9764 -0.996 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the Y axis.      : num  0.056 0.0218 -0.113 -0.9173 -0.9723 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the Z axis.      : num  -0.28 0.086 -0.298 -0.934 -0.978 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the X axis.                : num  -0.1705 -0.4799 -0.0277 -0.9866 -0.9946 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the Y axis.                : num  -0.0352 -0.4134 -0.1287 -0.9816 -0.9854 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the Z axis.                : num  -0.469 -0.685 -0.288 -0.986 -0.991 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the X axis.  : num  -0.1336 -0.4619 -0.0863 -0.9875 -0.9951 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the Y axis.  : num  0.107 -0.382 -0.135 -0.983 -0.987 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the Z axis.  : num  -0.535 -0.726 -0.402 -0.988 -0.992 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the X axis.                     : num  -0.339 -0.493 -0.352 -0.976 -0.986 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the Y axis.                     : num  -0.1031 -0.3195 -0.0557 -0.9758 -0.989 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the Z axis.                     : num  -0.2559 -0.4536 -0.0319 -0.9513 -0.9808 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the X axis.       : num  -0.517 -0.566 -0.495 -0.978 -0.987 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the Y axis.       : num  -0.0335 0.1515 -0.1814 -0.9623 -0.9871 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the Z axis.       : num  -0.437 -0.572 -0.238 -0.944 -0.982 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration magnitude frequency                          : num  -0.1286 -0.3524 0.0966 -0.9478 -0.9854 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration magnitude frequency            : num  -0.398 -0.416 -0.187 -0.928 -0.982 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk magnitude frequency                     : num  -0.0571 -0.4427 0.0262 -0.9853 -0.9925 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk magnitude frequency       : num  -0.103 -0.533 -0.104 -0.982 -0.993 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic magnitude by body frequency                    : num  -0.199 -0.326 -0.186 -0.958 -0.985 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic magnitude by body frequency      : num  -0.321 -0.183 -0.398 -0.932 -0.978 ...
     $ Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk magnitude by body frequency               : num  -0.319 -0.635 -0.282 -0.99 -0.995 ...
     $ Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk magnitude by body frequency : num  -0.382 -0.694 -0.392 -0.987 -0.995 ...
     - attr(*, "vars")=List of 1
      ..$ : symbol subjectID
     - attr(*, "drop")= logi TRUE

Report on the summary statistics.

```R
summary(dfTidy)
```

      subjectID                activityID
    1      :  6   WALKING           :30
    2      :  6   WALKING_UPSTAIRS  :30
    3      :  6   WALKING_DOWNSTAIRS:30
    4      :  6   SITTING           :30
    5      :  6   STANDING          :30
    6      :  6   LAYING            :30
    (Other):144
    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the X axis.
    Min.   :0.2216
    1st Qu.:0.2712
    Median :0.2770
    Mean   :0.2743
    3rd Qu.:0.2800
    Max.   :0.3015

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the Y axis.
    Min.   :-0.040514
    1st Qu.:-0.020022
    Median :-0.017262
    Mean   :-0.017876
    3rd Qu.:-0.014936
    Max.   :-0.001308

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration by time on the Z axis.
    Min.   :-0.15251
    1st Qu.:-0.11207
    Median :-0.10819
    Mean   :-0.10916
    3rd Qu.:-0.10443
    Max.   :-0.07538

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the X axis.
    Min.   :-0.9961
    1st Qu.:-0.9799
    Median :-0.7526
    Mean   :-0.5577
    3rd Qu.:-0.1984
    Max.   : 0.6269

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the Y axis.
    Min.   :-0.99024
    1st Qu.:-0.94205
    Median :-0.50897
    Mean   :-0.46046
    3rd Qu.:-0.03077
    Max.   : 0.61694

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration by time on the Z axis.
    Min.   :-0.9877
    1st Qu.:-0.9498
    Median :-0.6518
    Mean   :-0.5756
    3rd Qu.:-0.2306
    Max.   : 0.6090

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the X axis.
    Min.   :-0.6800
    1st Qu.: 0.8376
    Median : 0.9208
    Mean   : 0.6975
    3rd Qu.: 0.9425
    Max.   : 0.9745

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the Y axis.
    Min.   :-0.47989
    1st Qu.:-0.23319
    Median :-0.12782
    Mean   :-0.01621
    3rd Qu.: 0.08773
    Max.   : 0.95659

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration by time on the Z axis.
    Min.   :-0.49509
    1st Qu.:-0.11726
    Median : 0.02384
    Mean   : 0.07413
    3rd Qu.: 0.14946
    Max.   : 0.95787

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the X axis.
    Min.   :-0.9968
    1st Qu.:-0.9825
    Median :-0.9695
    Mean   :-0.9638
    3rd Qu.:-0.9509
    Max.   :-0.8296

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the Y axis.
    Min.   :-0.9942
    1st Qu.:-0.9711
    Median :-0.9590
    Mean   :-0.9524
    3rd Qu.:-0.9370
    Max.   :-0.6436

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration by time on the Z axis.
    Min.   :-0.9910
    1st Qu.:-0.9605
    Median :-0.9450
    Mean   :-0.9364
    3rd Qu.:-0.9180
    Max.   :-0.6102

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the X axis.
    Min.   :0.04269
    1st Qu.:0.07396
    Median :0.07640
    Mean   :0.07947
    3rd Qu.:0.08330
    Max.   :0.13019

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the Y axis.
    Min.   :-0.0386872
    1st Qu.: 0.0004664
    Median : 0.0094698
    Mean   : 0.0075652
    3rd Qu.: 0.0134008
    Max.   : 0.0568186

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk by time on the Z axis.
    Min.   :-0.067458
    1st Qu.:-0.010601
    Median :-0.003861
    Mean   :-0.004953
    3rd Qu.: 0.001958
    Max.   : 0.038053

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the X axis.
    Min.   :-0.9946
    1st Qu.:-0.9832
    Median :-0.8104
    Mean   :-0.5949
    3rd Qu.:-0.2233
    Max.   : 0.5443

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the Y axis.
    Min.   :-0.9895
    1st Qu.:-0.9724
    Median :-0.7756
    Mean   :-0.5654
    3rd Qu.:-0.1483
    Max.   : 0.3553

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk by time on the Z axis.
    Min.   :-0.99329
    1st Qu.:-0.98266
    Median :-0.88366
    Mean   :-0.73596
    3rd Qu.:-0.51212
    Max.   : 0.03102

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the X axis.
    Min.   :-0.20578
    1st Qu.:-0.04712
    Median :-0.02871
    Mean   :-0.03244
    3rd Qu.:-0.01676
    Max.   : 0.19270

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the Y axis.
    Min.   :-0.20421
    1st Qu.:-0.08955
    Median :-0.07318
    Mean   :-0.07426
    3rd Qu.:-0.06113
    Max.   : 0.02747

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope frequency on the Z axis.
    Min.   :-0.07245
    1st Qu.: 0.07475
    Median : 0.08512
    Mean   : 0.08744
    3rd Qu.: 0.10177
    Max.   : 0.17910

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the X axis.
    Min.   :-0.9943
    1st Qu.:-0.9735
    Median :-0.7890
    Mean   :-0.6916
    3rd Qu.:-0.4414
    Max.   : 0.2677

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the Y axis.
    Min.   :-0.9942
    1st Qu.:-0.9629
    Median :-0.8017
    Mean   :-0.6533
    3rd Qu.:-0.4196
    Max.   : 0.4765

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope frequency on the Z axis.
    Min.   :-0.9855
    1st Qu.:-0.9609
    Median :-0.8010
    Mean   :-0.6164
    3rd Qu.:-0.3106
    Max.   : 0.5649

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the X axis.
    Min.   :-0.15721
    1st Qu.:-0.10322
    Median :-0.09868
    Mean   :-0.09606
    3rd Qu.:-0.09110
    Max.   :-0.02209

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the Y axis.
    Min.   :-0.07681
    1st Qu.:-0.04552
    Median :-0.04112
    Mean   :-0.04269
    3rd Qu.:-0.03842
    Max.   :-0.01320

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time on the Z axis.
    Min.   :-0.092500
    1st Qu.:-0.061725
    Median :-0.053430
    Mean   :-0.054802
    3rd Qu.:-0.048985
    Max.   :-0.006941

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the X axis.
    Min.   :-0.9965
    1st Qu.:-0.9800
    Median :-0.8396
    Mean   :-0.7036
    3rd Qu.:-0.4629
    Max.   : 0.1791

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the Y axis.
    Min.   :-0.9971
    1st Qu.:-0.9832
    Median :-0.8942
    Mean   :-0.7636
    3rd Qu.:-0.5861
    Max.   : 0.2959

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time on the Z axis.
    Min.   :-0.9954
    1st Qu.:-0.9848
    Median :-0.8610
    Mean   :-0.7096
    3rd Qu.:-0.4741
    Max.   : 0.1932

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration magnitude by time
    Min.   :-0.9865
    1st Qu.:-0.9573
    Median :-0.4829
    Mean   :-0.4973
    3rd Qu.:-0.0919
    Max.   : 0.6446

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration magnitude by time
    Min.   :-0.9865
    1st Qu.:-0.9430
    Median :-0.6074
    Mean   :-0.5439
    3rd Qu.:-0.2090
    Max.   : 0.4284

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of gravity acceleration magnitude by time
    Min.   :-0.9865
    1st Qu.:-0.9573
    Median :-0.4829
    Mean   :-0.4973
    3rd Qu.:-0.0919
    Max.   : 0.6446

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of gravity acceleration magnitude by time
    Min.   :-0.9865
    1st Qu.:-0.9430
    Median :-0.6074
    Mean   :-0.5439
    3rd Qu.:-0.2090
    Max.   : 0.4284

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk magnitude by time
    Min.   :-0.9928
    1st Qu.:-0.9807
    Median :-0.8168
    Mean   :-0.6079
    3rd Qu.:-0.2456
    Max.   : 0.4345

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk magnitude by time
    Min.   :-0.9946
    1st Qu.:-0.9765
    Median :-0.8014
    Mean   :-0.5842
    3rd Qu.:-0.2173
    Max.   : 0.4506

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscope magnitude by time
    Min.   :-0.9807
    1st Qu.:-0.9461
    Median :-0.6551
    Mean   :-0.5652
    3rd Qu.:-0.2159
    Max.   : 0.4180

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscope magnitude by time
    Min.   :-0.9814
    1st Qu.:-0.9476
    Median :-0.7420
    Mean   :-0.6304
    3rd Qu.:-0.3602
    Max.   : 0.3000

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk by time Mag
    Min.   :-0.99732
    1st Qu.:-0.98515
    Median :-0.86479
    Mean   :-0.73637
    3rd Qu.:-0.51186
    Max.   : 0.08758

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk by time Mag
    Min.   :-0.9977
    1st Qu.:-0.9805
    Median :-0.8809
    Mean   :-0.7550
    3rd Qu.:-0.5767
    Max.   : 0.2502

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the X axis.
    Min.   :-0.9952
    1st Qu.:-0.9787
    Median :-0.7691
    Mean   :-0.5758
    3rd Qu.:-0.2174
    Max.   : 0.5370

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the Y axis.
    Min.   :-0.98903
    1st Qu.:-0.95361
    Median :-0.59498
    Mean   :-0.48873
    3rd Qu.:-0.06341
    Max.   : 0.52419

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequencyy on the Z axis.
    Min.   :-0.9895
    1st Qu.:-0.9619
    Median :-0.7236
    Mean   :-0.6297
    3rd Qu.:-0.3183
    Max.   : 0.2807

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the X axis.
    Min.   :-0.9966
    1st Qu.:-0.9820
    Median :-0.7470
    Mean   :-0.5522
    3rd Qu.:-0.1966
    Max.   : 0.6585

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the Y axis.
    Min.   :-0.99068
    1st Qu.:-0.94042
    Median :-0.51338
    Mean   :-0.48148
    3rd Qu.:-0.07913
    Max.   : 0.56019

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequencyy on the Z axis.
    Min.   :-0.9872
    1st Qu.:-0.9459
    Median :-0.6441
    Mean   :-0.5824
    3rd Qu.:-0.2655
    Max.   : 0.6871

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the X axis.
    Min.   :-0.9946
    1st Qu.:-0.9828
    Median :-0.8126
    Mean   :-0.6139
    3rd Qu.:-0.2820
    Max.   : 0.4743

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the Y axis.
    Min.   :-0.9894
    1st Qu.:-0.9725
    Median :-0.7817
    Mean   :-0.5882
    3rd Qu.:-0.1963
    Max.   : 0.2767

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk frequency on the Z axis.
    Min.   :-0.9920
    1st Qu.:-0.9796
    Median :-0.8707
    Mean   :-0.7144
    3rd Qu.:-0.4697
    Max.   : 0.1578

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the X axis.
    Min.   :-0.9951
    1st Qu.:-0.9847
    Median :-0.8254
    Mean   :-0.6121
    3rd Qu.:-0.2475
    Max.   : 0.4768

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the Y axis.
    Min.   :-0.9905
    1st Qu.:-0.9737
    Median :-0.7852
    Mean   :-0.5707
    3rd Qu.:-0.1685
    Max.   : 0.3498

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk frequency on the Z axis.
    Min.   :-0.993108
    1st Qu.:-0.983747
    Median :-0.895121
    Mean   :-0.756489
    3rd Qu.:-0.543787
    Max.   :-0.006236

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the X axis.
    Min.   :-0.9931
    1st Qu.:-0.9697
    Median :-0.7300
    Mean   :-0.6367
    3rd Qu.:-0.3387
    Max.   : 0.4750

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the Y axis.
    Min.   :-0.9940
    1st Qu.:-0.9700
    Median :-0.8141
    Mean   :-0.6767
    3rd Qu.:-0.4458
    Max.   : 0.3288

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration frequency on the Z axis.
    Min.   :-0.9860
    1st Qu.:-0.9624
    Median :-0.7909
    Mean   :-0.6044
    3rd Qu.:-0.2635
    Max.   : 0.4924

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the X axis.
    Min.   :-0.9947
    1st Qu.:-0.9750
    Median :-0.8086
    Mean   :-0.7110
    3rd Qu.:-0.4813
    Max.   : 0.1966

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the Y axis.
    Min.   :-0.9944
    1st Qu.:-0.9602
    Median :-0.7964
    Mean   :-0.6454
    3rd Qu.:-0.4154
    Max.   : 0.6462

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration frequency on the Z axis.
    Min.   :-0.9867
    1st Qu.:-0.9643
    Median :-0.8224
    Mean   :-0.6577
    3rd Qu.:-0.3916
    Max.   : 0.5225

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration magnitude frequency
    Min.   :-0.9868
    1st Qu.:-0.9560
    Median :-0.6703
    Mean   :-0.5365
    3rd Qu.:-0.1622
    Max.   : 0.5866

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration magnitude frequency
    Min.   :-0.9876
    1st Qu.:-0.9452
    Median :-0.6513
    Mean   :-0.6210
    3rd Qu.:-0.3654
    Max.   : 0.1787

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body acceleration jerk magnitude frequency
    Min.   :-0.9940
    1st Qu.:-0.9770
    Median :-0.7940
    Mean   :-0.5756
    3rd Qu.:-0.1872
    Max.   : 0.5384

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body acceleration jerk magnitude frequency
    Min.   :-0.9944
    1st Qu.:-0.9752
    Median :-0.8126
    Mean   :-0.5992
    3rd Qu.:-0.2668
    Max.   : 0.3163

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic magnitude by body frequency
    Min.   :-0.9865
    1st Qu.:-0.9616
    Median :-0.7657
    Mean   :-0.6671
    3rd Qu.:-0.4087
    Max.   : 0.2040

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic magnitude by body frequency
    Min.   :-0.9815
    1st Qu.:-0.9488
    Median :-0.7727
    Mean   :-0.6723
    3rd Qu.:-0.4277
    Max.   : 0.2367

    Mean gravity acceleration magnitude by time gravity acceleration magnitude by time of body gyroscopic jerk magnitude by body frequency
    Min.   :-0.9976
    1st Qu.:-0.9813
    Median :-0.8779
    Mean   :-0.7564
    3rd Qu.:-0.5831
    Max.   : 0.1466

    Standard gravity acceleration magnitude by time gravity acceleration magnitude by time deviation of body gyroscopic jerk magnitude by body frequency
    Min.   :-0.9976
    1st Qu.:-0.9802
    Median :-0.8941
    Mean   :-0.7715
    3rd Qu.:-0.6081
    Max.   : 0.2878
