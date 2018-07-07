
<!-- README.md is generated from README.Rmd. Please edit that file -->
unheadr <img src="man/figures/logosmall.png" align="right" />
=============================================================

The goal of unheadr is to help wrangle data (often other people's) when it has too many header rows, or when values are wrapped across several rows.

Installation
------------

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("luisDVA/unheadr")
```

Usage
-----

``` r
data(primates2017)
# head(primates2017,n=20)
```

The first half of the dataset looks like this:

Notice the rows (e.g. 1, 2, 16 and 20) that actually correspond to values in grouping variables which should be in their own colum. Instead, they are embedded within the data rectangle. To be fair, this is a pretty common practice. In formatted tables and spreadsheets, this information is often centered and merged and shown with nice little colors and font formatting. This looks nice and is easy to read, but hard to work with (for example: counting elements or calculating group-wise summaries).

In this example, values for an implicit 'geographic region' variable and an implicit 'taxonomic family' are embedded in the column that contains our observational units (the scientific names of various primates).

| scientific\_name             | common\_name                 | red\_list\_status |  mass\_kg|
|:-----------------------------|:-----------------------------|:------------------|---------:|
| Asia                         | NA                           | NA                |        NA|
| CERCOPITHECIDAE              | NA                           | NA                |        NA|
| Trachypithecus obscurus      | Dusky Langur                 | NT                |      7.13|
| Presbytis sumatra            | Black Sumatran Langur        | EN                |      6.00|
| Rhinopithecus roxellana      | Golden Snub-nosed Monkey     | EN                |        NA|
| Trachypithecus auratus       | East Javan Langur            | VU                |      6.25|
| Semnopithecus johnii         | Nilgiri Langur               | VU                |     11.45|
| Trachypithecus delacouri     | Delacour's Langur            | CR                |        NA|
| Trachypithecus leucocephalus | White-headed Langur          | CR                |      8.00|
| Presbytis comata             | Javan Langur                 | EN                |      6.70|
| Macaca pagensis              | Pagai Macaque                | CR                |      4.50|
| Trachypithecus germaini      | Germain's Langur             | EN                |      8.83|
| Macaca munzala               | Arunachal Macaque            | EN                |        NA|
| Macaca mulatta               | Rhesus Macaque               | LC                |      9.90|
| Semnopithecus hector         | Terai Sacred Langur          | NT                |     15.20|
| HYLOBATIDAE                  | NA                           | NA                |        NA|
| Hylobates funereus           | East Bornean Gray Gibbon     | EN                |        NA|
| Hylobates klossii            | Kloss's Gibbon               | EN                |      5.80|
| Nomascus concolor            | Western Black Crested Gibbon | CR                |      7.71|
| LORISIDAE                    | NA                           | NA                |        NA|

For a tidier structure, these extraneous 'header' rows in the *scientific\_name* column need to be plucked out and placed in their own variable. This is the main objective of *unheadr* and what its flagship function *untangle2* was made for.

If these non-data rows can be matched in bulk with a regular expression because they share a prefix, suffix, or any other commonalities, we can save a lot of time. Otherwise, they can be matched by name.

Sorting out the jumbled mess in the example data:

``` r
# put taxonomic family in its own variable (matches the suffix "DAE")
untangle2(primates2017,"DAE$",scientific_name,family)
# put geographic regions in their own variable (matching them all by name)
untangle2(primates2017,"Asia|Madagascar|Mainland Africa|Neotropics",scientific_name,family)
```

The function can be used with *magrittr* pipes as a dplyr-type verb.

``` r
primates2017 %>%
    untangle2("DAE$",scientific_name,family) %>%
    untangle2("Asia|Madagascar|Mainland Africa|Neotropics",scientific_name,region) %>% head(n=20)
```

| scientific\_name             | common\_name                 | red\_list\_status |  mass\_kg| family          | region     |
|:-----------------------------|:-----------------------------|:------------------|---------:|:----------------|:-----------|
| Trachypithecus obscurus      | Dusky Langur                 | NT                |      7.13| CERCOPITHECIDAE | Asia       |
| Presbytis sumatra            | Black Sumatran Langur        | EN                |      6.00| CERCOPITHECIDAE | Asia       |
| Rhinopithecus roxellana      | Golden Snub-nosed Monkey     | EN                |        NA| CERCOPITHECIDAE | Asia       |
| Trachypithecus auratus       | East Javan Langur            | VU                |      6.25| CERCOPITHECIDAE | Asia       |
| Semnopithecus johnii         | Nilgiri Langur               | VU                |     11.45| CERCOPITHECIDAE | Asia       |
| Trachypithecus delacouri     | Delacour's Langur            | CR                |        NA| CERCOPITHECIDAE | Asia       |
| Trachypithecus leucocephalus | White-headed Langur          | CR                |      8.00| CERCOPITHECIDAE | Asia       |
| Presbytis comata             | Javan Langur                 | EN                |      6.70| CERCOPITHECIDAE | Asia       |
| Macaca pagensis              | Pagai Macaque                | CR                |      4.50| CERCOPITHECIDAE | Asia       |
| Trachypithecus germaini      | Germain's Langur             | EN                |      8.83| CERCOPITHECIDAE | Asia       |
| Macaca munzala               | Arunachal Macaque            | EN                |        NA| CERCOPITHECIDAE | Asia       |
| Macaca mulatta               | Rhesus Macaque               | LC                |      9.90| CERCOPITHECIDAE | Asia       |
| Semnopithecus hector         | Terai Sacred Langur          | NT                |     15.20| CERCOPITHECIDAE | Asia       |
| Hylobates funereus           | East Bornean Gray Gibbon     | EN                |        NA| HYLOBATIDAE     | Asia       |
| Hylobates klossii            | Kloss's Gibbon               | EN                |      5.80| HYLOBATIDAE     | Asia       |
| Nomascus concolor            | Western Black Crested Gibbon | CR                |      7.71| HYLOBATIDAE     | Asia       |
| Nycticebus menagensis        | Philippine Slow Loris        | VU                |      0.28| LORISIDAE       | Asia       |
| Nycticebus bengalensis       | Bengal Slow Loris            | VU                |      1.21| LORISIDAE       | Asia       |
| Allocebus trichotis          | Hairy-eared Dwarf Lemur      | VU                |      0.09| CHEIROGALEIDAE  | Madagascar |
| Microcebus tavaratra         | Tavaratra Mouse Lemur        | VU                |      0.06| CHEIROGALEIDAE  | Madagascar |

Now we can easily perform grouping operations and summarize the data (e.g.: calculating average body mass by Family).

At this point, refer to the links in the vignette and the function help for more information and examples on the use of the other helper functions.