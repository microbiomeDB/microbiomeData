<!-- badges: start -->
  [![R-CMD-check](https://github.com/microbiomeDB/microbiomeData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/microbiomeDB/microbiomeData/actions/workflows/R-CMD-check.yaml)
  [![](https://dcbadge.limes.pink/api/server/DEjNbxgq?style=flat)](https://discord.gg/DEjNbxgq)
  <!-- badges: end -->


# microbiomeData
An R package containing all of the curated datasets from MicrobiomeDB.org and a helper function to list which datasets are available.

If you have questions or comments of any kind, join us on our [Discord Community Server](https://discord.gg/DEjNbxgq)! We'd love to hear from you.

## Installation

Use the R package [remotes](https://cran.r-project.org/web/packages/remotes/index.html) to install microbiomeData. From the R command prompt:

```R
remotes::install_github('microbiomeDB/microbiomeData')
```

### Troubleshooting Installation Issues

#### Maaslin2 Installation

If you encounter difficulties installing `Maaslin2` try installing from GitHub directly:

```R
remotes::install_github("biobakery/Maaslin2")
```

#### SpiecEasi and gfortran on macOS

If you encounter errors related to `gfortran` when installing `SpiecEasi`, particularly errors like:

```
ld: library 'emutls_w' not found
ld: warning: search path '/opt/gfortran/lib' not found
```

This typically occurs when gfortran is installed via Homebrew but R expects it in a different location. The recommended solution is to install the official gfortran from the R project:

1. Download and install gfortran from: https://github.com/R-macos/gcc-14-branch/releases
2. Restart R and try installing again

Alternatively, if you have gfortran installed via Homebrew (`/opt/homebrew/bin/gfortran`), you may need to create symlinks or set appropriate environment variables.

### Important: Dependency Change (v1.0.7+)

Starting with version 1.0.7, this package depends on `mbioUtils` instead of `veupathUtils`. If you're updating from an older version and encounter issues, you may need to:

```R
# Remove old installation
remove.packages(c("microbiomeData", "MicrobiomeDB", "microbiomeComputations", "veupathUtils"))
# Reinstall fresh
remotes::install_github('microbiomeDB/microbiomeData')
```

## Usage
This package contains all of the curated datasets from MicrobiomeDB.org. It is an extension to the [MicrobiomeDB R package](https://github.com/microbiomeDB/MicrobiomeDB) which can be used to analyze and visualize these data. That package is installed and attached with this one.

### Direct Usage
You can get a list of all curated datasets available within this package by doing the following:

```R
microbiomeData::getCuratedDatsetNames()
myData <- microbiomeData::DiabImmune
```

Once you have your favorite dataset as `myData`, you can ask for specific collections from that dataset. A collection is any group of variables that represent a biologically coherent concept and are measured over a comparable range. Relative abundances at a specific taxonomic rank are an example. That might look something like:

```R
getCollectionNames(myData) # will print the names of collections
myCollection <- getCollection(myData, '16S (V4) Species')

```

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt)
